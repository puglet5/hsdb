import { Controller } from "@hotwired/stimulus"
import { Typed } from "stimulus-typescript"

const values = {
  classname: String,
  id: String
}

const targets = {
  delete: HTMLElement,
  object: HTMLElement,
  return: HTMLElement,
  div: HTMLElement,
  input: HTMLElement,
  placeholder: HTMLElement
}

export default class extends Typed(Controller, { values, targets }) {

  greyout() {
    this.objectTarget.classList.toggle("opacity-25")
  }

  delete() {
    this.greyout()
    this.deleteTarget.classList.toggle("hidden")
    this.returnTarget.classList.toggle("hidden")
    this.placeholderTarget.classList.toggle("hidden")

    const input = document.createElement("input")
    input.classList.add("hidden")
    input.name = `${this.classnameValue}[purge_attachments][]`
    input.setAttribute("value", this.idValue)
    input.setAttribute("data-purge-target", "input")
    this.divTarget.appendChild(input)
  }

  return() {
    this.greyout()
    this.deleteTarget.classList.toggle("hidden")
    this.returnTarget.classList.toggle("hidden")
    this.placeholderTarget.classList.toggle("hidden")

    this.inputTarget.remove()
  }
}
