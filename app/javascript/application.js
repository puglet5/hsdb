require("@rails/ujs").start()
global.Rails = Rails;

import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "./controllers";

import "./direct_upload";
// import "./dataconfirm"
import "styles/application.scss";

import "beercss/src/cdn/beer"
import "trix";
import "@rails/actiontext";

require("@rails/activestorage").start();
require("channels");
require("controllers");


ActiveStorage.start();

require("trix");

var Turbolinks = require("turbolinks")

Turbolinks.start()

require("jquery");
require("@rails/actiontext")

// require('popper.js')
// require('bootstrap')
// require('data-confirm-modal')

require.context('img', true)

ui();