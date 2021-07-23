const express = require('express');
const { Friends } = require('../database/schemas');
const { User } = require('../database/schemas');

const router = express.Router();

module.exports = router;

router.get('/', (req, res) => {
    Friends.findOne({ user: req.query.user_id }).
        populate('friends').
        exec(function (err, friends) {
            err ? res.status(400).send() : res.status(200).send(friends)
        });
})

router.post('/add', (req, res) => { // To improve => see fliingo create promises for each module 
    req.body.new_friend = req.body.new_friend.toLowerCase()
    req.body.new_friend = req.body.new_friend.replace(/ /g,'')
    User.findOne({ username: req.body.new_friend }, (err, new_friend) => {
        if (new_friend !== null) {
            if (new_friend._id == req.body.user)
                return res.status(200).send({ error: "error" })
            Friends.findOne({ user: req.body.user }, (err, friends) => {
                if (err) {
                    return res.status(400).send()
                }
                else {
                    if (friends === null) {
                        const newFriends = Friends(req.body);
                        newFriends.save((err, savedFriends) => {
                            if (err)
                                return res.status(400).send({ msg: "Create new friends list: failed" })
                            else {
                                !savedFriends.friends ? savedFriends.friends = [] : null
                                savedFriends.friends.push(new_friend._id)
                                savedFriends.save((err, savedFriends) => {
                                    if (err)
                                        return res.status(400).send({ msg: "Update friends list: failed" })
                                    else
                                        return res.status(200).send(new_friend)
                                });
                            }
                        });
                    } else {
                        !friends.friends ? friends.friends = [] : null
                        friends.friends.push(new_friend._id)
                        friends.save((err, savedFriends) => {
                            if (err)
                                return res.status(400).send({ msg: "Update friends list: failed" })
                            else
                                return res.status(200).send(new_friend)
                        });    
                    }
                }
            });
        } else {
            return res.status(400).send()
        }
    })
})