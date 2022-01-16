require("@rails/ujs").start()
global.Rails = Rails;

import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

import 'materialize-css/dist/js/materialize'
import "./direct_upload";
// import "./dataconfirm"
import "../styles/application.scss";

import "trix";
import "@rails/actiontext";

require("@rails/activestorage").start();
require("channels");

ActiveStorage.start();

require("trix");
require("jquery");
require("@rails/actiontext");

// require('popper.js')
// require('bootstrap')
// require('data-confirm-modal')

require.context('../img', true)

$(document).ready(function(){
  $('.modal').modal();
  $('.dropdown-trigger').dropdown();
});