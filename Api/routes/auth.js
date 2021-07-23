const express = require('express');
const passport = require('passport');
const { User, Group } = require('../database/schemas');
const router = express.Router();
var rug = require('random-username-generator');

module.exports = router;

router.get('/', (req, res) => {
  User.findOne({ _id: req.query.user_id }, (err, user) => {
    err ? res.status(400).send() : res.status(200).send(user === null ? [] : [user.username])
  });
})

router.get('/full_info', (req, res) => {
  User.findOne({ userId: req.query.userId }, (err, user) => {
    if (err)
      res.status(400).send()
    else {
      let user_to_retrun = {
        userId: user.userId,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        authState: "authorized",
        _id: user._id
      }
      res.status(200).send(user_to_retrun)
    }
  });
})

router.post('/signInWithApple', (req, res) => {
  User.findOne({ email: req.body.email }, (err, user) => {
    if (err) {
      res.status(400).send({ message: 'Get users failed', err });
    } else {
      if (user === null) {
        createUser(req, res)
      } else {
        if (user.userId != req.body.userId) {
          User.findOneAndUpdate({ email: req.body.email }, { userId: req.body.userId }, (err, userUpdated) => {
            if (err) {
              return res.status(400).send();
            }
            if (userUpdated) {
              return res.status(200).send(userUpdated);
            }
          });
        } else {
          return res.status(200).send(user)
        }
      }
    }
  });
});


router.post('/username', (req, res) => {
  req.body.username = req.body.username.toLowerCase()
  req.body.username = req.body.username.replace(/ /g, '')
  User.findOne({ username: req.body.username }, (err, user) => {
    if (err) {
      res.status(400).send();
    } else {
      if (user === null) {
        User.findOneAndUpdate({ _id: req.body.userId }, { username: req.body.username }, err => {
          if (err) {
            return res.status(400).send();
          }
          return res.status(200).send({ message: 'Profile successfully updated' });
        });
      }
      else {
        res.status(400).send();
      }
    }
  });
});

router.delete('/', (req, res) => {
  Group.find({ 'user': req.body.user_id }, (err, groups) => {
    if (err) {
      return res.status(400).send();
    }
    if (groups) {
      groups.forEach(element => {
        console.log(element)
        element.remove()
      });
      res.send({ message: 'Your account has been removed successfuly' });
    }
  });
})

async function createUser(req, res) {
  req.body.username = await generateUserName(req.body.firstName)
  const newUser = User(req.body);
  newUser.save((err, savedUser) => {
    if (err) {
      return res.status(400).send()
    }
    else {
      return res.status(200).send(savedUser)
    }
  });
}

function generateUserName(firstName) {
  return new Promise(resolve => {
    rug.setAdjectives([firstName]);
    var username = rug.generate();
    username = username.toLowerCase();
    User.findOne({ username: username }, (err, user) => {
      if (err) {
        res.status(400).send()
      }
      else {
        if (user === null) {
          resolve(username);
        }
        else {
          rug.setAdjectives([firstName]);
          username = rug.generate();
          username = username.toLowerCase();
          resolve(username);
        }
      }
    });
  });

}