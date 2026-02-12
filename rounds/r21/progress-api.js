/**
 * Progress API for Founding Member Program
 * Tracks claimed instances from founding-500-tokens.csv
 */

const express = require('express');
const fs = require('fs');
const csv = require('csv-parser');

const app = express();
const PORT = 9003;
const CSV_FILE = '/var/lib/sq/founding-500-tokens.csv';

/**
 * GET /api/founding-progress
 * Returns current claim status
 */
app.get('/api/founding-progress', async (req, res) => {
    try {
        let claimed = 0;
        let total = 0;
        
        // Read CSV and count claimed instances
        const promises = [];
        fs.createReadStream(CSV_FILE)
            .pipe(csv())
            .on('data', (row) => {
                total++;
                if (row.status === 'claimed') {
                    claimed++;
                }
            })
            .on('end', () => {
                res.json({
                    claimed,
                    total,
                    remaining: total - claimed,
                    percentage: (claimed / total * 100).toFixed(1)
                });
            })
            .on('error', (err) => {
                res.status(500).json({ error: 'Failed to read progress' });
            });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

/**
 * POST /api/claim-instance
 * Claim next available instance
 * Body: { email, stripe_customer_id }
 */
app.post('/api/claim-instance', express.json(), async (req, res) => {
    const { email, stripe_customer_id } = req.body;
    
    if (!email || !stripe_customer_id) {
        return res.status(400).json({ error: 'Missing email or stripe_customer_id' });
    }
    
    try {
        // Read CSV
        const rows = [];
        fs.createReadStream(CSV_FILE)
            .pipe(csv())
            .on('data', (row) => rows.push(row))
            .on('end', () => {
                // Find first unclaimed slot
                const slot = rows.find(r => r.status === 'unclaimed');
                
                if (!slot) {
                    return res.status(410).json({ error: 'All founding instances claimed' });
                }
                
                // Mark as claimed
                slot.status = 'claimed';
                slot.customer_email = email;
                slot.purchased_at = new Date().toISOString();
                slot.stripe_customer_id = stripe_customer_id;
                
                // Write back to CSV (TODO: use proper DB)
                const csvContent = [
                    'slot,token,name,data_dir,status,purchased_at,customer_email',
                    ...rows.map(r => `${r.slot},${r.token},${r.name},${r.data_dir},${r.status},${r.purchased_at || ''},${r.customer_email || ''}`)
                ].join('\n');
                
                fs.writeFileSync(CSV_FILE, csvContent);
                
                res.json({
                    success: true,
                    slot: slot.slot,
                    token: slot.token,
                    name: slot.name
                });
            });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(PORT, () => {
    console.log(`Founding progress API listening on :${PORT}`);
});
