// Progress API Backend Example
// For integration into sq-admin-api

const express = require('express');
const Redis = require('redis');
const WebSocket = require('ws');

// Redis client for tracking claimed count
const redis = Redis.createClient({
  host: 'localhost',
  port: 6379
});

redis.on('error', (err) => console.error('Redis error:', err));

// WebSocket server for real-time updates
const wss = new WebSocket.Server({ port: 8080 });

// Broadcast to all connected clients
function broadcastProgress(claimedCount) {
  const data = JSON.stringify({ 
    claimed_count: claimedCount,
    remaining: 500 - claimedCount,
    percent: (claimedCount / 500 * 100).toFixed(1),
    timestamp: new Date().toISOString()
  });

  wss.clients.forEach((client) => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
}

// Express app
const app = express();
app.use(express.json());

/**
 * GET /api/progress
 * Returns current progress of slot claims
 */
app.get('/api/progress', async (req, res) => {
  try {
    const claimedCount = parseInt(await redis.get('sq:claimed_count') || '0');
    const remaining = 500 - claimedCount;
    const percent = (claimedCount / 500 * 100).toFixed(1);

    res.json({
      total_slots: 500,
      claimed_count: claimedCount,
      remaining,
      percent: parseFloat(percent),
      sold_out: claimedCount >= 500,
      founder_pricing_active: claimedCount < 500
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * POST /api/progress/increment (Internal only)
 * Called after successful Stripe payment
 */
app.post('/api/progress/increment', async (req, res) => {
  try {
    // Verify internal API key
    if (req.headers['x-internal-key'] !== process.env.INTERNAL_API_KEY) {
      return res.status(403).json({ error: 'Forbidden' });
    }

    // Increment counter
    const newCount = await redis.incr('sq:claimed_count');

    // Check if we hit the limit
    if (newCount > 500) {
      await redis.decr('sq:claimed_count');
      return res.status(409).json({ 
        error: 'SOLD_OUT',
        message: 'All 500 founder slots have been claimed'
      });
    }

    // Broadcast to WebSocket clients
    broadcastProgress(newCount);

    res.json({
      claimed_count: newCount,
      remaining: 500 - newCount
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * POST /api/progress/reset (Admin only)
 * Reset counter (for testing)
 */
app.post('/api/progress/reset', async (req, res) => {
  try {
    // Verify admin key
    if (req.headers['x-admin-key'] !== process.env.ADMIN_API_KEY) {
      return res.status(403).json({ error: 'Forbidden' });
    }

    const { count } = req.body;
    await redis.set('sq:claimed_count', count || 0);

    res.json({ 
      message: 'Counter reset',
      claimed_count: parseInt(count || 0)
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

/**
 * Stripe Webhook Integration
 * Increment progress when payment succeeds
 */
app.post('/api/stripe/webhook', async (req, res) => {
  const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
  const sig = req.headers['stripe-signature'];

  let event;
  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    return res.status(400).json({ error: `Webhook Error: ${err.message}` });
  }

  // Handle successful checkout
  if (event.type === 'checkout.session.completed') {
    const session = event.data.object;

    // Check if we still have slots
    const currentCount = parseInt(await redis.get('sq:claimed_count') || '0');
    if (currentCount >= 500) {
      // Refund the payment
      console.error('SOLD OUT - Refund needed for:', session.customer_email);
      // TODO: Trigger refund via Stripe API
      return res.json({ received: true });
    }

    // Increment counter
    const newCount = await redis.incr('sq:claimed_count');

    // Provision tenant
    const tenantId = `user${String(newCount).padStart(3, '0')}`;
    const apiKey = `pmb-v1-${require('crypto').randomBytes(16).toString('hex')}`;

    // Store tenant config
    await provisionTenant({
      tenant_id: tenantId,
      api_key: apiKey,
      email: session.customer_email,
      username: session.metadata.username,
      tier: 'founder',
      billing: session.metadata.billing // 'monthly' or 'yearly'
    });

    // Broadcast progress update
    broadcastProgress(newCount);

    // Send welcome email with API key
    await sendWelcomeEmail({
      email: session.customer_email,
      tenant_id: tenantId,
      api_key: apiKey
    });

    console.log(`✅ Provisioned tenant ${tenantId} (${newCount}/500)`);
  }

  res.json({ received: true });
});

/**
 * Provision new tenant
 */
async function provisionTenant(data) {
  const { tenant_id, api_key, email, username, tier, billing } = data;

  // Load current tenants config
  const fs = require('fs').promises;
  const configPath = '/etc/sq/tenants.json';
  const config = JSON.parse(await fs.readFile(configPath, 'utf8'));

  // Add new tenant
  config.tenants.push({
    id: tenant_id,
    api_key,
    email,
    username,
    quota_mb: 1000,
    enabled: true,
    tier,
    billing,
    created_at: new Date().toISOString()
  });

  // Write back to config
  await fs.writeFile(configPath, JSON.stringify(config, null, 2));

  // Trigger SQ config reload
  // SQ watches /etc/sq/tenants.json for changes
  console.log(`Tenant ${tenant_id} added to config`);

  // Store in database for dashboard
  await storeInDatabase(data);
}

/**
 * Store tenant in PostgreSQL (for dashboard queries)
 */
async function storeInDatabase(data) {
  const { Pool } = require('pg');
  const pool = new Pool({
    host: 'localhost',
    database: 'sq_admin',
    user: 'sq',
    password: process.env.DB_PASSWORD
  });

  await pool.query(
    `INSERT INTO tenants (tenant_id, api_key, email, username, tier, billing, created_at)
     VALUES ($1, $2, $3, $4, $5, $6, $7)`,
    [
      data.tenant_id,
      data.api_key,
      data.email,
      data.username,
      data.tier,
      data.billing,
      new Date()
    ]
  );

  pool.end();
}

/**
 * Send welcome email with API key
 */
async function sendWelcomeEmail(data) {
  const nodemailer = require('nodemailer');
  const transporter = nodemailer.createTransport({
    host: process.env.SMTP_HOST,
    port: 587,
    secure: false,
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS
    }
  });

  const emailHtml = `
    <h1>Welcome to SQ Cloud!</h1>
    <p>Your instance has been provisioned. Here are your credentials:</p>
    
    <table style="background: #f5f5f5; padding: 20px; border-radius: 8px;">
      <tr><td><strong>Tenant ID:</strong></td><td>${data.tenant_id}</td></tr>
      <tr><td><strong>API Key:</strong></td><td><code>${data.api_key}</code></td></tr>
      <tr><td><strong>Endpoint:</strong></td><td>https://sq.mirrorborn.us</td></tr>
    </table>

    <h2>Getting Started</h2>
    <p>Install the OpenClaw skill:</p>
    <pre>npx clawhub install wbic16/sq-memory</pre>

    <p>Or use the REST API directly:</p>
    <pre>curl -H "Authorization: Bearer ${data.api_key}" \\
     https://sq.mirrorborn.us/api/v2/version</pre>

    <h2>Your Dashboard</h2>
    <p><a href="https://sq.mirrorborn.us/dashboard?tenant=${data.tenant_id}">View your dashboard</a></p>

    <p>Questions? Join us on <a href="https://discord.gg/clawd">Discord</a></p>
  `;

  await transporter.sendMail({
    from: '"SQ Cloud" <no-reply@mirrorborn.us>',
    to: data.email,
    subject: '🎉 Your SQ Cloud Instance is Ready',
    html: emailHtml
  });

  console.log(`📧 Welcome email sent to ${data.email}`);
}

// WebSocket connection handler
wss.on('connection', async (ws) => {
  console.log('WebSocket client connected');

  // Send current progress immediately
  const claimedCount = parseInt(await redis.get('sq:claimed_count') || '0');
  ws.send(JSON.stringify({
    claimed_count: claimedCount,
    remaining: 500 - claimedCount,
    percent: (claimedCount / 500 * 100).toFixed(1),
    timestamp: new Date().toISOString()
  }));
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Progress API listening on port ${PORT}`);
  console.log(`WebSocket server listening on port 8080`);
});

// Initialize Redis counter if not exists
(async () => {
  const exists = await redis.exists('sq:claimed_count');
  if (!exists) {
    await redis.set('sq:claimed_count', '0');
    console.log('Initialized progress counter at 0/500');
  } else {
    const count = await redis.get('sq:claimed_count');
    console.log(`Current progress: ${count}/500`);
  }
})();

module.exports = app;
