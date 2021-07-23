const express = require('express');
const { Group, UserMovieList, Movie, User } = require('../database/schemas');

const router = express.Router();

module.exports = router;

router.get('/', (req, res) => {
    Group.find({ $or: [{ 'user': req.query.user_id }, { 'friends': req.query.user_id }] }).
        populate('friends').
        populate('services').
        populate('user').
        exec(function (err, datas) {
            if (err)
                return res.status(400).send()
            else {
                return res.status(200).send(datas)
            }
        });
})

router.get('/by_invitation', (req, res) => {
    User.findOne({ _id: req.query.user_id }).
        populate('invitation').
        exec(function (err, user) {
            if (err) {
                return res.status(400).send({ message: 'No invitation', err });
            } else {
                if (user === null)
                    return res.status(200).send([])
                User.findOneAndUpdate({ _id: req.query.user_id }, { invitation: [] }, err => {
                });
                let array_promises = [];
                user.invitation.forEach(invitation => {
                    array_promises.push(new Promise((resolve, reject) => {
                        Group.findOne({ _id: invitation }).
                            populate('friends').
                            populate('services').
                            populate('user').
                            exec(function (err, datas) {
                                if (err)
                                    reject()
                                else
                                    resolve(datas)
                            });
                    }))
                });
                Promise.all(array_promises).then((values) => {
                    return res.status(200).send(values)
                });
            }
        })
})

router.get('/get_by_id', (req, res) => {
    UserMovieList.findOne({ user: req.query.user_id, group_id: req.query.group_id }).
        exec(function (err, movies) {
            if (!movies)
                return res.status(400).send()
            let array_to_return = []
            let array_promises = [];
            movies.movies.forEach(movie => {
                array_promises.push(new Promise((resolve, reject) => {
                    Movie.findOne({ _id: movie }).
                        populate('services').
                        exec(function (err, data) {
                            if (!err)
                                resolve(data)
                        })
                }))
            });
            Promise.all(array_promises).then((values) => {
                array_to_return = values;
                let new_array = transform_array(array_to_return)
                if (err) return res.status(400).send()
                else {
                    let test = add_ads(new_array)
                    return res.status(200).send(test)
                }
            });

        });
})

router.get('/movie_match', (req, res) => {
    Group.findOne({ _id: req.query.group_id }).
        populate({
            path: 'match_movie',
            populate: {
                path: "services"
            }
        }).
        exec(function (err, datas) {
            if (err)
                return res.status(400).send()
            else {
                if (datas === null || datas.match_movie === null)
                    return res.status(400).send()
                let array_to_return = []
                array_to_return = datas.match_movie;
                let new_array = transform_array(array_to_return)
                return res.status(200).send(new_array)
            }
        });
})

router.get('/get_match', (req, res) => {
    User.findOne({ _id: req.query.user_id }).
        populate('match').
        exec(function (err, user) {
            if (err) return res.status(400).send()
            else {
                let string_to_return = ""
                let counter = 0;
                if (user === null)
                    return res.status(200).send([])
                if (user.match.length > 0) {
                    user.match.forEach(element => {
                        string_to_return += element.title
                        if (counter < user.match.length - 1)
                            string_to_return += ", "
                        counter += 1;
                    });
                }
                // Empty the match field
                user.match = []
                user.save();
                if (string_to_return === "")
                    return res.status(200).send([])
                else
                    return res.status(200).send([string_to_return])
            }
        });
})

router.get('/widgetInformations', (req, res) => {
    Group.find({ $or: [{ 'user': req.query.user_id }, { 'friends': req.query.user_id }] }).
        populate('match_movie').
        populate('services').
        exec(function (err, datas) {
            if (err)
                return res.status(400).send()
            else {
                if (datas === null || datas.length <= 0)
                    return res.status(400).send()
                datas = datas[Math.floor(Math.random() * datas.length)]
                let array_to_return = []
                array_to_return = datas.match_movie;
                let new_array = transform_array_small_movie(array_to_return)
                return res.status(200).send([{ id: datas._id.toString(), title: datas.title, match_movie: new_array, services: datas.services }])
            }
        });
})


router.delete('/', (req, res) => { // To improve => see fliingo create promises for each module
    Group.findOne({ _id: req.body._id }, (err, group) => {
        if (err) {
            return res.status(400).send({ message: 'Remove group failed', err });
        } else {
            if (group.user != req.body.user_id) {
                if (group.friends.length > 0) {
                    for (var i = 0; i < group.friends.length; i++) {
                        console.log("group.friends[i] => ", group.friends[i])
                        if (group.friends[i] == req.body.user_id) {
                            group.friends.splice(i, 1);
                            i--;
                        }
                    }
                    console.log("group => ", group)
                    group.save((err, groupSaved) => {
                        return res.status(200).send({ message: 'Friend has been deleted successfully from the group' });
                    })
                } else {
                    return res.status(400).send({ notadmin: "notadmin" })
                }
            } else {
                let array_promises = []
                group.list_movie.forEach(element => {
                    UserMovieList.findOne({ _id: element }, (err, userMovieList) => {
                        if (err) {
                            res.status(400).send({ message: 'Remove group failed', err });
                        } else {
                            array_promises.push(new Promise((resolveUserMovieList, rejectUserMovieList) => {
                                userMovieList.remove(userMovieList._id, err => {
                                    if (err)
                                        rejectUserMovieList(null)
                                    else {
                                        resolveUserMovieList(null)
                                    }
                                });
                            }))
                        }
                    });
                });

                Promise.all(array_promises).then((values) => {
                    group.remove(group._id, err => {
                        res.status(200).send({ message: 'Group has been deleted successfully' });
                    });
                });
            }
        }
    });
})

router.post('/', (req, res) => { // To improve => see fliingo create promises for each module
    if (!req.body.selectedGenreRows) {
        return res.status(400).send({ needUpdate: "needUpdate" })
    }
    let filter_genre = ""
    req.body.selectedGenreRows.forEach(genre => {
        filter_genre = "".concat(filter_genre + "|", genre);
    });
    filter_genre = filter_genre.substring(1)
    if (!Array.isArray(req.body.services)) {
        return res.status(400).send({ needUpdate: "needUpdate" })
    } else {
        const newGroup = Group(req.body);
        newGroup.save((err, savedGroup) => {
            if (err)
                res.status(400).send()
            else {
                savedGroup.friends.forEach(friend => {
                    User.findOne({ _id: friend }, (err, user) => {
                        if (err) {
                            res.status(400).send({ message: 'Post group failed', err });
                        } else {
                            if (user.invitation == null)
                                user.invitation = []
                            user.invitation.push(savedGroup._id)
                            user.save()
                        }
                    })
                });
                fillUpGroupWithMovies(savedGroup, req, filter_genre).then(data => {
                    savedGroup.list_movie = data;
                    savedGroup.save()
                    res.status(200).send({ msg: "Create new Group: success" })
                })
            }
        });
    }
})

function fillUpGroupWithMovies(data, req, filter_genre) {
    return new Promise((resolve, reject) => {
        let array_promises_service = [];
        req.body.services.forEach(service => {
            array_promises_service.push(new Promise((resolveArray_promises_service, rejectArray_promises_service) => {
                let nb_item = 100 / req.body.services.length;
                if (req.body.type == "movie" && service == "601d5663e0635e0becbc7522")
                    nb_item = 5
                else if (req.body.type == "tvshow" && service == "601d5663e0635e0becbc7522")
                    nb_item = req.body.services.length < 4 ? 30 : 10
                else
                    nb_item = 100 / req.body.services.length
                Movie.findRandom({ type: req.body.type, services: service, genres: { $regex: filter_genre, $options: "i" } }).limit(nb_item).exec(function (err, movies) {
                    let list_movies = [];
                    movies.forEach(movie => {
                        list_movies.push(movie._id)
                        console.log("movie.genres => ", movie.genres)
                    });
                    resolveArray_promises_service(list_movies);
                });
            }))
        });
        Promise.all(array_promises_service).then((values) => {
            let values_to_return = []
            values.forEach(value => {
                values_to_return = [].concat(values_to_return, value);
            });
            let array_promises = []
            data.friends.forEach(element => {
                array_promises.push(new Promise((resolveUserMovieList, rejectUserMovieList) => {
                    const newUserMovieList = UserMovieList({ user: element, movies: values_to_return, group_id: data._id })
                    newUserMovieList.save((err, savedUserMovieList) => {
                        if (err)
                            rejectUserMovieList(null)
                        else {
                            resolveUserMovieList(savedUserMovieList._id)
                        }
                    });
                }))
            });
            array_promises.push(new Promise((resolveUserMovieList, rejectUserMovieList) => {
                const newUserMovieList = UserMovieList({ user: data.user, movies: values_to_return, group_id: data._id })
                newUserMovieList.save((err, savedUserMovieList) => {
                    if (err)
                        rejectUserMovieList(null)
                    else {
                        resolveUserMovieList(savedUserMovieList._id)
                    }
                });
            }))
            Promise.all(array_promises).then((values) => {
                resolve(values);
            });
        });
    });
}

function transform_array(data) { // Remove this and improve // see fliingo code 
    let new_array = []
    let counter = 0;
    data.forEach(element => {
        new_array.push({
            id: element._id.toString(),
            type: element.type ? element.type : "",
            title: element.title ? element.title : "",
            img: element.img ? element.img : "",
            description: element.description ? element.description : "",
            grade: element.grade ? element.grade : "",
            genres: element.genres ? element.genres : "",
            rated: element.rated ? element.rated : "",
            dateCreated: element.dateCreated ? element.dateCreated : "",
            duration: element.duration ? element.duration : "",
            tags: element.tags ? element.tags : "",
            country: element.country ? element.country : "",
            servicesLink: element.servicesLink ? element.servicesLink : "",
            services: element.services ? element.services : "",
            offset: 0,
            nb_current_picture: counter
        })
        counter += 1;
    });
    return new_array;
}

function transform_array_small_movie(data) {
    let new_array = []
    data.forEach(element => {
        new_array.push({
            id: element._id.toString(),
            title: element.title ? element.title : "",
            img: element.img ? element.img : ""
        })
    });
    return new_array;
}

function add_ads(datas) { // Remove this and improve // see fliingo code 
    let new_array = [];
    let counter = 0;
    datas.forEach(data => {
        if (counter === 15 || counter === 30 || counter === 45 || counter === 60 || counter === 75) {
            new_array.push({
                "id": "0",
                "type": "ad",
                "title": "ad",
                "img": "",
                "description": "",
                "grade": "",
                "genres": "",
                "rated": "",
                "dateCreated": "",
                "duration": "",
                "tags": "",
                "country": "",
                "servicesLink": "",
                "services": [],
                "offset": 0,
                "nb_current_picture": 0
            })    
        }
        new_array.push({
            "id": data.id,
            "type": data.type,
            "title": data.title,
            "img": data.img,
            "description": data.description,
            "grade": data.grade,
            "genres": data.genres,
            "rated": data.rated,
            "dateCreated": data.dateCreated,
            "duration": data.duration,
            "tags": data.tags,
            "country": data.country,
            "servicesLink": data.servicesLink,
            "services": data.services,
            "offset": data.offset,
            "nb_current_picture": data.nb_current_picture
        })
        counter += 1;
    });
    new_array.push({
        "id": "0",
        "type": "ad",
        "title": "ad",
        "img": "",
        "description": "",
        "grade": "",
        "genres": "",
        "rated": "",
        "dateCreated": "",
        "duration": "",
        "tags": "",
        "country": "",
        "servicesLink": "",
        "services": [],
        "offset": 0,
        "nb_current_picture": 0
    });
    return new_array;
}