const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const serviceSchema = new Schema({
  title: { type: String },
  label: { type: String }
});

serviceSchema.plugin(immutablePlugin);

const Service = mongoose.model('Service', serviceSchema);

module.exports = Service;
