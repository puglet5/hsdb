import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["input", "svg"]

  toggle() {
    const input = this.inputTarget

    input.type = input.type === "password" ? "text" : "password"

    this.svgTarget.classList.toggle("!text-primary-700")
  }
}
