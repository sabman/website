var env = module.exports = {
  node_env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT) || 8000
};

env.is_development = env.node_env === 'development';
env.is_production = !env.is_development;

if (env.is_development) {
  try { env.secrets = require('./secrets'); }
  catch(e) { throw "secret keys file is missing. see ./secrets.js.sample."; }
} else {
  env.secrets = {
    github: process.env.GITHUB_OAUTH_SECRET,
    session: process.env.EXPRESS_SESSION_KEY
  }
}
