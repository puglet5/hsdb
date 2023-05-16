import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["reply"]

  readonly replyTarget!: HTMLElement

  deleteTargetDisconnected() {
    if (!document.getElementById("reply-form")) {
      this.replyTarget.remove()
    }
  }
}
