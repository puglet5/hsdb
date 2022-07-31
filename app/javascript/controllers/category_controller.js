import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["save", "title"]
  static classes = ["loading"]
  static values = {
    id: String
  }

  connect() {
    this.element.contentEditable = true
    this.element.spellcheck = false
    this.element.dataset.action = "click->category#editTitle"
  }

  editTitle(e) {
    if (!this.hasSaveTarget) {
      const btn = document.createElement("button")
      btn.classList = "ml-2"
      btn.dataset.categoryTarget = "save"
      btn.dataset.action = "click->category#saveTitle"
      const svg = "<svg xmlns=\"http://www.w3.org/2000/svg\" class=\"h-6 w-6\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M5 13l4 4L19 7\" /></svg>"
      btn.innerHTML = svg
      e.target.insertAdjacentElement("afterend", btn)
    }
  }

  async saveTitle(e) {
    const btn = e.target.closest("button")
    e.preventDefault()
    btn.disabled = true
    btn.classList.add(this.loadingClass)

    const formData = new FormData()
    formData.append("category[category_name]", this.titleTarget.innerText)
    await this.doPatch(`/api/categories/${this.idValue}`, formData)

    btn.remove()
  }

  async doPatch(url, body) {
    const csrfToken = document.getElementsByName("csrf-token")[0].content

    await fetch(url, {
      method: "PATCH",
      body: body,
      headers: {
        "X-CSRF-Token": csrfToken
      }
    })

  }

}
