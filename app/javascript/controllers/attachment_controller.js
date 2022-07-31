import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["attachment"]

  static values = {

    id: String

  }

  connect() {

  }

  delete() {

    const att = this.attachmentTarget

    att.classList.toggle("hidden")

    document.querySelector(`input[value=${this.idValue}]`).remove()

  }

}
