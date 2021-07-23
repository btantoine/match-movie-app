const R = require('ramda');
const mongoose = require('mongoose');
const immutablePlugin = require('mongoose-immutable');

const { Schema } = mongoose;

const friendsSchema = new Schema({
    user: { type: Schema.ObjectId, ref: 'User' },
    friends: [{ type: Schema.ObjectId, ref: 'User'}]
});

friendsSchema.plugin(immutablePlugin);

friendsSchema.methods.hide = function() {
    return R.omit(['__v'], this.toObject());
  };
  

const Friends = mongoose.model('Friends', friendsSchema);

module.exports = Friends;
