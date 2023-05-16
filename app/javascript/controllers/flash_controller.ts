import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["flash"]

  readonly flashTarget!: HTMLElement

  connect() {
    const flash = this.element
    flash.classList.add("flash")
    setTimeout(function () { flash.classList.add("hidden") }, 5000)
  }

  close() {
    this.flashTarget.remove()
  }
}
