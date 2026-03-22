const { Pool } = require('pg');
require('dotenv').config();

function poolConfig() {
  if (process.env.DATABASE_URL) {
    const url = process.env.DATABASE_URL;
    return {
      connectionString: url,
      ssl: url.includes('supabase.co')
        ? { rejectUnauthorized: false }
        : undefined,
    };
  }
  const host = process.env.DB_HOST || 'localhost';
  const useSsl =
    process.env.DB_SSL === 'true' || host.includes('supabase.co');
  return {
    host,
    port: Number(process.env.DB_PORT) || 5432,
    database: process.env.DB_NAME || 'brainrot_academy',
    user: process.env.DB_USER || 'postgres',
    password: process.env.DB_PASSWORD || '',
    ssl: useSsl ? { rejectUnauthorized: false } : false,
  };
}

const pool = new Pool(poolConfig());

pool.on('connect', () => {
  console.log('✅ Connected to PostgreSQL database');
});

pool.on('error', (err) => {
  console.error('❌ Database error:', err.message);
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
};
