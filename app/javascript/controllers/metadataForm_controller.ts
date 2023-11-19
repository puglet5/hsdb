import { Controller } from "@hotwired/stimulus"
import jsonview from "@pgrabovets/json-view"
import { Typed } from "stimulus-typescript"

const parsedDataToArray = (values) => {
  const temp_arr: any[] = []
  for (let i = 0; i < values.length; i += 2) {
    const chunk = values.slice(i, i + 2)
    temp_arr.push(chunk)
  }
  return temp_arr[0].map((_, colIndex) => temp_arr.map(row => row[colIndex]))
}

const arrayToMetadata = (keys, values) => {
  const metadata: any[] = []
  for (let i = 0; i < values.length; i++) {
    const d = values[i],
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
      const jToArr = JSON.parse(element.value)
      data[element.name] = jToArr
    }
    catch (e) {
      data[element.name] = element.value
    }
    return data
  },
  {}
)

const targets = {
  addButton: HTMLElement,
  fieldRow: HTMLElement,
  formContainer: HTMLElement,
  clonedFieldRow: HTMLElement,
  railsInput: HTMLElement,
  jsonContainer: HTMLElement
}

export default class extends Typed(Controller, { targets }) {

  connect() {
    const fieldRowClone = this.fieldRowTarget
    const formContainer = this.formContainerTarget
    const railsInput = this.railsInputTarget

    this.formContainerTarget.addEventListener("input", this.handleEdit.bind(this, formContainer, railsInput), false)

    this.addButtonTarget.addEventListener("click", this.addMetadataFormRow.bind(this, fieldRowClone, formContainer), false)
    this.addButtonTarget.classList.add("mt-9")
  }

  addMetadataFormRow(clone, container) {
    const clonedFormRow = clone.cloneNode(true)
    clonedFormRow.querySelectorAll("label").forEach(e => e.remove())
    clonedFormRow.querySelectorAll("input").forEach(e => {
      e.value = ""
    })
    clonedFormRow.setAttribute("data-metadataform-target", "clonedFieldRow")
    container.appendChild(clonedFormRow)
  }

  clonedFieldRowTargetConnected() {
    const lastCloned = this.clonedFieldRowTargets[this.clonedFieldRowTargets.length - 1]
    const addButton = lastCloned.querySelector("#addButton")!
    addButton.setAttribute("id", "removeButton")
    addButton.classList.remove("mt-9")
    addButton.textContent = ""
    // eslint-disable-next-line quotes
    addButton.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M18 12H6" /></svg>`
    addButton.addEventListener("click", function () { this.parentNode.remove() }, false)

    const childInputNodes: NodeListOf<HTMLInputElement> = this.formContainerTarget.querySelectorAll("input.metadata")

    for (let i = 0; i < childInputNodes.length; i++) {
      const theName = childInputNodes[i].name
      if (theName)
        childInputNodes[i].name = `metadata-${i}`
    }
  }

  clonedFieldRowTargetDisconnected() {
    this.handleEdit(this.formContainerTarget, this.railsInputTarget)
  }

  handleEdit(form, input) {
    const inputNodes: NodeListOf<HTMLInputElement> = form.closest("form").elements
    const formInputs: any[] = Array.from(inputNodes).filter(e => e.classList.contains("metadata"))
    const parsedInputData = parseInputData(formInputs)
    const arrayFromInputs = parsedDataToArray(Object.values(parsedInputData))
    const formattedMetadata = arrayToMetadata(arrayFromInputs[0], arrayFromInputs.slice(1, arrayFromInputs.length))

    const json = Object.fromEntries(Object.entries(formattedMetadata[0]).filter(([k]) => k != ""))
    const strJson = JSON.stringify(json)

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
