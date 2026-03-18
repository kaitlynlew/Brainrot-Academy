-- ============================================
-- BRAINROT ACADEMY - Database Schema
-- ============================================

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  avatar_emoji VARCHAR(10) DEFAULT '🐱',
  xp INTEGER DEFAULT 0,
  streak INTEGER DEFAULT 0,
  last_login DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Slang terms table
CREATE TABLE IF NOT EXISTS slang_terms (
  id SERIAL PRIMARY KEY,
  term VARCHAR(100) UNIQUE NOT NULL,
  definition TEXT NOT NULL,
  example_sentence TEXT,
  category VARCHAR(50) DEFAULT 'general',
  origin TEXT,
  media_url TEXT,
  media_type VARCHAR(20) DEFAULT 'none',
  difficulty VARCHAR(20) DEFAULT 'beginner',
  created_at TIMESTAMP DEFAULT NOW()
);

-- Brainrot characters table
CREATE TABLE IF NOT EXISTS brainrot_characters (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  origin TEXT,
  image_url TEXT,
  related_slang VARCHAR(100)[],
  created_at TIMESTAMP DEFAULT NOW()
);

-- Quiz questions table
CREATE TABLE IF NOT EXISTS quiz_questions (
  id SERIAL PRIMARY KEY,
  question TEXT NOT NULL,
  correct_answer TEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  slang_id INTEGER REFERENCES slang_terms(id) ON DELETE SET NULL,
  difficulty VARCHAR(20) DEFAULT 'beginner',
  question_type VARCHAR(30) DEFAULT 'definition',
  created_at TIMESTAMP DEFAULT NOW()
);

-- User quiz attempts
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  score INTEGER NOT NULL,
  total_questions INTEGER NOT NULL,
  difficulty VARCHAR(20),
  completed_at TIMESTAMP DEFAULT NOW()
);

-- Notes table (CRUD feature)
CREATE TABLE IF NOT EXISTS notes (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  color VARCHAR(20) DEFAULT 'yellow',
  pinned BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- User progress tracking
CREATE TABLE IF NOT EXISTS user_progress (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  slang_id INTEGER REFERENCES slang_terms(id) ON DELETE CASCADE,
  learned BOOLEAN DEFAULT FALSE,
  learned_at TIMESTAMP,
  UNIQUE(user_id, slang_id)
);

-- ============================================
-- SEED DATA - Gen Z Slang Terms
-- ============================================

INSERT INTO slang_terms (term, definition, example_sentence, category, origin, difficulty) VALUES
('no cap', 'Truthfully; for real. Used to emphasize that someone is being honest and not lying.', 'That movie was actually fire, no cap.', 'general', 'African American Vernacular English (AAVE), popularized on social media', 'beginner'),
('fr fr', 'Short for "for real for real" — used to emphasize sincerity or agreement.', 'She was annoying fr fr, I had to leave early.', 'general', 'Internet slang derived from AAVE', 'beginner'),
('bussin', 'Extremely good, especially used to describe food.', 'These tacos are bussin, you need to try them!', 'food', 'AAVE, popularized by TikTok', 'beginner'),
('slay', 'To do something exceptionally well; to look amazing.', 'She absolutely slayed that presentation.', 'compliment', 'Drag culture and LGBTQ+ community, mainstreamed by social media', 'beginner'),
('understood the assignment', 'To perfectly execute or understand what was needed in a situation.', 'Look at her outfit — she understood the assignment.', 'compliment', 'TikTok, 2020s', 'beginner'),
('lowkey', 'Secretly; subtly; in a modest or understated way.', 'I lowkey want to go home right now.', 'general', 'Internet slang, early 2010s', 'beginner'),
('highkey', 'Openly; very much; the opposite of lowkey.', 'I highkey love this song so much.', 'general', 'Internet slang, contrast to lowkey', 'beginner'),
('sus', 'Suspicious; something or someone that seems untrustworthy.', 'Why are you acting so sus right now?', 'general', 'Originally from Among Us video game', 'beginner'),
('rent free', 'When something occupies your thoughts constantly without you wanting it to.', 'That song has been living in my head rent free all week.', 'general', 'Internet meme culture', 'intermediate'),
('ate (and left no crumbs)', 'To do something perfectly; to completely nail it.', 'She ate that performance and left no crumbs.', 'compliment', 'LGBTQ+ drag culture, TikTok', 'intermediate'),
('rizz', 'Natural charm or the ability to attract others through charisma.', 'He has unspoken rizz — he barely said anything but everyone loved him.', 'dating', 'Kai Cenat and streaming culture, 2022', 'beginner'),
('W', 'A win; something positive or successful.', 'Getting extra credit on that test was a huge W.', 'general', 'Gaming culture', 'beginner'),
('L', 'A loss; something negative or disappointing.', 'Forgetting your umbrella on a rainy day is such an L.', 'general', 'Gaming culture', 'beginner'),
('based', 'Having an opinion or lifestyle that is confident and unapologetically authentic.', 'He wore socks with sandals and didn''t care — pretty based ngl.', 'general', 'Lil B rapper, evolved through 4chan and internet culture', 'intermediate'),
('mid', 'Mediocre; average; neither good nor bad.', 'The movie wasn''t bad, just kinda mid.', 'critique', 'Internet slang, 2020s', 'beginner'),
('ngl', 'Not gonna lie — used before an honest or surprising admission.', 'Ngl, I actually enjoyed cleaning my room today.', 'general', 'Internet acronym', 'beginner'),
('touch grass', 'To go outside and disconnect from the internet; advice for someone who is too online.', 'After arguing about video games for 6 hours, he really needs to touch grass.', 'roast', 'Gaming and internet culture', 'intermediate'),
('main character', 'Acting as if you are the protagonist of a story; being self-centered or dramatic.', 'She walked in and started acting like the main character of everyone else''s day.', 'general', 'TikTok aesthetic culture', 'intermediate'),
('vibe check', 'An assessment of someone''s energy or mood.', 'He failed the vibe check as soon as he walked in complaining.', 'general', 'Social media, 2019-2020', 'beginner'),
('it''s giving', 'Used to describe the energy or aesthetic something is giving off.', 'That outfit is giving old Hollywood glamour.', 'fashion', 'LGBTQ+ and drag culture', 'intermediate'),
('delulu', 'Delusional; having unrealistic expectations, usually about relationships.', 'She thinks he likes her back just from one glance — she''s being delulu.', 'dating', 'TikTok, short for delusional', 'beginner'),
('snatched', 'Looking extremely good; having a great body or outfit.', 'Her waist is snatched after those gym sessions.', 'compliment', 'Drag and LGBTQ+ culture', 'intermediate'),
('ick', 'A sudden feeling of disgust or repulsion toward someone you previously liked.', 'He chewed loudly once and I got the ick — it''s over.', 'dating', 'UK slang, popularized by TikTok', 'beginner'),
('era', 'A phase of life or a period defined by a certain mindset or aesthetic.', 'I''m in my unbothered era right now — no drama allowed.', 'general', 'Taylor Swift fan culture, TikTok', 'beginner'),
('NPC', 'Non-playable character; someone acting robotic or without independent thought.', 'He just agreed with everything she said — total NPC behavior.', 'roast', 'Gaming culture', 'intermediate'),
('Roman Empire', 'Something you think about frequently and randomly, often without reason.', 'Ancient Rome is my Roman Empire — I think about it constantly.', 'meme', 'TikTok trend, 2023', 'intermediate'),
('the aura', 'A person''s overall vibe, energy, or perceived coolness.', 'He lost major aura points by tripping in front of everyone.', 'general', 'Online culture, 2023', 'intermediate'),
('glazing', 'Excessive flattery or praising someone to an embarrassing degree.', 'Stop glazing that streamer — he''s just playing video games.', 'roast', 'Internet culture', 'intermediate'),
('ratio', 'When a reply gets more likes than the original post, indicating disagreement.', 'His take was so bad it got ratioed in minutes.', 'social media', 'Twitter/X culture', 'intermediate'),
('understood', 'Used sarcastically or sincerely to acknowledge something surprising or bold.', '"I already ate the last slice." "...understood."', 'general', 'Internet meme culture', 'beginner')
ON CONFLICT (term) DO NOTHING;

-- ============================================
-- SEED DATA - Italian Brainrot Characters
-- ============================================

INSERT INTO brainrot_characters (name, description, origin) VALUES
('Tralalero Tralala', 'A bizarre Italian-inspired character that became a viral meme, often depicted wearing unusual shoes. Part of the "Italian Brainrot" trend that swept TikTok.', 'Italian Brainrot TikTok trend, 2024'),
('Bombardiro Crocodilo', 'A surreal meme character — a crocodile-airplane hybrid. Represents the absurd AI-generated Italian brainrot content style.', 'Italian Brainrot TikTok trend, 2024'),
('Tung Tung Tung Sahur', 'A viral audio/character from Italian Brainrot content, featuring a rhythmic repetitive phrase. Became one of the most recognized brainrot sounds.', 'Italian Brainrot TikTok trend, 2024'),
('Cappuccino Assassino', 'A coffee-themed brainrot character blending Italian culture with absurdist meme humor.', 'Italian Brainrot TikTok trend, 2024'),
('Bombombini Gusini', 'A goose-inspired brainrot character with an Italian-sounding nonsense name. Part of the wave of AI-voiced brainrot content.', 'Italian Brainrot TikTok trend, 2024'),
('Frulli Frullo', 'A whimsical Italian brainrot character, known for playful, child-like energy in the meme format.', 'Italian Brainrot TikTok trend, 2024');

-- ============================================
-- SEED DATA - Quiz Questions
-- ============================================

INSERT INTO quiz_questions (question, correct_answer, option_a, option_b, option_c, option_d, difficulty, question_type) VALUES
('What does "no cap" mean?', 'I''m telling the truth / for real', 'I''m lying', 'I''m telling the truth / for real', 'I have no hat', 'I disagree', 'beginner', 'definition'),
('When someone says food is "bussin," they mean it is:', 'Extremely delicious', 'On the bus', 'Mediocre', 'Too spicy', 'beginner', 'definition'),
('What does "rizz" refer to?', 'Natural charm and charisma', 'A type of dance', 'Being very smart', 'Feeling dizzy', 'beginner', 'definition'),
('If something is "mid," it means it is:', 'Average/mediocre', 'Amazing', 'Terrible', 'Expensive', 'beginner', 'definition'),
('What does "sus" mean?', 'Suspicious', 'Super sad', 'Successful', 'Surreal', 'beginner', 'definition'),
('When someone says you "understood the assignment," they mean:', 'You did exactly what was needed perfectly', 'You failed at a task', 'You literally read the assignment', 'You are good at school', 'beginner', 'definition'),
('"Delulu" is short for what word?', 'Delusional', 'Delightful', 'Delectable', 'Deliberate', 'beginner', 'wordplay'),
('If you get "the ick" from someone, what has happened?', 'You suddenly feel repulsed by someone you liked', 'You feel extremely attracted to them', 'You got sick from their food', 'You borrowed something from them', 'intermediate', 'definition'),
('What does it mean to be in your "era"?', 'A phase of life defined by a specific mindset', 'Living in the past', 'Being old-fashioned', 'Studying history', 'intermediate', 'definition'),
('What does "glazing" someone mean?', 'Excessive flattery to an embarrassing degree', 'Baking them a cake', 'Painting their portrait', 'Ignoring them completely', 'intermediate', 'definition'),
('"Ate and left no crumbs" means:', 'Did something perfectly without any mistakes', 'Ate all the food', 'Made a mess', 'Wasted an opportunity', 'intermediate', 'definition'),
('In internet culture, what does "ratio" mean?', 'When a reply gets more engagement than the original post', 'A math concept', 'When posts go viral', 'The number of followers someone has', 'intermediate', 'context'),
('What does "touch grass" suggest someone should do?', 'Go outside and disconnect from the internet', 'Water their lawn', 'Take a nature class', 'Become a gardener', 'intermediate', 'definition'),
('When someone calls you an "NPC," they are comparing you to:', 'A robotic/unthinking video game character', 'A famous gamer', 'A main character in a story', 'A non-profit company', 'intermediate', 'definition'),
('"It''s giving" is used to describe:', 'The energy or aesthetic something radiates', 'A generous person', 'Sharing something', 'A gift', 'intermediate', 'definition')
ON CONFLICT DO NOTHING;
