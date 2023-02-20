import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["toggle", "modal"]

  toggle() {
    this.modalTarget.classList.toggle("hidden")
  }
}
