const express = require('express');
const router = express.Router();
const db = require('../db');
const { requireAuth } = require('../middleware/auth');

router.use(requireAuth);

// GET /dashboard
router.get('/', async (req, res) => {
  try {
    const userId = req.session.user.id;

    // Get fresh user data
    const userResult = await db.query('SELECT * FROM users WHERE id = $1', [userId]);
    const user = userResult.rows[0];
    req.session.user = {
      id: user.id,
      username: user.username,
      email: user.email,
      avatar_emoji: user.avatar_emoji,
      xp: user.xp,
      streak: user.streak
    };
    res.locals.user = req.session.user;

    // Stats
    const learnedCount = await db.query(
      'SELECT COUNT(*) FROM user_progress WHERE user_id = $1 AND learned = TRUE',
      [userId]
    );
    const totalTerms = await db.query('SELECT COUNT(*) FROM slang_terms');
    const quizAttempts = await db.query(
      'SELECT score, total_questions, difficulty, completed_at FROM quiz_attempts WHERE user_id = $1 ORDER BY completed_at DESC LIMIT 5',
      [userId]
    );
    const noteCount = await db.query(
      'SELECT COUNT(*) FROM notes WHERE user_id = $1', [userId]
    );
    const bestQuiz = await db.query(
      'SELECT MAX(score) as best, AVG(score::float/total_questions*100) as avg_pct FROM quiz_attempts WHERE user_id = $1',
      [userId]
    );
    const recentTerms = await db.query(
      `SELECT st.term, st.definition, up.learned_at
       FROM user_progress up
       JOIN slang_terms st ON st.id = up.slang_id
       WHERE up.user_id = $1 AND up.learned = TRUE
       ORDER BY up.learned_at DESC LIMIT 4`,
      [userId]
    );

    // XP level calculation
    const xp = user.xp;
    const level = Math.floor(xp / 100) + 1;
    const xpToNext = 100 - (xp % 100);
    const xpProgress = (xp % 100);

    res.render('dashboard/index', {
      title: 'Dashboard',
      stats: {
        learned: parseInt(learnedCount.rows[0].count),
        total: parseInt(totalTerms.rows[0].count),
        notes: parseInt(noteCount.rows[0].count),
        level,
        xp,
        xpToNext,
        xpProgress,
        streak: user.streak,
        bestQuiz: bestQuiz.rows[0].best || 0,
        avgPct: Math.round(bestQuiz.rows[0].avg_pct || 0)
      },
      recentAttempts: quizAttempts.rows,
      recentTerms: recentTerms.rows
    });
  } catch (err) {
    console.error(err);
    res.render('error', { title: 'Error', message: err.message });
  }
});

module.exports = router;
