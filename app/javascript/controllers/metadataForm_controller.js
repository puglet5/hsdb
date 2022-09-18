import { Controller } from "@hotwired/stimulus"
import jsonview from "@pgrabovets/json-view"


export default class extends Controller {

  static targets = ["addButton", "fieldRow", "formContainer", "clonedFieldRow", "railsInput", "jsonContainer"]

  connect() {
    let fieldRowClone = this.fieldRowTarget
    let formContainer = this.formContainerTarget
    let railsInput = this.railsInputTarget

    this.formContainerTarget.addEventListener("input", this.handleEdit.bind(event, formContainer, railsInput), false)

    this.addButtonTarget.addEventListener("click", this.addMetadataFormRow.bind(event, fieldRowClone, formContainer), false)
    this.addButtonTarget.classList.add("mt-9")
  }

  addMetadataFormRow(clone, container) {
    let clonedFormRow = clone.cloneNode(true)
    clonedFormRow.querySelectorAll("label").forEach(e => e.remove())
    clonedFormRow.querySelectorAll("input").forEach(e => {
      e.value = ""
    })
    clonedFormRow.setAttribute("data-metadataform-target", "clonedFieldRow")
    container.appendChild(clonedFormRow)
  }

  clonedFieldRowTargetConnected() {
    let lastCloned = this.clonedFieldRowTargets[this.clonedFieldRowTargets.length - 1]
    let addButton = lastCloned.querySelector("#addButton")
    addButton.setAttribute("id", "removeButton")
    addButton.classList.remove("mt-9")
    addButton.textContent = ""
    // eslint-disable-next-line quotes
    addButton.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M18 12H6" /></svg>`
    addButton.addEventListener("click", function () { this.parentNode.remove() }, false)

    let childInputs = this.formContainerTarget.querySelectorAll("input.metadata")

    for (let i = 0; i < childInputs.length; i++) {
      let theName = childInputs[i].name
      if (theName)
        childInputs[i].name = `metadata-${i}`
    }
  }

  clonedFieldRowTargetDisconnected() {
    this.handleEdit(this.formContainerTarget, this.railsInputTarget)
  }

  handleEdit(form, input) {
    let formInputs = Array.from(form.closest("form").elements).filter(e => e.classList.contains("metadata"))

    let data = [].reduce.call(
      formInputs,
      (data, element) => {

        if (!isNaN(Number(element.value)) && (parseFloat(element.value) === Number(element.value)))
          data[element.name] = parseFloat(element.value)
        else try {
          let jToArr = JSON.parse(element.value)
          data[element.name] = jToArr

        }
        catch (e) {
          data[element.name] = element.value
        }

        return data
      },
      {},
    )

    let values = Object.values(data)
    let newObj = []
    for (let i = 0; i < values.length; i += 2) {
      const chunk = values.slice(i, i + 2)
      newObj.push(chunk)
    }
    newObj = newObj[0].map((_, colIndex) => newObj.map(row => row[colIndex]))

    let arr = newObj
    let keys = arr[0]
    let newArr = arr.slice(1, arr.length)
    let formatted = [],
      arrData = newArr,
      cols = keys,
      l = cols.length
    for (let i = 0; i < arrData.length; i++) {
      let d = arrData[i],
        o = {}
      for (let j = 0; j < l; j++)
        o[cols[j]] = d[j]
      formatted.push(o)
    }

    // eslint-disable-next-line no-unused-vars
    let json = Object.fromEntries(Object.entries(formatted[0]).filter(([k, _]) => k != ""))
    let strJson = JSON.stringify(json)

    if (document.querySelector(".json-container"))
      document.querySelector(".json-container").remove()
    const tree = jsonview.create(json)
    if ((Object.keys(json).length !== 0)) {
      jsonview.render(tree, document.querySelector(".tree"))
      jsonview.expand(tree)
    }

    const container = document.querySelector(".json-container")

    if (container) {
      container.classList.add("json-container-styled")
      input.value = strJson
    }
  }
}
