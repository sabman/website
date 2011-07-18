mongoose = require 'mongoose'
Person = mongoose.model 'Person'
Team = mongoose.model 'Team'

JudgedVote = new mongoose.Schema
  utilityfun:
    type: Number
    required: true
  design:
    type: Number
    required: true
  innovation:
    type: Number
    required: true
  completeness:
    type: Number
    required: true

VoteSchema = module.exports = new mongoose.Schema
  type:
    type: String
    required: true
  person:
    type: [ mongoose.Schema.ObjectId ]
    index: true
  team:
    type: [ mongoose.Schema.ObjectId ]
    index: true
  upvote:
    type: Boolean
  vote:
    type: [ JudgedVote ]