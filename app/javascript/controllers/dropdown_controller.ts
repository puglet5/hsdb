import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"

export default class extends Controller {

  static targets = ["dropdown"]

  readonly dropdownTarget!: HTMLElement

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
