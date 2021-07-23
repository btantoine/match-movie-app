const express = require('express');
const { Group, UserMovieList, User } = require('../database/schemas');

const router = express.Router();

module.exports = router;

router.post('/', (req, res) => {
    Group.findOne({ _id: req.body.group_id }, (err, data) => {
        if (err)
            return res.status(400).send({ nogroup: "nogroup" })
        if (!data)
            return res.status(400).send({ nogroup: "nogroup" })
        if (req.body.type == "left") {
            swipedLeft(req, res)
        } else {
            swipedRight(req, res)
        }
    });
})

function swipedLeft(req, res) {
    UserMovieList.findOne({ user: req.body.user_id, group_id: req.body.group_id }).
        populate('movies').
        exec(function (err, movies) {
            if (!movies)
                res.status(400).send()
            let list_movie_to_save = []
            movies.movies.forEach(movie => {
                if (movie._id != req.body.movie_id)
                    list_movie_to_save.push(movie._id)
            });
            movies.movies = list_movie_to_save
            movies.save((err, savedUserMovieList) => {
                if (err)
                    return res.status(400).send()
                else {
                    data.list_movie_disliked.push(req.body.movie_id)
                    data.save()
                    return res.status(200).send(list_movie_to_save)
                }
            });
        });
}

function swipedRight(req, res) {
    UserMovieList.findOne({ user: req.body.user_id, group_id: req.body.group_id }).
        populate('movies').
        exec(function (err, movies) {
            if (!movies)
                return res.status(400).send()
            let list_movie_to_save = []
            movies.movies.forEach(movie => {
                if (movie._id != req.body.movie_id)
                    list_movie_to_save.push(movie._id)
            });
            movies.movies = list_movie_to_save
            movies.save((err, savedUserMovieList) => {
                if (err)
                    return res.status(400).send()
                else {
                    saveMovieLiked(req, res, data)
                }
            });
        });
}

function saveMovieLiked(req, res, data) {
    data.list_movie_liked.push(req.body.movie_id)
    data.save((err, savedMovieLiked) => {
        if (err)
            return res.status(400).send()
        let counter = 0;
        savedMovieLiked.list_movie_liked.forEach(element => {
            if (element == req.body.movie_id)
                counter += 1;
        });
        if (counter == savedMovieLiked.friends.length + 1) {
            savedMovieLiked.match_movie.push(req.body.movie_id)
            data.save((err, savedMovie) => {
                let array_promises = [];
                savedMovie.friends.push(savedMovie.user)
                savedMovie.friends.forEach(friend => {
                    array_promises.push(new Promise((resolve, reject) => {
                        User.findOne({ _id: friend }, (err, user) => {
                            if (err) { reject(); }
                            if (user) {
                                if (user.match === null)
                                    user.match = []
                                user.match.push(req.body.group_id)
                                user.save((err, savedUser) => { console.log("userSaved"); resolve() })
                            }
                        });
                    }))
                });
                Promise.all(array_promises).then((values) => {
                    return res.status(200).send({ message: "ok" })
                });
            })
        }
    });
}