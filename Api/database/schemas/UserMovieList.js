const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const userMovieListSchema = new Schema({
    user: { type: Schema.ObjectId, ref: 'User' },
    group_id: { type: Schema.ObjectId, ref: 'Group' },
    movies: [{ type: Schema.ObjectId, ref: 'Movie'}]
});

userMovieListSchema.plugin(immutablePlugin);

const UserMovieList = mongoose.model('UserMovieList', userMovieListSchema);

module.exports = UserMovieList;
