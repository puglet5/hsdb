import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const flash = this.element
    flash.classList.add("flash")
    setTimeout(function () { flash.classList.add("hidden") }, 5000)
  }
}
