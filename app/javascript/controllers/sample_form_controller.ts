import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import "@client-side-validations/client-side-validations/src"
import { Typed } from "stimulus-typescript"
const targets = {
  validate: HTMLElement
}
export default class extends Typed(Controller, { targets }) {

  connect() {
    this.validateTarget.hidden = true
    $("#main-form").enableClientSideValidations()
    $("#main-form").resetClientSideValidations()
    // $("#dynamic-form").validate()
  }

  submit() {
    $("#main-form").disableClientSideValidations()
    // $("#dynamic-form").disableClientSideValidations()
    this.validateTarget.click()
  }

}
