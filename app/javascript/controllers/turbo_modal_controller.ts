import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"
import { Typed } from "stimulus-typescript"

const targets = {
  modal: HTMLElement
}

export default class extends Typed(Controller, { targets }) {

  uppy_db_arr: HTMLCollectionOf<Element>
  uppy_states_arr: boolean[]

  connect() {
    // @ts-ignore
    hotkeys("escape", (event) => {
      this.uppy_db_arr = document.getElementsByClassName("uppy-Dashboard")
      this.uppy_states_arr = [...this.uppy_db_arr].map(e => e.getAttribute("aria-hidden") == "true")
      if (!this.uppy_states_arr.includes(false)) {
        event.preventDefault()
        this.close()
      } else return
    })
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.modalTarget.remove()
    document.body.classList.remove("overflow-hidden")
  }
}
