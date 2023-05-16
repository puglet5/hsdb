import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["text"]

  readonly textTarget!: HTMLAnchorElement

  async copy() {
    await navigator.clipboard.writeText(this.textTarget.href)
    this.flashMessage()
  }

  flashMessage() {
    const flash = document.querySelector("#clipboard-flash")!
    flash.classList.remove("hidden")
    setTimeout(function () {
      flash.classList.add("hidden")
    }, 2000)
  }
}
