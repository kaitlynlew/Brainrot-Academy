# 🧠 Brainrot Academy

> No cap, the best way to learn Gen Z slang fr fr.

A full-stack web application for learning Gen Z slang and Italian Brainrot meme culture, built with Node.js, Express.js, EJS, and PostgreSQL.

## 👥 Team & responsibilities

The tasks completed by each team member in the project:

| Team member | Responsibilities |
|-------------|------------------|
| Kaitlyn Lew | Backend |
| Emmalee Dhaliwal | Backend |
| Jamille Vicente | Frontend |
| Cuc Vy Trinh | Documentation |

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | HTML, CSS, JavaScript |
| Templating | EJS (Embedded JavaScript) |
| Backend | Node.js + Express.js |
| Database | PostgreSQL |
| Auth | express-session + bcryptjs |

---

## 📁 Project Structure

```
brainrot-academy/
├── app.js                  # Entry point — Express app setup
├── .env.example            # Environment variables template
├── package.json
├── db/
│   ├── index.js            # PostgreSQL connection pool
│   └── schema.sql          # Database schema + seed data
├── middleware/
│   └── auth.js             # requireAuth / redirectIfAuth
├── routes/
│   ├── auth.js             # /login, /register, /logout
│   ├── learn.js            # /learn, /learn/:id
│   ├── quiz.js             # /quiz, /quiz/play, /quiz/submit
│   ├── notes.js            # /notes CRUD
│   └── dashboard.js        # /dashboard
├── views/
│   ├── partials/
│   │   ├── header.ejs
│   │   └── footer.ejs
│   ├── home.ejs
│   ├── 404.ejs
│   ├── error.ejs
│   ├── auth/
│   │   ├── login.ejs
│   │   └── register.ejs
│   ├── learn/
│   │   ├── index.ejs       # Slang dictionary browse
│   │   ├── term.ejs        # Single term detail
│   │   └── characters.ejs  # Italian Brainrot characters
│   ├── quiz/
│   │   ├── index.ejs       # Difficulty selection
│   │   ├── play.ejs        # Interactive quiz
│   │   └── leaderboard.ejs
│   ├── notes/
│   │   ├── index.ejs
│   │   └── form.ejs        # Create + Edit (shared)
│   └── dashboard/
│       └── index.ejs
└── public/
    ├── css/style.css
    └── js/main.js
```

---

## 🚀 Setup & Installation

### 1. Prerequisites
- Node.js (v18+)
- PostgreSQL (v14+)

### 2. Clone and Install

```bash
cd brainrot-academy
npm install
```

### 3. Set Up Environment Variables

```bash
cp .env.example .env
```

Edit `.env` with your database credentials:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=brainrot_academy
DB_USER=postgres
DB_PASSWORD=your_password_here
SESSION_SECRET=change_this_to_something_random
PORT=3000
```

### 4. Create the Database

```bash
psql -U postgres -c "CREATE DATABASE brainrot_academy;"
```

### 5. Run the Schema (creates tables + seeds all data)

```bash
psql -U postgres -d brainrot_academy -f db/schema.sql
```

### 6. Start the Server

```bash
# Development (with auto-reload)
npm run dev

# Production
npm start
```

Open your browser at **http://localhost:3000** 🎉

---

## ✨ Features

### 📚 Learn
- Browse 30+ Gen Z slang terms with full definitions, example sentences, and origins
- Filter by category (general, dating, food, etc.) and difficulty
- Search by term or definition
- Each term links to TikTok, YouTube, and Urban Dictionary
- Logged-in users can mark terms as Learned (+10 XP each)

### 🍕 Italian Brainrot Characters
- Dedicated page for Italian Brainrot meme characters
- Includes Tralalero Tralala, Bombardiro Crocodilo, Tung Tung Sahur, and more
- Links to TikTok and YouTube for each character

### 🎯 Quiz
- 3 difficulty modes: Beginner, Intermediate, Mixed
- 10 randomized multiple-choice questions per session
- Instant feedback after each answer (correct/wrong + explanation)
- Score results with Gen Z-flavored messages
- Logged-in users earn 20 XP per correct answer

### 🏆 Leaderboard
- Public leaderboard ranked by total XP
- Podium view for top 3 players
- Shows streak, best score, and quiz attempts

### 📝 Notes (Full CRUD)
- Create, Read, Update, Delete personal notes
- 6 color themes (yellow, pink, green, blue, purple, orange)
- Pin important notes to the top
- Requires login

### 👤 User System
- Register with username, email, password, and avatar emoji
- Secure password hashing (bcryptjs, 12 salt rounds)
- Session-based authentication
- Daily login streak tracking
- XP + level system (100 XP per level)
- Personal dashboard with stats

---

## 🗃️ Database Schema

| Table | Purpose |
|-------|---------|
| `users` | Accounts, XP, streaks, avatar |
| `slang_terms` | Gen Z slang definitions |
| `brainrot_characters` | Italian Brainrot characters |
| `quiz_questions` | Multiple choice questions |
| `quiz_attempts` | User quiz history |
| `notes` | User notes (CRUD) |
| `user_progress` | Tracks learned terms per user |

---

## 📊 Data Sources

- **Gen Z Slang**: Based on [kaspercools/genz-dataset](https://github.com/kaspercools/genz-dataset) (MIT License) — a collection of commonly used Gen Z slang scraped from publicly available sources including TikTok and Google searches.
- **Italian Brainrot Characters**: Based on publicly available information about the 2024 Italian Brainrot TikTok trend, referencing character data from [Namu Wiki](https://en.namu.wiki/w/Italian%20Brainrot/%EB%93%B1%EC%9E%A5%20%EC%BA%90%EB%A6%AD%ED%84%B0).

---

## 🎨 Design

- **Aesthetic**: Dark mode, Gen Z chaos energy — bold typography, neon accents, animated elements
- **Fonts**: Bangers (display) + Space Mono (code) + Nunito (body)
- **Colors**: Deep dark bg (#0a0a0f), red-pink primary (#ff4d6d), gold accent (#ffd60a)
- Fully responsive (mobile-first nav with hamburger menu)

---

## 👨‍💻 Development Notes

- Uses EJS partials (`header.ejs`, `footer.ejs`) for DRY templating
- All routes follow RESTful conventions (POST /notes/:id/edit simulates PUT)
- Session data stored server-side (express-session)
- XP and streak updated atomically on login
- All user data queries are parameterized to prevent SQL injection
