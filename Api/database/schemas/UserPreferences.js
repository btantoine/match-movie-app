const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const userPreferencesSchema = new Schema({
    user: { type: Schema.ObjectId, ref: 'User' }, // , required: true
    list_movie: [{ type: Schema.ObjectId, ref: 'Movie' }],
    list_movie_liked: [{ type: Schema.ObjectId, ref: 'Movie' }],
    list_movie_rejected: [{ type: Schema.ObjectId, ref: 'Movie' }],
});

userPreferencesSchema.plugin(immutablePlugin);

const UserPreferences = mongoose.model('UserPreferences', userPreferencesSchema);

module.exports = UserPreferences;
