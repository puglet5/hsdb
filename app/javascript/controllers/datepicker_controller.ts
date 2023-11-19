import { Controller } from "@hotwired/stimulus"
import Datepicker from "flowbite-datepicker/Datepicker"
import {Typed } from "stimulus-typescript"

const targets = {
  input: HTMLElement
}

export default class extends Typed(Controller, { targets }) {
  connect() {
    new Datepicker(this.inputTarget, {
      autohide: true,
      format: "dd/mm/yyyy"
    })
  }
}
