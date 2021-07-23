const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const userSchema = new Schema({
    userId: { type: String },
    firstName: { type: String },
    lastName: { type: String },
    username: { type: String },
    email: { type: String, maxlength: 100, required: true, unique: true, immutable: true },
});

userSchema.plugin(immutablePlugin);

const UserLB = mongoose.model('UserLB', userSchema);

module.exports = UserLB;
