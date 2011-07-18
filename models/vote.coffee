mongoose = require 'mongoose'
util = require 'util'
ObjectId = mongoose.Schema.ObjectId

VoteSchema = module.exports = new mongoose.Schema
  type:
    type: String
    required: true
  person_id:
    type: ObjectId
    index: true
  team_id:
    type: ObjectId
    index: true
  upvote:
    type: Boolean

VoteSchema.method 'love', () ->
  util.log "new '#{@type}'"
  @upvote = true

VoteSchema.method 'nolove', () ->
  @upvote = false

Vote = mongoose.model 'Vote', VoteSchema
