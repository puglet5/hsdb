import { Controller } from "@hotwired/stimulus"
import jsonview from "@pgrabovets/json-view"
import { Typed } from "stimulus-typescript"

const values = {
  json: String
}

export default class extends Typed(Controller, { values }) {


  connect() {
    const jsonData = this.jsonValue
    const tree = jsonview.create(jsonData)
    if ((jsonData !== "{}")) {
      jsonview.render(tree, document.querySelector(".tree"))
      jsonview.collapse(tree)
    }
  }
}
