const express = require('express');

const auth              = require('./auth');
const crud_group        = require('./crud_group');
const swipe_system      = require('./swipe_system');
const service           = require('./service');
const friends           = require('./friends');

const router = express.Router();

router.use('/api/auth', auth);
router.use('/api/crud_group', crud_group);
router.use('/api/swipe_system', swipe_system);
router.use('/api/service', service);
router.use('/api/friends', friends);

module.exports = router;
