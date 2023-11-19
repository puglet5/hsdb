import { Controller } from "@hotwired/stimulus"
import debounce from "debounce"
import { Typed } from "stimulus-typescript"

export default class extends Typed(Controller<HTMLFormElement>, {}) {
  initialize() {
    this.submit = debounce(this.submit.bind(this), 200, { immediate: true })
  }

  submit() {
    this.element.requestSubmit()
  }
}
