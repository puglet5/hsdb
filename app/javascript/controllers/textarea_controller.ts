import { Controller } from "@hotwired/stimulus"
import { Typed } from "stimulus-typescript"

const targets = {
  input: HTMLInputElement
}

export default class extends Typed(Controller, { targets }) {

  connect() {
    this.inputTarget.style.resize = "none"
    this.inputTarget.style.minHeight = `${this.inputTarget.scrollHeight}px`
  }

  resize(event) {
    event.target.style.height = "5px"
    event.target.style.height = `${event.target.scrollHeight}px`
  }

}
