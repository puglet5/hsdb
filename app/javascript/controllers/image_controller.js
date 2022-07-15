import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

  static targets = ["image", "div"]
  static values = {
    filename: String,
    url: String,
    metadata: String
  }

  connect() {
  }

  imageClick(e) {

    const img = this.imageTarget

    if (!this.hasDivTarget) {

      let div = document.createElement("div")
      let txt = document.createElement("p")
      txt.innerText = JSON.stringify(JSON.parse(this.metadataValue))
      let imgFromUrl = document.createElement("img")

      imgFromUrl.src = this.urlValue
      div.dataset.imageTarget = "div"

      div.appendChild(imgFromUrl)
      div.appendChild(txt)

      const gallery = document.getElementById("gallery")
      // gallery.classList.toggle("opacity-75")

      const divCls = ["absolute", "max-w-4/5", "top-0", "left-[10%]", "bg-white", "rounded-lg", "border", "border-2", "border-gray-200", "shadow-3xl", "mt-2"]
      const imgCls = ["rounded-lg"]

      div.classList.add(...divCls)
      txt.classList.add("m-2")
      img.classList.add(...imgCls)


      img.insertAdjacentElement("afterend", div)

      // div.dataset.actions = "mouseout->image#imageRelease"
    }

    else {

      this.divTarget.classList.toggle("hidden")
      // gallery.classList.toggle("opacity-75")

    }
  }

  // imageRelease() {
  //   this.divTarget.remove()
  // }
}
