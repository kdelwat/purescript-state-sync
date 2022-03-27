"use strict";
var cors = require("cors");

exports.cors = cors();

exports.jsonBodyParser = require("body-parser").json();
