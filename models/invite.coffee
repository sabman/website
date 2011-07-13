mongoose = require 'mongoose'
rbytes = require 'rbytes'

InviteSchema = module.exports = new mongoose.Schema
  email: String
  code:
    type: String
    default: () -> rbytes.randomBytes(12).toString('base64')

mongoose.model 'Invite', InviteSchema
