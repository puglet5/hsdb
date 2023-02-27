import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"


export default class extends Controller {

  static targets = ["modal"]

  connect() {
    hotkeys("escape", (event) => {
      event.preventDefault()
      this.close()
    })
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.modalTarget.remove()
    document.body.classList.remove("overflow-hidden")
  }

}
