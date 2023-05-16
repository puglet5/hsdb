import { Controller } from "@hotwired/stimulus"
import Datepicker from "flowbite-datepicker/Datepicker"

export default class extends Controller {

  static targets = ["input"]

  readonly inputTarget!: HTMLElement

  connect() {
    new Datepicker(this.inputTarget, {
      autohide: true,
      format: "dd/mm/yyyy"
    })
  }
}
