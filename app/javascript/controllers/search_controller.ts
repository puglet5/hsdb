import { Controller } from "@hotwired/stimulus"
import debounce from "debounce"

export default class extends Controller<HTMLFormElement> {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 200, true)
  }

  submit() {
    this.element.requestSubmit()
  }
}
