const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const db = require('../db');
const { redirectIfAuth } = require('../middleware/auth');

// GET /login
router.get('/login', redirectIfAuth, (req, res) => {
  const msg = req.query.msg || null;
  const error = req.query.error || null;
  res.render('auth/login', { title: 'Login', msg, error });
});

// POST /login
router.post('/login', redirectIfAuth, async (req, res) => {
  const { username, password } = req.body;
  try {
    const result = await db.query(
      'SELECT * FROM users WHERE username = $1 OR email = $1',
      [username]
    );
    if (result.rows.length === 0) {
      return res.render('auth/login', {
        title: 'Login',
        error: 'No cap, that username doesn\'t exist fr fr.',
        msg: null
      });
    }
    const user = result.rows[0];
    const valid = await bcrypt.compare(password, user.password_hash);
    if (!valid) {
      return res.render('auth/login', {
        title: 'Login',
        error: 'Wrong password bestie, try again 💀',
        msg: null
      });
    }

    // Update last login & streak
    const lastLogin = user.last_login;
    const today = new Date().toISOString().split('T')[0];
    let newStreak = user.streak;

    if (lastLogin) {
      const lastDate = new Date(lastLogin);
      const diffDays = Math.floor((new Date(today) - lastDate) / (1000 * 60 * 60 * 24));
      if (diffDays === 1) newStreak += 1;
      else if (diffDays > 1) newStreak = 1;
    } else {
      newStreak = 1;
    }

    await db.query(
      'UPDATE users SET last_login = $1, streak = $2 WHERE id = $3',
      [today, newStreak, user.id]
    );

    req.session.user = {
      id: user.id,
      username: user.username,
      email: user.email,
      avatar_emoji: user.avatar_emoji,
      xp: user.xp,
      streak: newStreak
    };

    const returnTo = req.session.returnTo || '/dashboard';
    delete req.session.returnTo;
    res.redirect(returnTo);
  } catch (err) {
    console.error(err);
    res.render('auth/login', { title: 'Login', error: 'Server error, try again.', msg: null });
  }
});

// GET /register
router.get('/register', redirectIfAuth, (req, res) => {
  res.render('auth/register', { title: 'Register', error: null });
});

// POST /register
router.post('/register', redirectIfAuth, async (req, res) => {
  const { username, email, password, confirm_password, avatar_emoji } = req.body;

  if (password !== confirm_password) {
    return res.render('auth/register', {
      title: 'Register',
      error: 'Passwords don\'t match bestie 💀'
    });
  }

  if (password.length < 6) {
    return res.render('auth/register', {
      title: 'Register',
      error: 'Password needs to be at least 6 characters, no cap.'
    });
  }

  try {
    const existing = await db.query(
      'SELECT id FROM users WHERE username = $1 OR email = $2',
      [username, email]
    );
    if (existing.rows.length > 0) {
      return res.render('auth/register', {
        title: 'Register',
        error: 'That username or email is already taken fr fr.'
      });
    }

    const hash = await bcrypt.hash(password, 12);
    const emoji = avatar_emoji || '🐱';

    const result = await db.query(
      'INSERT INTO users (username, email, password_hash, avatar_emoji) VALUES ($1, $2, $3, $4) RETURNING *',
      [username, email, hash, emoji]
    );
    const user = result.rows[0];

    req.session.user = {
      id: user.id,
      username: user.username,
      email: user.email,
      avatar_emoji: user.avatar_emoji,
      xp: 0,
      streak: 0
    };

    res.redirect('/dashboard');
  } catch (err) {
    console.error(err);
    res.render('auth/register', { title: 'Register', error: 'Server error, try again.' });
  }
});

// POST /logout
router.post('/logout', (req, res) => {
  req.session.destroy(() => {
    res.redirect('/');
  });
});

module.exports = router;
