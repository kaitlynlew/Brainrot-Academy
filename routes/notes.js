const express = require('express');
const router = express.Router();
const db = require('../db');
const { requireAuth } = require('../middleware/auth');

// All notes routes require auth
router.use(requireAuth);

// GET /notes
router.get('/', async (req, res) => {
  try {
    const result = await db.query(
      'SELECT * FROM notes WHERE user_id = $1 ORDER BY pinned DESC, updated_at DESC',
      [req.session.user.id]
    );
    res.render('notes/index', { title: 'My Notes', notes: result.rows });
  } catch (err) {
    res.render('error', { title: 'Error', message: err.message });
  }
});

// GET /notes/new
router.get('/new', (req, res) => {
  res.render('notes/form', { title: 'New Note', note: null, error: null });
});

// POST /notes
router.post('/', async (req, res) => {
  const { title, content, color } = req.body;
  if (!title || !content) {
    return res.render('notes/form', {
      title: 'New Note',
      note: null,
      error: 'Title and content are required, no cap.'
    });
  }
  try {
    await db.query(
      'INSERT INTO notes (user_id, title, content, color) VALUES ($1, $2, $3, $4)',
      [req.session.user.id, title, content, color || 'yellow']
    );
    res.redirect('/notes');
  } catch (err) {
    res.render('notes/form', { title: 'New Note', note: null, error: err.message });
  }
});

// GET /notes/:id/edit
router.get('/:id/edit', async (req, res) => {
  try {
    const result = await db.query(
      'SELECT * FROM notes WHERE id = $1 AND user_id = $2',
      [req.params.id, req.session.user.id]
    );
    if (result.rows.length === 0) return res.redirect('/notes');
    res.render('notes/form', { title: 'Edit Note', note: result.rows[0], error: null });
  } catch (err) {
    res.render('error', { title: 'Error', message: err.message });
  }
});

// POST /notes/:id/edit (PUT simulation)
router.post('/:id/edit', async (req, res) => {
  const { title, content, color } = req.body;
  try {
    await db.query(
      `UPDATE notes SET title = $1, content = $2, color = $3, updated_at = NOW()
       WHERE id = $4 AND user_id = $5`,
      [title, content, color || 'yellow', req.params.id, req.session.user.id]
    );
    res.redirect('/notes');
  } catch (err) {
    res.render('notes/form', { title: 'Edit Note', note: req.body, error: err.message });
  }
});

// POST /notes/:id/pin
router.post('/:id/pin', async (req, res) => {
  try {
    await db.query(
      'UPDATE notes SET pinned = NOT pinned WHERE id = $1 AND user_id = $2',
      [req.params.id, req.session.user.id]
    );
    res.redirect('/notes');
  } catch (err) {
    res.redirect('/notes');
  }
});

// POST /notes/:id/delete
router.post('/:id/delete', async (req, res) => {
  try {
    await db.query(
      'DELETE FROM notes WHERE id = $1 AND user_id = $2',
      [req.params.id, req.session.user.id]
    );
    res.redirect('/notes');
  } catch (err) {
    res.redirect('/notes');
  }
});

module.exports = router;
