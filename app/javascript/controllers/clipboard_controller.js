import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["text", "svg"]


  connect() {

  }

  async copy() {
    await navigator.clipboard.writeText(this.textTarget.href)
    this.blink()
    this.message()
  }

  blink() {
    const svg = this.svgTarget
    svg.classList.remove("text-gray-400")
    svg.classList.add("text-primary-600")
    setTimeout(function () {
      svg.classList.remove("text-primary-600")
      svg.classList.add("text-gray-400")
   }, 500)
  }

  message() {
    const flash = document.querySelector("#clipboard-flash")
    flash.classList.remove("hidden")
    setTimeout(function () {
      flash.classList.add("hidden")
    }, 2000)
  }
}
