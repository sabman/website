var env = module.exports = {
  node_env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT) || 8000
};

env.development = env.node_env === 'development';
env.production = !env.development;

if (env.development) {
  try { env.secrets = require('./secrets'); }
  catch(e) { throw "secret keys file is missing. see ./secrets.js.sample."; }
} else {
  env.secrets = {
    github_app_id: process.env.GITHUB_APP_ID,
    github_secret: process.env.GITHUB_OAUTH_SECRET,
    session: process.env.EXPRESS_SESSION_KEY
  };
}
