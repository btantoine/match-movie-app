const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const groupSchema = new Schema({
    title: { type: String },
    user: { type: Schema.ObjectId, ref: 'User' },
    friends: [{ type: Schema.ObjectId, ref: 'User' }],
    users_complete_list: [{ type: Schema.ObjectId, ref: 'User' }], // to have the green circle
    list_movie: [{ type: Schema.ObjectId, ref: 'UserMovieList' }],
    list_movie_liked: [{ type: Schema.ObjectId, ref: 'Movie' }],
    list_movie_disliked: [{ type: Schema.ObjectId, ref: 'Movie' }],
    match_movie: [{ type: Schema.ObjectId, ref: 'Movie' }],
    services: [{ type: Schema.ObjectId, ref: 'Service' }]
});

groupSchema.plugin(immutablePlugin);

const Group = mongoose.model('Group', groupSchema);

module.exports = Group;
