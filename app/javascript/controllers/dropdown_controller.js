import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"

export default class extends Controller {

  static targets = ["toggle", "dropdown"]

  connect() {
    hotkeys("escape", (event) => {
      event.preventDefault()
      this.close()
    })
  }

  toggle() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  close() {
    this.dropdownTarget.classList.add("hidden")
  }
}
