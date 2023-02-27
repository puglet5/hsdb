import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {

    const scrollFunction = () => {
      if (document.body.scrollTop > 500 || document.documentElement.scrollTop > 500) {
        mybutton.classList.remove("hidden")
      }
      else {
        mybutton.classList.add("hidden")
      }
    }

    const backToTop = () => {
      document.body.scrollTop = 0
      document.documentElement.scrollTop = 0
    }

    let mybutton = document.getElementById("btn-back-to-top")

    window.onscroll = () => scrollFunction()

    mybutton.addEventListener("click", backToTop)
  }
}
