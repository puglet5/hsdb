import { Controller } from "@hotwired/stimulus"

const addIcon = `<svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 icon icon-tabler icon-tabler-code-plus text-primary-300 hover:text-primary-500" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
<path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
<path d="M9 12h6"></path>
<path d="M12 9v6"></path>
<path d="M6 19a2 2 0 0 1 -2 -2v-4l-1 -1l1 -1v-4a2 2 0 0 1 2 -2"></path>
<path d="M18 19a2 2 0 0 0 2 -2v-4l1 -1l-1 -1v-4a2 2 0 0 0 -2 -2"></path>
</svg>`

const removeIcon = `<svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 icon icon-tabler icon-tabler-code-minus text-primary-300 hover:text-primary-500" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
<path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
<path d="M9 12h6"></path>
<path d="M6 19a2 2 0 0 1 -2 -2v-4l-1 -1l1 -1v-4a2 2 0 0 1 2 -2"></path>
<path d="M18 19a2 2 0 0 0 2 -2v-4l1 -1l-1 -1v-4a2 2 0 0 0 -2 -2"></path>
</svg>`

export default class extends Controller {

  static targets = ["anchor", "count", "toggle"]

  static values = {
    spectraIds: Array
  }

  readonly anchorTarget!: HTMLAnchorElement
  readonly countTarget!: HTMLSpanElement
  spectraIdsValue: number[]

  initialize() {
    this.spectraIdsValue = JSON.parse(localStorage.getItem("compareIds")) as number[]
  }

  connect() {
    this.showLink()
  }

  showLink() {
    if (this.spectraIdsValue.length) {
      this.anchorTarget.classList.remove("hidden")
      this.countTarget.classList.remove("hidden")
      this.countTarget.innerHTML = this.spectraIdsValue.length.toString()
      this.composeUrl()
    } else {
      this.anchorTarget.classList.add("hidden")
      this.countTarget.classList.add("hidden")
    }
  }

  toggleTargetConnected(e: HTMLDivElement){
    console.log(+e.dataset.id, this.spectraIdsValue.includes(+e.dataset.id))
    if (this.spectraIdsValue.includes(+e.dataset.id)) {
      e.innerHTML = removeIcon
    } else {
      e.innerHTML = addIcon
    }
  }

  composeUrl() {
    const params = this.spectraIdsValue.map(e=>`ids[]=${e}`).join("&")
    const url = `${window.location.origin}/samples/compare/?${params}`
    this.anchorTarget.href = url
  }

  toggle(e) {
    const id = +e.currentTarget.dataset.id
    if (this.spectraIdsValue.includes(id)) {
      this.spectraIdsValue = this.spectraIdsValue.filter(e=>e!==id)
      e.currentTarget.innerHTML = addIcon
    } else {
      this.spectraIdsValue = [...this.spectraIdsValue, id]
      e.currentTarget.innerHTML = removeIcon
    }
    this.countTarget.innerHTML = this.spectraIdsValue.length.toString()
    localStorage.setItem("compareIds", JSON.stringify(this.spectraIdsValue))
    this.composeUrl()
    this.showLink()
  }
}

