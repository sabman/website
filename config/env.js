var env = module.exports = {
  node_env: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT) || 8000
};

env.development = env.node_env === 'development';
env.production = !env.development;

if (env.development) {
  env.hostname = 'http://localhost:' + env.port;
  env.github_app_id = 'c07cd7100ae57921a267';
  try { env.secrets = require('./secrets'); }
  catch(e) { throw "secret keys file is missing. see ./secrets.js.sample."; }
} else {
  env.hostname = 'http://nodeknockout.com';
  env.github_app_id = 'c294545b6f2898154827';
  env.secrets = {
    github: process.env.GITHUB_OAUTH_SECRET,
    postageapp: process.env.POSTAGEAPP_SECRET,
    session: process.env.EXPRESS_SESSION_KEY
  };
}
