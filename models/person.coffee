mongoose = require 'mongoose'
auth = require 'mongoose-auth'
env = require '../config/env'

# auth decoration
PersonSchema = new mongoose.Schema
PersonSchema.plugin auth,
  everymodule:
    everyauth: { User: () -> Person }
  github:
    everyauth:
      myHostname: if env.production then 'http://nodeknockout.com' else 'http://localhost:8000'
      appId: env.secrets.github_app_id
      appSecret: env.secrets.github_secret
      redirectPath: '/'
mongoose.model 'Person', PersonSchema

module.exports = Person = mongoose.model 'Person'
