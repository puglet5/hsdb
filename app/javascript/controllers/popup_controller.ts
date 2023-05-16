import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core"

export default class extends Controller {

  static targets = ["trigger", "tooltip"]

  readonly triggerTarget!: HTMLElement
  readonly tooltipTarget!: HTMLElement

  readonly hasTriggerTarget: boolean
  readonly hasTooltipTarget: boolean

  show() {
    if (this.hasTooltipTarget) {
      this.tooltipTarget.classList.remove("invisible")
      this.tooltipTarget.classList.add("opacity-100")
      createPopper(this.triggerTarget, this.tooltipTarget, {
        placement: "top",
      })
    }
  }

  hide() {
    if (this.hasTooltipTarget) {
      this.tooltipTarget.classList.add("invisible")
      this.tooltipTarget.classList.remove("opacity-100")
    }
  }
}
