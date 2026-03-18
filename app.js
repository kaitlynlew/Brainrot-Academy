const express = require('express');
const session = require('express-session');
const path = require('path');
require('dotenv').config();

const app = express();

// ── Middleware ────────────────────────────────────────────────
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// ── Session ───────────────────────────────────────────────────
app.use(session({
  secret: process.env.SESSION_SECRET || 'brainrot-secret-key-change-me',
  resave: false,
  saveUninitialized: false,
  cookie: {
    secure: false, // set true in production with HTTPS
    maxAge: 1000 * 60 * 60 * 24 * 7 // 7 days
  }
}));

// ── View Engine ───────────────────────────────────────────────
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// ── Global locals for all views ───────────────────────────────
app.use((req, res, next) => {
  res.locals.user = req.session.user || null;
  res.locals.currentPath = req.path;
  next();
});

// ── Routes ────────────────────────────────────────────────────
const authRoutes = require('./routes/auth');
const learnRoutes = require('./routes/learn');
const quizRoutes = require('./routes/quiz');
const notesRoutes = require('./routes/notes');
const dashboardRoutes = require('./routes/dashboard');

app.use('/', authRoutes);
app.use('/learn', learnRoutes);
app.use('/quiz', quizRoutes);
app.use('/notes', notesRoutes);
app.use('/dashboard', dashboardRoutes);

// ── Home Route ────────────────────────────────────────────────
app.get('/', (req, res) => {
  res.render('home', { title: 'Brainrot Academy' });
});

// ── 404 Handler ───────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).render('404', { title: '404 - Not Found' });
});

// ── Error Handler ─────────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).render('error', { title: 'Error', message: err.message });
});

// ── Start Server ──────────────────────────────────────────────
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🔥 Brainrot Academy running on http://localhost:${PORT}`);
});
