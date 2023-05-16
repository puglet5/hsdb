import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core"

export default class extends Controller {

  static targets = ["trigger", "tooltip"]

  readonly triggerTarget!: HTMLElement
  readonly tooltipTarget!: HTMLElement

  readonly hasTriggerTarget: boolean
  readonly hasTooltipTarget: boolean

  connect(): void {
    this.tooltipTarget.classList.add("hidden")
  }

  show() {
    if (this.hasTooltipTarget) {
      this.tooltipTarget.classList.remove("hidden")
      createPopper(this.triggerTarget, this.tooltipTarget, {
        placement: "top",
      })
    }
  }

  hide() {
    if (this.hasTooltipTarget) {
      this.tooltipTarget.classList.add("hidden")
    }
  }
}
