mongoose = require 'mongoose'
ObjectId = mongoose.Schema.ObjectId
Person = mongoose.model 'Person'

VoteSchema = module.exports = new mongoose.Schema
  personId:
    type: ObjectId
    required: true
  teamId:
    type: ObjectId
    required: true
  type:
    type: String
    required: true
    enum: Person.ROLES
  comment: String
  utility: Number
  design: Number
  innovation: Number
  completeness: Number
  audit:
    remoteAddress: String
    remotePort: Number
    userAgent: String
    referer: String
    accept: String
    requestAt: Number
    renderAt: Number
    hoverAt: Number
    responseAt: Number
VoteSchema.plugin require('mongoose-types').useTimestamps

# one vote per person-team-type
VoteSchema.index { personId: 1, teamId: 1, type: 1 }, { unique: true }
VoteSchema.index { personId: 1, updatedAt: -1 }
VoteSchema.index { teamId: 1, updatedAt: -1 }

Vote = mongoose.model 'Vote', VoteSchema
