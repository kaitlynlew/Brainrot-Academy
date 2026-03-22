const express = require('express');
const router = express.Router();
const db = require('../db');
const { requireAuth } = require('../middleware/auth');

// GET /quiz - quiz selection page
router.get('/', (req, res) => {
  res.render('quiz/index', { title: 'Quiz Time' });
});

// GET /quiz/play - get questions
router.get('/play', async (req, res) => {
  try {
    const { difficulty } = req.query;
    let query = 'SELECT * FROM quiz_questions';
    const params = [];

    if (difficulty && difficulty !== 'all') {
      params.push(difficulty);
      query += ` WHERE difficulty = $1`;
    }

    query += ' ORDER BY RANDOM() LIMIT 10';
    const result = await db.query(query, params);

    if (result.rows.length === 0) {
      return res.render('quiz/index', { title: 'Quiz Time', error: 'No questions found. Try a different difficulty!' });
    }

    res.render('quiz/play', {
      title: 'Quiz - Brainrot Academy',
      questions: result.rows,
      difficulty: difficulty || 'all'
    });
  } catch (err) {
    console.error(err);
    res.render('error', { title: 'Error', message: err.message });
  }
});

// POST /quiz/submit - save score
router.post('/submit', async (req, res) => {
  const { score, total, difficulty } = req.body;

  try {
    if (req.session.user) {
      await db.query(
        'INSERT INTO quiz_attempts (user_id, score, total_questions, difficulty) VALUES ($1, $2, $3, $4)',
        [req.session.user.id, score, total, difficulty || 'mixed']
      );
      // Award XP: 20 per correct answer
      const xpGain = parseInt(score) * 20;
      await db.query('UPDATE users SET xp = xp + $1 WHERE id = $2', [xpGain, req.session.user.id]);
      req.session.user.xp += xpGain;
    }

    res.json({ success: true, xp: req.session.user ? req.session.user.xp : null });
  } catch (err) {
    res.json({ success: false, msg: err.message });
  }
});

// GET /quiz/leaderboard
router.get('/leaderboard', async (req, res) => {
  try {
    const result = await db.query(
      `SELECT u.username, u.avatar_emoji, u.xp, u.streak,
              COUNT(qa.id) as attempts,
              MAX(qa.score) as best_score
       FROM users u
       LEFT JOIN quiz_attempts qa ON qa.user_id = u.id
       GROUP BY u.id
       ORDER BY u.xp DESC
       LIMIT 20`
    );

    res.render('quiz/leaderboard', {
      title: 'Leaderboard',
      leaders: result.rows
    });
  } catch (err) {
    res.render('error', { title: 'Error', message: err.message });
  }
});

module.exports = router;
