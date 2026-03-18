const express = require('express');
const router = express.Router();
const db = require('../db');

// GET /learn - browse all slang
router.get('/', async (req, res) => {
  try {
    const { category, difficulty, search } = req.query;
    let query = 'SELECT * FROM slang_terms WHERE 1=1';
    const params = [];

    if (category && category !== 'all') {
      params.push(category);
      query += ` AND category = $${params.length}`;
    }
    if (difficulty && difficulty !== 'all') {
      params.push(difficulty);
      query += ` AND difficulty = $${params.length}`;
    }
    if (search) {
      params.push(`%${search}%`);
      query += ` AND (term ILIKE $${params.length} OR definition ILIKE $${params.length})`;
    }

    query += ' ORDER BY term ASC';
    const result = await db.query(query, params);

    // Get categories for filter
    const catResult = await db.query('SELECT DISTINCT category FROM slang_terms ORDER BY category');
    const categories = catResult.rows.map(r => r.category);

    // Get user learned terms if logged in
    let learnedIds = [];
    if (req.session.user) {
      const prog = await db.query(
        'SELECT slang_id FROM user_progress WHERE user_id = $1 AND learned = TRUE',
        [req.session.user.id]
      );
      learnedIds = prog.rows.map(r => r.slang_id);
    }

    res.render('learn/index', {
      title: 'Learn Slang',
      terms: result.rows,
      categories,
      filters: { category: category || 'all', difficulty: difficulty || 'all', search: search || '' },
      learnedIds
    });
  } catch (err) {
    console.error(err);
    res.render('error', { title: 'Error', message: err.message });
  }
});

// GET /learn/:id - single term detail
router.get('/:id', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM slang_terms WHERE id = $1', [req.params.id]);
    if (result.rows.length === 0) return res.status(404).render('404', { title: '404' });

    const term = result.rows[0];

    // Related terms (same category)
    const related = await db.query(
      'SELECT id, term, definition FROM slang_terms WHERE category = $1 AND id != $2 LIMIT 4',
      [term.category, term.id]
    );

    // Mark as learned if logged in
    let isLearned = false;
    if (req.session.user) {
      const prog = await db.query(
        'SELECT learned FROM user_progress WHERE user_id = $1 AND slang_id = $2',
        [req.session.user.id, term.id]
      );
      isLearned = prog.rows.length > 0 && prog.rows[0].learned;
    }

    res.render('learn/term', {
      title: term.term,
      term,
      related: related.rows,
      isLearned
    });
  } catch (err) {
    console.error(err);
    res.render('error', { title: 'Error', message: err.message });
  }
});

// POST /learn/:id/mark-learned
router.post('/:id/mark-learned', async (req, res) => {
  if (!req.session.user) return res.json({ success: false, msg: 'Not logged in' });

  try {
    await db.query(
      `INSERT INTO user_progress (user_id, slang_id, learned, learned_at)
       VALUES ($1, $2, TRUE, NOW())
       ON CONFLICT (user_id, slang_id) DO UPDATE SET learned = TRUE, learned_at = NOW()`,
      [req.session.user.id, req.params.id]
    );
    // Award XP
    await db.query('UPDATE users SET xp = xp + 10 WHERE id = $1', [req.session.user.id]);
    req.session.user.xp += 10;
    res.json({ success: true, xp: req.session.user.xp });
  } catch (err) {
    res.json({ success: false, msg: err.message });
  }
});

// GET /learn/characters/brainrot
router.get('/characters/brainrot', async (req, res) => {
  try {
    const result = await db.query('SELECT * FROM brainrot_characters ORDER BY name');
    res.render('learn/characters', {
      title: 'Brainrot Characters',
      characters: result.rows
    });
  } catch (err) {
    res.render('error', { title: 'Error', message: err.message });
  }
});

module.exports = router;
