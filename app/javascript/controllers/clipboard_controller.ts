import { Controller } from "@hotwired/stimulus"
import {  Typed } from "stimulus-typescript"
const targets = {
  text: HTMLAnchorElement
}
export default class extends Typed(Controller, { targets }) {

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
