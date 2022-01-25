import Rails from "@rails/ujs";
global.Rails = Rails;

import * as ActiveStorage from "@rails/activestorage";
import "./channels";
import "./controllers";

import "./packs/direct_upload";
// import "./dataconfirm"
import "./styles/application.scss";

import "beercss/src/cdn/beer"
import "trix"

import "@rails/actiontext";

var Turbolinks = require("turbolinks")
ActiveStorage.start();

Turbolinks.start()

require("jquery");
require("@rails/actiontext")

require.context('img', true)

document.addEventListener("turbolinks:load", () => {
  ui();
})
