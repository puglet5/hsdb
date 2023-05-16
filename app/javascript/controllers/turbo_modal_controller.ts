import { Controller } from "@hotwired/stimulus"
import hotkeys from "hotkeys-js"


export default class extends Controller {

  static targets = ["modal"]

  readonly modalTarget!: HTMLElement

  uppy_db_arr: HTMLCollectionOf<Element>
  uppy_states_arr: boolean[]

  connect() {
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
