import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["input", "svg"]

  readonly inputTarget!: HTMLInputElement
  readonly svgTarget!: HTMLElement


  toggle() {
    const input = this.inputTarget

    input.type = input.type === "password" ? "text" : "password"

    this.svgTarget.classList.toggle("!text-primary-500")
  }
}
