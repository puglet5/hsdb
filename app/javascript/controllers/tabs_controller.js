import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static classes = ["active"]

  static targets = ["tab", "panel"]

  switch(e) {
    const active = this.tabTargets.filter(elem => elem.classList.contains("active-tab"))[0]
    const current = e.target.closest("[data-tabs-target]")

    console.log(current)

    if (current !== active) {
      this.tabTargets.forEach((tab, index) => {
        if (tab === active) {
          tab.classList.remove(...this.activeClasses)
          this.panelTargets[index].classList.add("hidden")
        } else if (tab === current) {
          current.classList.add(...this.activeClasses)
          this.panelTargets[index].classList.remove("hidden")
        }
      })
    }
  }
}
