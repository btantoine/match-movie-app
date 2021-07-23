const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const genreSchema = new Schema({
    name: { type: String },
});

genreSchema.plugin(immutablePlugin);

const Genre = mongoose.model('Genre', genreSchema);

module.exports = Genre;
