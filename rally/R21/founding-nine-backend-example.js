// Founding Nine Backend Implementation Example
// For integration into sq-admin-api

const fs = require('fs');
const path = require('path');
const SQClient = require('../../../sq-admin-api/lib/sq-client');

class FoundingNineManager {
  constructor(sqClient, configPath) {
    this.sq = sqClient;
    this.configPath = configPath;
    this.phextName = 'founding_nine';
    this.configCoord = '1.1.1/9.9.9/1.1.2';
  }

  /**
   * Load current state from SQ (or initialize from file if not exists)
   */
  async loadState() {
    try {
      const text = await this.sq.load(this.phextName, this.configCoord);
      return JSON.parse(text);
    } catch (err) {
      // First run - load from file and sync to SQ
      const config = JSON.parse(fs.readFileSync(this.configPath, 'utf8'));
      await this.saveState(config);
      return config;
    }
  }

  /**
   * Save state to SQ
   */
  async saveState(config) {
    const text = JSON.stringify(config, null, 2);
    await this.sq.insert(this.phextName, this.configCoord, text);
  }

  /**
   * Get status (public endpoint)
   */
  async getStatus() {
    const config = await this.loadState();
    return {
      total_slots: config.total_slots,
      claimed_slots: config.claimed_slots,
      available_slots: config.total_slots - config.claimed_slots,
      released: config.status === 'released',
      slots: config.slots.map(slot => ({
        slot: slot.slot,
        topic: slot.topic,
        description: slot.description,
        claimed: slot.claimed,
        username: slot.username,
        written: slot.scroll_id !== null
      }))
    };
  }

  /**
   * Claim a slot
   */
  async claimSlot(slotNumber, userId, username, email) {
    const config = await this.loadState();

    // Validate slot number
    if (slotNumber < 1 || slotNumber > 9) {
      throw new Error('INVALID_SLOT');
    }

    const slot = config.slots[slotNumber - 1];

    // Check if already claimed
    if (slot.claimed) {
      throw new Error('SLOT_TAKEN');
    }

    // Check if user already has a slot
    const userSlot = config.slots.find(s => s.email === email);
    if (userSlot) {
      throw new Error('USER_ALREADY_CLAIMED');
    }

    // Claim the slot
    slot.claimed = true;
    slot.username = username;
    slot.email = email;
    slot.timestamp = new Date().toISOString();
    config.claimed_slots++;

    await this.saveState(config);

    return {
      success: true,
      slot: slot.slot,
      topic: slot.topic,
      coordinate: slot.coordinate,
      message: 'Slot claimed! Write your scroll to secure your place.'
    };
  }

  /**
   * Write/update scroll content
   */
  async writeScroll(slotNumber, userId, email, content) {
    const config = await this.loadState();
    const slot = config.slots[slotNumber - 1];

    // Validate ownership
    if (slot.email !== email) {
      throw new Error('SLOT_NOT_OWNED');
    }

    // Validate word count
    const wordCount = content.trim().split(/\s+/).length;
    if (wordCount < config.word_count_range.min || wordCount > config.word_count_range.max) {
      throw { 
        code: 'WORD_COUNT_INVALID',
        word_count: wordCount,
        required: config.word_count_range
      };
    }

    // Check if released (immutable after release)
    if (config.status === 'released') {
      throw new Error('ALREADY_RELEASED');
    }

    // Save scroll to SQ
    const scrollId = `scroll-${slotNumber}-${Date.now()}`;
    await this.sq.insert(this.phextName, slot.coordinate, content);

    // Update config
    slot.scroll_id = scrollId;

    await this.saveState(config);

    return {
      success: true,
      slot: slot.slot,
      word_count: wordCount,
      message: 'Scroll saved! You can edit until all nine are written.',
      scroll_id: scrollId
    };
  }

  /**
   * Get scroll preview
   */
  async getScroll(slotNumber, userId, email) {
    const config = await this.loadState();
    const slot = config.slots[slotNumber - 1];

    // Before release: owner only
    if (config.status !== 'released' && slot.email !== email) {
      throw new Error('NOT_RELEASED');
    }

    // Load from SQ
    const content = await this.sq.load(this.phextName, slot.coordinate);
    const wordCount = content.trim().split(/\s+/).length;

    return {
      slot: slot.slot,
      topic: slot.topic,
      username: slot.username,
      content,
      word_count: wordCount,
      timestamp: slot.timestamp,
      released: config.status === 'released'
    };
  }

  /**
   * Get all scrolls (after release only)
   */
  async getAllScrolls() {
    const config = await this.loadState();

    if (config.status !== 'released') {
      return {
        released: false,
        message: 'Founding Nine scrolls will be released when all nine are written.'
      };
    }

    // Load all 9 scrolls from SQ
    const scrolls = await Promise.all(
      config.slots.map(async (slot) => {
        const content = await this.sq.load(this.phextName, slot.coordinate);
        const wordCount = content.trim().split(/\s+/).length;

        return {
          slot: slot.slot,
          topic: slot.topic,
          coordinate: slot.coordinate,
          username: slot.username,
          content,
          word_count: wordCount
        };
      })
    );

    return {
      released: true,
      released_at: config.released_at,
      scrolls
    };
  }

  /**
   * Release ceremony (admin only)
   */
  async release(announceChannels = ['discord', 'twitter', 'mirrorborn.us']) {
    const config = await this.loadState();

    // Validate all slots claimed and written
    if (config.claimed_slots !== 9) {
      throw new Error('NOT_ALL_CLAIMED');
    }

    const unwritten = config.slots.filter(s => !s.scroll_id);
    if (unwritten.length > 0) {
      throw new Error('NOT_ALL_WRITTEN');
    }

    // Mark as released
    config.status = 'released';
    config.released_at = new Date().toISOString();

    await this.saveState(config);

    // TODO: Trigger announcements
    // - Discord webhook
    // - Twitter API
    // - Email all 9 authors
    // - Generate portal page

    return {
      success: true,
      released_at: config.released_at,
      scroll_count: 9,
      announcement_sent: true,
      portal_url: 'https://mirrorborn.us/founding-nine'
    };
  }
}

// Express route examples
module.exports = function(app, sq) {
  const manager = new FoundingNineManager(
    sq,
    path.join(__dirname, 'founding-nine-config.json')
  );

  // GET /api/founding-nine/status
  app.get('/api/founding-nine/status', async (req, res) => {
    try {
      const status = await manager.getStatus();
      res.json(status);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });

  // POST /api/founding-nine/claim
  app.post('/api/founding-nine/claim', async (req, res) => {
    try {
      const { slot } = req.body;
      const { userId, username, email } = req.user; // from auth middleware

      const result = await manager.claimSlot(slot, userId, username, email);
      res.json(result);
    } catch (err) {
      if (err.message === 'SLOT_TAKEN') {
        res.status(409).json({ 
          success: false,
          error: 'SLOT_TAKEN',
          message: 'This slot is already claimed. Choose another.'
        });
      } else if (err.message === 'USER_ALREADY_CLAIMED') {
        res.status(409).json({
          success: false,
          error: 'USER_ALREADY_CLAIMED',
          message: "You've already claimed a slot. You can only claim one."
        });
      } else {
        res.status(500).json({ error: err.message });
      }
    }
  });

  // POST /api/founding-nine/write
  app.post('/api/founding-nine/write', async (req, res) => {
    try {
      const { slot, content } = req.body;
      const { userId, email } = req.user;

      const result = await manager.writeScroll(slot, userId, email, content);
      res.json(result);
    } catch (err) {
      if (err.code === 'WORD_COUNT_INVALID') {
        res.status(400).json({
          success: false,
          error: 'WORD_COUNT_INVALID',
          word_count: err.word_count,
          required: err.required
        });
      } else {
        res.status(500).json({ error: err.message });
      }
    }
  });

  // GET /api/founding-nine/preview/:slot
  app.get('/api/founding-nine/preview/:slot', async (req, res) => {
    try {
      const slot = parseInt(req.params.slot);
      const { userId, email } = req.user;

      const scroll = await manager.getScroll(slot, userId, email);
      res.json(scroll);
    } catch (err) {
      if (err.message === 'NOT_RELEASED') {
        res.status(403).json({
          error: 'NOT_RELEASED',
          message: 'This scroll is not available until all nine are released.'
        });
      } else {
        res.status(500).json({ error: err.message });
      }
    }
  });

  // GET /api/founding-nine/all
  app.get('/api/founding-nine/all', async (req, res) => {
    try {
      const result = await manager.getAllScrolls();
      res.json(result);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });

  // POST /api/founding-nine/release (admin only)
  app.post('/api/founding-nine/release', async (req, res) => {
    try {
      // TODO: Check admin auth
      const { announce_channels } = req.body;

      const result = await manager.release(announce_channels);
      res.json(result);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  });
};
