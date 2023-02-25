import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static classes = ["active"]

  static targets = ["tab", "panel"]

  connect() {
    if (localStorage.active_tab) {
      let active = this.tabTargets.find(x => x.id === localStorage.getItem("active_tab"))
      let active_id = this.tabTargets.indexOf(active)

      active.classList.add(...this.activeClasses)
      this.panelTargets[active_id].classList.remove("hidden")

    } else {
      this.tabTargets[0].classList.add(...this.activeClasses)
      this.panelTargets[0].classList.remove("hidden")
    }
  }

  switch(e) {
    let active = this.tabTargets.filter(elem => elem.classList.contains("active-tab"))[0]
    let current = e.target.closest("[data-tabs-target]")

    if (current === active) { return }

    let active_id = this.tabTargets.indexOf(active)
    let current_id = this.tabTargets.indexOf(current)

    active.classList.remove(...this.activeClasses)
    this.panelTargets[active_id].classList.add("hidden")
    current.classList.add(...this.activeClasses)
    this.panelTargets[current_id].classList.remove("hidden")
    this.store_tab(current)
  }

  store_tab(tab) {
    localStorage.setItem("active_tab", tab.id)
  }
}

