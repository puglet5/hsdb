import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static classes = ["active"]

  activeClasses: string[]

  static targets = ["tab", "panel"]

  readonly tabTargets!: HTMLElement[]
  readonly panelTargets!: HTMLElement[]

  connect() {
    if (!localStorage.active_tab) {
      this.tabTargets[0].classList.add(...this.activeClasses)
      this.panelTargets[0].classList.remove("hidden")
      return
    }

    const active = this.tabTargets.find(x => x.id === localStorage.getItem("active_tab"))

    if (active == undefined) {
      this.tabTargets[0].classList.add(...this.activeClasses)
      this.panelTargets[0].classList.remove("hidden")
      return
    }

    const active_id = this.tabTargets.indexOf(active)
    active.classList.add(...this.activeClasses)
    this.panelTargets[active_id].classList.remove("hidden")
  }

  switch(e) {
    const active = this.tabTargets.filter(elem => elem.classList.contains("active-tab"))[0]
    const current = e.target.closest("[data-tabs-target]")

    if (current === active) { return }

    const active_id = this.tabTargets.indexOf(active)
    const current_id = this.tabTargets.indexOf(current)

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

