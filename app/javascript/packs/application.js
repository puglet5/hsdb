require("@rails/ujs").start()
global.Rails = Rails;

import Rails from "@rails/ujs";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

import 'materialize-css/dist/js/materialize'
import "../styles/application.scss";

import "trix";
import "@rails/actiontext";

require("@rails/activestorage").start();
require("channels");

Rails.start();
Turbolinks.start();
ActiveStorage.start();

require("trix");
require("@rails/actiontext");
