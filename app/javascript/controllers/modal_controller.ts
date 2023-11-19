import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"
import { Typed } from "stimulus-typescript"

const targets = {
  modal: HTMLElement
}

export default class extends Typed(Controller, { targets }) {

  modal: HTMLDialogElement = document.getElementById("confirm-modal")! as HTMLDialogElement

  connect() {
    // @ts-ignore
    hotkeys("escape", (event) => {
      event.preventDefault()
      this.close()
    })
  }

  toggle() {
    this.modalTarget.classList.toggle("hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    if (this.modal) {
      this.modal.close("cancel")
    }
  }
}
