import { Controller } from "@hotwired/stimulus"
import {  Typed } from "stimulus-typescript"

export default class extends Typed(Controller, {}) {
  connect() {
    const bttButton = document.getElementById("btn-back-to-top")!
    const scrollListen = () => {
      if (document.body.scrollTop > 500 || document.documentElement.scrollTop > 500) {
        bttButton.classList.remove("hidden")
      }
      else {
        bttButton.classList.add("hidden")
      }
    }

    const backToTop = () => {
      document.body.scrollTop = 0
      document.documentElement.scrollTop = 0
    }

    window.onscroll = () => scrollListen()
    bttButton.addEventListener("click", backToTop)
  }
}
