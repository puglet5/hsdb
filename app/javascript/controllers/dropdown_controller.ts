import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"
import { Typed } from "stimulus-typescript"

const targets = {
  dropdown: HTMLElement
}

export default class extends Typed(Controller, { targets }) {

  connect() {
    // @ts-ignore
    hotkeys("escape", (event) => {
      event.preventDefault()
      this.close()
    })
  }

  toggle() {
    this.dropdownTarget.classList.toggle("hidden")
  }

  close() {
    this.dropdownTarget.classList.add("hidden")
  }
}
