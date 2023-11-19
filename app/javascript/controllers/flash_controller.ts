import { Controller } from "@hotwired/stimulus"
import { Typed } from "stimulus-typescript"

const targets = {
  flash: HTMLElement
}

export default class extends Typed(Controller, { targets }) {

  connect() {
    const flash = this.element
    flash.classList.add("flash")
    setTimeout(function () { flash.classList.add("hidden") }, 5000)
  }

  close() {
    this.flashTarget.remove()
  }
}
