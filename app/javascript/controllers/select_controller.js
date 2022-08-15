import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select/dist/js/tom-select.complete.js"

export default class extends Controller {

  connect() {
    var config = {
      plugins: ["restore_on_backspace", "remove_button", "no_active_items", "clear_button"],
      persist: false,
    }
    new TomSelect("#select", config)
  }

}
