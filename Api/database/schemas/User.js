const R = require('ramda');
const bcrypt = require('bcryptjs');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const userSchema = new Schema({
    userId: { type: String },
    firstName: { type: String },
    lastName: { type: String },
    username: { type: String },
    email: { type: String, maxlength: 100, required: true, unique: true, immutable: true },
    match: [{ type: Schema.ObjectId, ref: 'Group' }],
    invitation: [{ type: Schema.ObjectId, ref: 'Group' }]
});

userSchema.plugin(immutablePlugin);

const User = mongoose.model('User', userSchema);

module.exports = User;
