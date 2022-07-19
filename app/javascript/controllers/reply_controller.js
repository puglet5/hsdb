import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["reply", "delete"]

  deleteTargetDisconnected() {
    if (!document.getElementById("reply-form")) {
      this.replyTarget.remove()
    }
  }
}
