import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["delete", "object", "return", "div", "input", "placeholder"]

  static values = {
    classname: String,
    id: String
  }

  greyout() {
    this.objectTarget.classList.toggle("opacity-25")
  }

  delete() {
    this.greyout()
    this.deleteTarget.classList.toggle("hidden")
    this.returnTarget.classList.toggle("hidden")
    this.placeholderTarget.classList.toggle("hidden")

    let input = document.createElement("input")
    input.classList.add("hidden")
    input.name = `${this.classnameValue}[purge_images][]`
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
