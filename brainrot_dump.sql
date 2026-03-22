--
-- PostgreSQL database dump
--

\restrict 5o978cdCtT9PxuFuATsasXT74rcwBs0rqpeRQMOOcEGNeBfHvcCmhhcwpQOEYl6

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: brainrot_characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brainrot_characters (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    origin text,
    image_url text,
    related_slang character varying(100)[],
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: brainrot_characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brainrot_characters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brainrot_characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brainrot_characters_id_seq OWNED BY public.brainrot_characters.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notes (
    id integer NOT NULL,
    user_id integer,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    color character varying(20) DEFAULT 'yellow'::character varying,
    pinned boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notes_id_seq OWNED BY public.notes.id;


--
-- Name: quiz_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quiz_attempts (
    id integer NOT NULL,
    user_id integer,
    score integer NOT NULL,
    total_questions integer NOT NULL,
    difficulty character varying(20),
    completed_at timestamp without time zone DEFAULT now()
);


--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quiz_attempts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quiz_attempts_id_seq OWNED BY public.quiz_attempts.id;


--
-- Name: quiz_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.quiz_questions (
    id integer NOT NULL,
    question text NOT NULL,
    correct_answer text NOT NULL,
    option_a text NOT NULL,
    option_b text NOT NULL,
    option_c text NOT NULL,
    option_d text NOT NULL,
    slang_id integer,
    difficulty character varying(20) DEFAULT 'beginner'::character varying,
    question_type character varying(30) DEFAULT 'definition'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.quiz_questions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.quiz_questions_id_seq OWNED BY public.quiz_questions.id;


--
-- Name: slang_terms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.slang_terms (
    id integer NOT NULL,
    term character varying(100) NOT NULL,
    definition text NOT NULL,
    example_sentence text,
    category character varying(50) DEFAULT 'general'::character varying,
    origin text,
    media_url text,
    media_type character varying(20) DEFAULT 'none'::character varying,
    difficulty character varying(20) DEFAULT 'beginner'::character varying,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: slang_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.slang_terms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: slang_terms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.slang_terms_id_seq OWNED BY public.slang_terms.id;


--
-- Name: user_progress; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_progress (
    id integer NOT NULL,
    user_id integer,
    slang_id integer,
    learned boolean DEFAULT false,
    learned_at timestamp without time zone
);


--
-- Name: user_progress_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_progress_id_seq OWNED BY public.user_progress.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    avatar_emoji character varying(10) DEFAULT '🐱'::character varying,
    xp integer DEFAULT 0,
    streak integer DEFAULT 0,
    last_login date,
    created_at timestamp without time zone DEFAULT now()
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: brainrot_characters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brainrot_characters ALTER COLUMN id SET DEFAULT nextval('public.brainrot_characters_id_seq'::regclass);


--
-- Name: notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes ALTER COLUMN id SET DEFAULT nextval('public.notes_id_seq'::regclass);


--
-- Name: quiz_attempts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_attempts ALTER COLUMN id SET DEFAULT nextval('public.quiz_attempts_id_seq'::regclass);


--
-- Name: quiz_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_questions ALTER COLUMN id SET DEFAULT nextval('public.quiz_questions_id_seq'::regclass);


--
-- Name: slang_terms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slang_terms ALTER COLUMN id SET DEFAULT nextval('public.slang_terms_id_seq'::regclass);


--
-- Name: user_progress id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress ALTER COLUMN id SET DEFAULT nextval('public.user_progress_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: brainrot_characters; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.brainrot_characters (id, name, description, origin, image_url, related_slang, created_at) FROM stdin;
1	Tralalero Tralala	A bizarre Italian-inspired character that became a viral meme, often depicted wearing unusual shoes. Part of the "Italian Brainrot" trend that swept TikTok.	Italian Brainrot TikTok trend, 2024	\N	\N	2026-03-18 13:21:53.236757
2	Bombardiro Crocodilo	A surreal meme character — a crocodile-airplane hybrid. Represents the absurd AI-generated Italian brainrot content style.	Italian Brainrot TikTok trend, 2024	\N	\N	2026-03-18 13:21:53.236757
3	Tung Tung Tung Sahur	A viral audio/character from Italian Brainrot content, featuring a rhythmic repetitive phrase. Became one of the most recognized brainrot sounds.	Italian Brainrot TikTok trend, 2024	\N	\N	2026-03-18 13:21:53.236757
4	Cappuccino Assassino	A coffee-themed brainrot character blending Italian culture with absurdist meme humor.	Italian Brainrot TikTok trend, 2024	\N	\N	2026-03-18 13:21:53.236757
5	Bombombini Gusini	A goose-inspired brainrot character with an Italian-sounding nonsense name. Part of the wave of AI-voiced brainrot content.	Italian Brainrot TikTok trend, 2024	\N	\N	2026-03-18 13:21:53.236757
6	Frulli Frullo	A whimsical Italian brainrot character, known for playful, child-like energy in the meme format.	Italian Brainrot TikTok trend, 2024	\N	\N	2026-03-18 13:21:53.236757
\.


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notes (id, user_id, title, content, color, pinned, created_at, updated_at) FROM stdin;
1	1	New Brainrot	tung tung tung sahur	blue	f	2026-03-18 14:01:11.75642	2026-03-18 14:01:11.75642
2	2	What is Rizz?????	someone who has a lot of charizzma hahah "chaRIZZma" YAY	yellow	f	2026-03-20 13:19:02.65758	2026-03-20 13:19:16.564796
\.


--
-- Data for Name: quiz_attempts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quiz_attempts (id, user_id, score, total_questions, difficulty, completed_at) FROM stdin;
1	1	10	10	intermediate	2026-03-18 13:32:23.47626
2	1	10	10	all	2026-03-18 14:04:37.657115
3	1	10	10	all	2026-03-18 14:12:06.517351
4	1	8	10	intermediate	2026-03-18 15:36:55.082178
5	2	6	10	intermediate	2026-03-20 13:00:59.295692
6	2	3	10	all	2026-03-20 13:17:16.374288
7	3	10	10	beginner	2026-03-20 13:50:17.461016
8	3	10	10	intermediate	2026-03-20 13:50:41.656512
9	4	4	10	intermediate	2026-03-20 13:59:58.46465
\.


--
-- Data for Name: quiz_questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.quiz_questions (id, question, correct_answer, option_a, option_b, option_c, option_d, slang_id, difficulty, question_type, created_at) FROM stdin;
1	What does "no cap" mean?	I'm telling the truth / for real	I'm lying	I'm telling the truth / for real	I have no hat	I disagree	\N	beginner	definition	2026-03-18 13:29:45.667085
2	When someone says food is "bussin," they mean it is:	Extremely delicious	On the bus	Extremely delicious	Mediocre	Too spicy	\N	beginner	definition	2026-03-18 13:29:45.667085
3	What does "rizz" refer to?	Natural charm and charisma	A type of dance	Being very smart	Natural charm and charisma	Feeling dizzy	\N	beginner	definition	2026-03-18 13:29:45.667085
4	If something is "mid," it means it is:	Average/mediocre	Amazing	Average/mediocre	Terrible	Expensive	\N	beginner	definition	2026-03-18 13:29:45.667085
5	What does "sus" mean?	Suspicious	Suspicious	Super sad	Successful	Surreal	\N	beginner	definition	2026-03-18 13:29:45.667085
6	When someone says you "understood the assignment," they mean:	You did exactly what was needed perfectly	You failed at a task	You literally read the assignment	You did exactly what was needed perfectly	You are good at school	\N	beginner	definition	2026-03-18 13:29:45.667085
7	"Delulu" is short for what word?	Delusional	Delightful	Delusional	Delectable	Deliberate	\N	beginner	wordplay	2026-03-18 13:29:45.667085
8	If you get "the ick" from someone, what has happened?	You suddenly feel repulsed by someone you liked	You suddenly feel repulsed by someone you liked	You feel extremely attracted to them	You got sick from their food	You borrowed something from them	\N	intermediate	definition	2026-03-18 13:29:45.667085
9	What does it mean to be in your "era"?	A phase of life defined by a specific mindset	A phase of life defined by a specific mindset	Living in the past	Being old-fashioned	Studying history	\N	intermediate	definition	2026-03-18 13:29:45.667085
10	What does "glazing" someone mean?	Excessive flattery to an embarrassing degree	Baking them a cake	Excessive flattery to an embarrassing degree	Painting their portrait	Ignoring them completely	\N	intermediate	definition	2026-03-18 13:29:45.667085
11	"Ate and left no crumbs" means:	Did something perfectly without any mistakes	Did something perfectly without any mistakes	Ate all the food	Made a mess	Wasted an opportunity	\N	intermediate	definition	2026-03-18 13:29:45.667085
12	In internet culture, what does "ratio" mean?	When a reply gets more engagement than the original post	A math concept	When a reply gets more engagement than the original post	When posts go viral	The number of followers someone has	\N	intermediate	context	2026-03-18 13:29:45.667085
13	What does "touch grass" suggest someone should do?	Go outside and disconnect from the internet	Go outside and disconnect from the internet	Water their lawn	Take a nature class	Become a gardener	\N	intermediate	definition	2026-03-18 13:29:45.667085
14	When someone calls you an "NPC," they are comparing you to:	A robotic/unthinking video game character	A famous gamer	A robotic/unthinking video game character	A main character in a story	A non-profit company	\N	intermediate	definition	2026-03-18 13:29:45.667085
15	"It's giving" is used to describe:	The energy or aesthetic something radiates	A generous person	Sharing something	The energy or aesthetic something radiates	A gift	\N	intermediate	definition	2026-03-18 13:29:45.667085
16	What does "no cap" mean?	I'm telling the truth / for real	I'm lying	I'm telling the truth / for real	I have no hat	I disagree	\N	beginner	definition	2026-03-18 13:30:23.430914
17	When someone says food is "bussin," they mean it is:	Extremely delicious	On the bus	Extremely delicious	Mediocre	Too spicy	\N	beginner	definition	2026-03-18 13:30:23.430914
18	What does "rizz" refer to?	Natural charm and charisma	A type of dance	Being very smart	Natural charm and charisma	Feeling dizzy	\N	beginner	definition	2026-03-18 13:30:23.430914
19	If something is "mid," it means it is:	Average/mediocre	Amazing	Average/mediocre	Terrible	Expensive	\N	beginner	definition	2026-03-18 13:30:23.430914
20	What does "sus" mean?	Suspicious	Suspicious	Super sad	Successful	Surreal	\N	beginner	definition	2026-03-18 13:30:23.430914
21	When someone says you "understood the assignment," they mean:	You did exactly what was needed perfectly	You failed at a task	You literally read the assignment	You did exactly what was needed perfectly	You are good at school	\N	beginner	definition	2026-03-18 13:30:23.430914
22	"Delulu" is short for what word?	Delusional	Delightful	Delusional	Delectable	Deliberate	\N	beginner	wordplay	2026-03-18 13:30:23.430914
23	If you get "the ick" from someone, what has happened?	You suddenly feel repulsed by someone you liked	You suddenly feel repulsed by someone you liked	You feel extremely attracted to them	You got sick from their food	You borrowed something from them	\N	intermediate	definition	2026-03-18 13:30:23.430914
24	What does it mean to be in your "era"?	A phase of life defined by a specific mindset	A phase of life defined by a specific mindset	Living in the past	Being old-fashioned	Studying history	\N	intermediate	definition	2026-03-18 13:30:23.430914
25	What does "glazing" someone mean?	Excessive flattery to an embarrassing degree	Baking them a cake	Excessive flattery to an embarrassing degree	Painting their portrait	Ignoring them completely	\N	intermediate	definition	2026-03-18 13:30:23.430914
26	"Ate and left no crumbs" means:	Did something perfectly without any mistakes	Did something perfectly without any mistakes	Ate all the food	Made a mess	Wasted an opportunity	\N	intermediate	definition	2026-03-18 13:30:23.430914
27	In internet culture, what does "ratio" mean?	When a reply gets more engagement than the original post	A math concept	When a reply gets more engagement than the original post	When posts go viral	The number of followers someone has	\N	intermediate	context	2026-03-18 13:30:23.430914
28	What does "touch grass" suggest someone should do?	Go outside and disconnect from the internet	Go outside and disconnect from the internet	Water their lawn	Take a nature class	Become a gardener	\N	intermediate	definition	2026-03-18 13:30:23.430914
29	When someone calls you an "NPC," they are comparing you to:	A robotic/unthinking video game character	A famous gamer	A robotic/unthinking video game character	A main character in a story	A non-profit company	\N	intermediate	definition	2026-03-18 13:30:23.430914
30	"It's giving" is used to describe:	The energy or aesthetic something radiates	A generous person	Sharing something	The energy or aesthetic something radiates	A gift	\N	intermediate	definition	2026-03-18 13:30:23.430914
\.


--
-- Data for Name: slang_terms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.slang_terms (id, term, definition, example_sentence, category, origin, media_url, media_type, difficulty, created_at) FROM stdin;
1	no cap	Truthfully; for real. Used to emphasize that someone is being honest and not lying.	That movie was actually fire, no cap.	general	African American Vernacular English (AAVE), popularized on social media	\N	none	beginner	2026-03-18 13:21:53.23456
2	fr fr	Short for "for real for real" — used to emphasize sincerity or agreement.	She was annoying fr fr, I had to leave early.	general	Internet slang derived from AAVE	\N	none	beginner	2026-03-18 13:21:53.23456
3	bussin	Extremely good, especially used to describe food.	These tacos are bussin, you need to try them!	food	AAVE, popularized by TikTok	\N	none	beginner	2026-03-18 13:21:53.23456
4	slay	To do something exceptionally well; to look amazing.	She absolutely slayed that presentation.	compliment	Drag culture and LGBTQ+ community, mainstreamed by social media	\N	none	beginner	2026-03-18 13:21:53.23456
5	understood the assignment	To perfectly execute or understand what was needed in a situation.	Look at her outfit — she understood the assignment.	compliment	TikTok, 2020s	\N	none	beginner	2026-03-18 13:21:53.23456
6	lowkey	Secretly; subtly; in a modest or understated way.	I lowkey want to go home right now.	general	Internet slang, early 2010s	\N	none	beginner	2026-03-18 13:21:53.23456
7	highkey	Openly; very much; the opposite of lowkey.	I highkey love this song so much.	general	Internet slang, contrast to lowkey	\N	none	beginner	2026-03-18 13:21:53.23456
8	sus	Suspicious; something or someone that seems untrustworthy.	Why are you acting so sus right now?	general	Originally from Among Us video game	\N	none	beginner	2026-03-18 13:21:53.23456
9	rent free	When something occupies your thoughts constantly without you wanting it to.	That song has been living in my head rent free all week.	general	Internet meme culture	\N	none	intermediate	2026-03-18 13:21:53.23456
10	ate (and left no crumbs)	To do something perfectly; to completely nail it.	She ate that performance and left no crumbs.	compliment	LGBTQ+ drag culture, TikTok	\N	none	intermediate	2026-03-18 13:21:53.23456
11	rizz	Natural charm or the ability to attract others through charisma.	He has unspoken rizz — he barely said anything but everyone loved him.	dating	Kai Cenat and streaming culture, 2022	\N	none	beginner	2026-03-18 13:21:53.23456
12	W	A win; something positive or successful.	Getting extra credit on that test was a huge W.	general	Gaming culture	\N	none	beginner	2026-03-18 13:21:53.23456
13	L	A loss; something negative or disappointing.	Forgetting your umbrella on a rainy day is such an L.	general	Gaming culture	\N	none	beginner	2026-03-18 13:21:53.23456
14	based	Having an opinion or lifestyle that is confident and unapologetically authentic.	He wore socks with sandals and didn't care — pretty based ngl.	general	Lil B rapper, evolved through 4chan and internet culture	\N	none	intermediate	2026-03-18 13:21:53.23456
15	mid	Mediocre; average; neither good nor bad.	The movie wasn't bad, just kinda mid.	critique	Internet slang, 2020s	\N	none	beginner	2026-03-18 13:21:53.23456
16	ngl	Not gonna lie — used before an honest or surprising admission.	Ngl, I actually enjoyed cleaning my room today.	general	Internet acronym	\N	none	beginner	2026-03-18 13:21:53.23456
17	touch grass	To go outside and disconnect from the internet; advice for someone who is too online.	After arguing about video games for 6 hours, he really needs to touch grass.	roast	Gaming and internet culture	\N	none	intermediate	2026-03-18 13:21:53.23456
18	main character	Acting as if you are the protagonist of a story; being self-centered or dramatic.	She walked in and started acting like the main character of everyone else's day.	general	TikTok aesthetic culture	\N	none	intermediate	2026-03-18 13:21:53.23456
19	vibe check	An assessment of someone's energy or mood.	He failed the vibe check as soon as he walked in complaining.	general	Social media, 2019-2020	\N	none	beginner	2026-03-18 13:21:53.23456
20	it's giving	Used to describe the energy or aesthetic something is giving off.	That outfit is giving old Hollywood glamour.	fashion	LGBTQ+ and drag culture	\N	none	intermediate	2026-03-18 13:21:53.23456
21	delulu	Delusional; having unrealistic expectations, usually about relationships.	She thinks he likes her back just from one glance — she's being delulu.	dating	TikTok, short for delusional	\N	none	beginner	2026-03-18 13:21:53.23456
22	snatched	Looking extremely good; having a great body or outfit.	Her waist is snatched after those gym sessions.	compliment	Drag and LGBTQ+ culture	\N	none	intermediate	2026-03-18 13:21:53.23456
23	ick	A sudden feeling of disgust or repulsion toward someone you previously liked.	He chewed loudly once and I got the ick — it's over.	dating	UK slang, popularized by TikTok	\N	none	beginner	2026-03-18 13:21:53.23456
24	era	A phase of life or a period defined by a certain mindset or aesthetic.	I'm in my unbothered era right now — no drama allowed.	general	Taylor Swift fan culture, TikTok	\N	none	beginner	2026-03-18 13:21:53.23456
25	NPC	Non-playable character; someone acting robotic or without independent thought.	He just agreed with everything she said — total NPC behavior.	roast	Gaming culture	\N	none	intermediate	2026-03-18 13:21:53.23456
26	Roman Empire	Something you think about frequently and randomly, often without reason.	Ancient Rome is my Roman Empire — I think about it constantly.	meme	TikTok trend, 2023	\N	none	intermediate	2026-03-18 13:21:53.23456
27	the aura	A person's overall vibe, energy, or perceived coolness.	He lost major aura points by tripping in front of everyone.	general	Online culture, 2023	\N	none	intermediate	2026-03-18 13:21:53.23456
28	glazing	Excessive flattery or praising someone to an embarrassing degree.	Stop glazing that streamer — he's just playing video games.	roast	Internet culture	\N	none	intermediate	2026-03-18 13:21:53.23456
29	ratio	When a reply gets more likes than the original post, indicating disagreement.	His take was so bad it got ratioed in minutes.	social media	Twitter/X culture	\N	none	intermediate	2026-03-18 13:21:53.23456
30	understood	Used sarcastically or sincerely to acknowledge something surprising or bold.	"I already ate the last slice." "...understood."	general	Internet meme culture	\N	none	beginner	2026-03-18 13:21:53.23456
\.


--
-- Data for Name: user_progress; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_progress (id, user_id, slang_id, learned, learned_at) FROM stdin;
1	1	25	t	2026-03-18 13:26:06.722623
2	1	28	t	2026-03-18 13:26:09.820686
3	1	22	t	2026-03-18 14:13:52.943013
4	1	13	t	2026-03-18 14:13:56.045168
5	1	26	t	2026-03-18 14:13:58.57784
6	1	14	t	2026-03-18 14:14:01.349929
7	2	12	t	2026-03-20 13:00:42.598303
8	2	13	t	2026-03-20 13:14:12.667985
9	3	13	t	2026-03-20 13:50:47.158411
10	3	6	t	2026-03-20 13:50:50.058732
11	3	2	t	2026-03-20 13:50:51.424099
12	3	7	t	2026-03-20 13:50:53.308744
13	3	1	t	2026-03-20 13:50:56.977333
14	4	25	t	2026-03-20 13:58:07.914828
15	4	13	t	2026-03-20 14:16:52.227646
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, email, password_hash, avatar_emoji, xp, streak, last_login, created_at) FROM stdin;
1	jane	jane@gmail.com	$2a$12$QTPhh7OTGNOutUa159XdQuI9qMG0xSJfmUhoZhNEGviQeXvn1aJ3C	🐸	820	1	2026-03-20	2026-03-18 13:25:31.446273
2	jam	jam@gmail.com	$2a$12$Eupl0kTzyckLLWUj8CKeDeEd6TMbD/xQSbtF6Fv9q4Wux9kkzHVq6	🔥	200	0	\N	2026-03-20 13:00:22.991776
3	kat	kat@gmail.com	$2a$12$p8DjLAMaXtC7U9LEDUhGVe1h9sn3H2j3msaOKtyUJyybvIVzBe8Ly	🐙	450	0	\N	2026-03-20 13:28:02.190336
4	hao ma	haoma@gmail.com	$2a$12$E9u9/Wf5iKvT2YAfN1VnJOBeC4BEdvCZpiET55YE31EZS.6bidRHC	🐱	100	0	\N	2026-03-20 13:57:33.153025
\.


--
-- Name: brainrot_characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.brainrot_characters_id_seq', 6, true);


--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notes_id_seq', 3, true);


--
-- Name: quiz_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quiz_attempts_id_seq', 9, true);


--
-- Name: quiz_questions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.quiz_questions_id_seq', 30, true);


--
-- Name: slang_terms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.slang_terms_id_seq', 30, true);


--
-- Name: user_progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_progress_id_seq', 15, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- Name: brainrot_characters brainrot_characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brainrot_characters
    ADD CONSTRAINT brainrot_characters_pkey PRIMARY KEY (id);


--
-- Name: notes notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: quiz_attempts quiz_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_pkey PRIMARY KEY (id);


--
-- Name: quiz_questions quiz_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_pkey PRIMARY KEY (id);


--
-- Name: slang_terms slang_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slang_terms
    ADD CONSTRAINT slang_terms_pkey PRIMARY KEY (id);


--
-- Name: slang_terms slang_terms_term_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.slang_terms
    ADD CONSTRAINT slang_terms_term_key UNIQUE (term);


--
-- Name: user_progress user_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_pkey PRIMARY KEY (id);


--
-- Name: user_progress user_progress_user_id_slang_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_user_id_slang_id_key UNIQUE (user_id, slang_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: notes notes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notes
    ADD CONSTRAINT notes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quiz_attempts quiz_attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_attempts
    ADD CONSTRAINT quiz_attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: quiz_questions quiz_questions_slang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.quiz_questions
    ADD CONSTRAINT quiz_questions_slang_id_fkey FOREIGN KEY (slang_id) REFERENCES public.slang_terms(id) ON DELETE SET NULL;


--
-- Name: user_progress user_progress_slang_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_slang_id_fkey FOREIGN KEY (slang_id) REFERENCES public.slang_terms(id) ON DELETE CASCADE;


--
-- Name: user_progress user_progress_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_progress
    ADD CONSTRAINT user_progress_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 5o978cdCtT9PxuFuATsasXT74rcwBs0rqpeRQMOOcEGNeBfHvcCmhhcwpQOEYl6

