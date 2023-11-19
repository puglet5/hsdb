import { Controller } from "@hotwired/stimulus"
import { Typed } from "stimulus-typescript"

const targets = {
  reply: HTMLElement
}

export default class extends Typed(Controller, { targets }) {

  deleteTargetDisconnected() {
    if (!document.getElementById("reply-form")) {
      this.replyTarget.remove()
    }
  }
}
