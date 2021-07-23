const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const tvshowSchema = new Schema({
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
  services: { type: String }
});

tvshowSchema.plugin(immutablePlugin);

const Tvshow = mongoose.model('Tvshow', tvshowSchema);

module.exports = Tvshow;
