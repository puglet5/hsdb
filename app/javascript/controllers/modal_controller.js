import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["images", "thumbnail", "documents"]

  connect() {

  }

  interact() {
    document.querySelector("body").classList.toggle("overflow-hidden")
  }
}
