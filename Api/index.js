const express = require('express')
const app = express()
const Server = require("http").Server;
const server = Server(app);
const bodyParser = require('body-parser');
require('./config/environment');
require('./database');

const routes = require('./routes/index');
const configPassport = require('./config/passport');

app.use(bodyParser.json());
configPassport(app, express);
app.use('/', routes);

server.listen(8080, () => console.log(`Server is listening on port 8080`));
