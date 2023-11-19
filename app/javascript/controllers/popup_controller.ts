import { Controller } from "@hotwired/stimulus"
import { createPopper } from "@popperjs/core"
import { Typed } from "stimulus-typescript"


const targets = {
  trigger: HTMLElement,
  tooltip: HTMLElement
}

export default class extends Typed(Controller, { targets }) {
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
