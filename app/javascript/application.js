require("@rails/ujs").start()
global.Rails = Rails;

import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "./controllers";

import 'materialize-css/dist/js/materialize'
import "packs/direct_upload";
// import "./dataconfirm"
import "styles/application.scss";

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

$(document).ready(function(){
  $('.modal').modal();
  $('.dropdown-trigger').dropdown();
});

$(document).ready(function(){
  $('select').formSelect();
});