import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core"

export default class extends Controller {

  static targets = ["trigger", "tooltip"]

  connect() {
  }

  show() {
    this.tooltipTarget.classList.remove("invisible")
    this.tooltipTarget.classList.add("opacity-100")
    createPopper(this.triggerTarget, this.tooltipTarget, {
      placement: "top",
    })
  }

  hide() {
    this.tooltipTarget.classList.add("invisible")
    this.tooltipTarget.classList.remove("opacity-100")
  }
}
