import { Controller } from "@hotwired/stimulus"
import { Typed } from "stimulus-typescript"

const targets = {
  input: HTMLInputElement,
  svg: HTMLElement
}

export default class extends Typed(Controller, { targets }) {
  toggle() {
    const input = this.inputTarget

    input.type = input.type === "password" ? "text" : "password"

    this.svgTarget.classList.toggle("!text-primary-500")
  }
}
