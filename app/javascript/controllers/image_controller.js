import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["image"]

  static values = {

    id: String

  }

  connect() {

  }

  delete() {

    const img = this.imageTarget

    img.classList.toggle("hidden")

    document.querySelector(`input[value=${this.idValue}]`).remove()

  }

}
