/* eslint-disable no-unused-vars */
import { Controller } from "@hotwired/stimulus"
import debounce from "debounce"

export default class extends Controller {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 200)
  }

  submit(_event) {
    this.element.requestSubmit()
  }
}
