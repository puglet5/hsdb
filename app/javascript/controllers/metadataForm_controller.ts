import { Controller } from "@hotwired/stimulus"
import jsonview from "@pgrabovets/json-view"

const parsedDataToArray = (values) => {
  let temp_arr: any[] = []
  for (let i = 0; i < values.length; i += 2) {
    const chunk = values.slice(i, i + 2)
    temp_arr.push(chunk)
  }
  return temp_arr[0].map((_, colIndex) => temp_arr.map(row => row[colIndex]))
}

const arrayToMetadata = (keys, values) => {
  let metadata: any[] = []
  for (let i = 0; i < values.length; i++) {
    let d = values[i],
      o = {}
    for (let j = 0; j < keys.length; j++)
      o[keys[j]] = d[j]
    metadata.push(o)
  }
  return metadata
}

const parseInputData = (inputs) => [].reduce.call(
  inputs,
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
  {}
)

export default class extends Controller {

  static targets = [
    "addButton",
    "fieldRow",
    "formContainer",
    "clonedFieldRow",
    "railsInput",
    "jsonContainer"
  ]

  readonly addButtonTarget!: HTMLElement
  readonly fieldRowTarget!: HTMLElement
  readonly formContainerTarget!: HTMLElement
  readonly clonedFieldRowTarget!: HTMLElement
  readonly clonedFieldRowTargets!: HTMLElement[]
  readonly railsInputTarget!: HTMLElement
  readonly jsonContainerTarget!: HTMLElement


  connect() {
    let fieldRowClone = this.fieldRowTarget
    let formContainer = this.formContainerTarget
    let railsInput = this.railsInputTarget

    this.formContainerTarget.addEventListener("input", this.handleEdit.bind(this, formContainer, railsInput), false)

    this.addButtonTarget.addEventListener("click", this.addMetadataFormRow.bind(this, fieldRowClone, formContainer), false)
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
    let addButton = lastCloned.querySelector("#addButton")!
    addButton.setAttribute("id", "removeButton")
    addButton.classList.remove("mt-9")
    addButton.textContent = ""
    // eslint-disable-next-line quotes
    addButton.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M18 12H6" /></svg>`
    addButton.addEventListener("click", function () { this.parentNode.remove() }, false)

    let childInputNodes: NodeListOf<HTMLInputElement> = this.formContainerTarget.querySelectorAll("input.metadata")

    for (let i = 0; i < childInputNodes.length; i++) {
      let theName = childInputNodes[i].name
      if (theName)
        childInputNodes[i].name = `metadata-${i}`
    }
  }

  clonedFieldRowTargetDisconnected() {
    this.handleEdit(this.formContainerTarget, this.railsInputTarget)
  }

  handleEdit(form, input) {
    let inputNodes: NodeListOf<HTMLInputElement> = form.closest("form").elements
    let formInputs: any[] = Array.from(inputNodes).filter(e => e.classList.contains("metadata"))
    let parsedInputData = parseInputData(formInputs)
    let arrayFromInputs = parsedDataToArray(Object.values(parsedInputData))
    let formattedMetadata = arrayToMetadata(arrayFromInputs[0], arrayFromInputs.slice(1, arrayFromInputs.length))

    let json = Object.fromEntries(Object.entries(formattedMetadata[0]).filter(([k]) => k != ""))
    let strJson = JSON.stringify(json)

    this.view(json)
    input.value = strJson
  }

  view(json) {
    if (document.querySelector(".json-container"))
      document.querySelector(".json-container")!.remove()
    const tree = jsonview.create(json)
    if ((Object.keys(json).length !== 0)) {
      jsonview.render(tree, document.querySelector(".tree"))
      jsonview.expand(tree)
    }

    const container = document.querySelector(".json-container")
    if (container) {
      container.classList.add("json-container-styled")
    }
  }
}
