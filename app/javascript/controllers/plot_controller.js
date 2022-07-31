import { Controller } from "@hotwired/stimulus"


export default class extends Controller {

  static targets = ["plot"]

  static values = {
    url: String,
  }
}
