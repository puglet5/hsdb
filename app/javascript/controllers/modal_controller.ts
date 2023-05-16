import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"


export default class extends Controller {

  static targets = ["modal"]

  readonly modalTarget!: HTMLElement

  // @ts-expect-error
  modal: HTMLDialogElement = document.getElementById("confirm-modal")!

  connect() {
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