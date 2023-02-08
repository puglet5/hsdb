import { Controller } from "@hotwired/stimulus"
import $ from "jquery"
import "@client-side-validations/client-side-validations/src"

export default class extends Controller {

  static targets = ["validate"]

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
