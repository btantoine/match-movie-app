const express = require('express');
const { Service } = require('../database/schemas');

const router = express.Router();

module.exports = router;

router.get('/', (req, res) => {
    Service.find().find(function (err, result) {
        res.send(result)
    });
})

router.post('/', (req, res) => {
    const newService = Service(req.body);
    newService.save((err, savedService) => {
        if (err)
            res.status(400).send("Create new Service: failed")
        else
            res.status(200).send("Create new Service: success")
    });
})