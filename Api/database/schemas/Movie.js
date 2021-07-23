const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');
const random = require('mongoose-random');

const { Schema } = mongoose;

const movieSchema = new Schema({
  type: { type: String }, // movie - tvshow
  title: { type: String },
  img: { type: String },
  description: { type: String },
  grade: { type: String },
  genres: { type: String },
  rated: { type: String },
  dateCreated: { type: String },
  duration: { type: String },
  tags: { type: String },
  country: { type: String },
  servicesLink: { type: String },
  services: [{ type: Schema.ObjectId, ref: 'Service' }]
});

movieSchema.plugin(random, { path: 'r' });
movieSchema.plugin(immutablePlugin);

const Movie = mongoose.model('Movie', movieSchema);

module.exports = Movie;
