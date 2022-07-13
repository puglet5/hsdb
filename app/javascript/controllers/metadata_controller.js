import { Controller } from "@hotwired/stimulus";
import jsonview from '@pgrabovets/json-view';

export default class extends Controller {
  static values = {
    json: String
  }

  connect() {
    const jsonData = this.jsonValue
    console.log(this.jsonValue)
    const tree = jsonview.create(jsonData);
    if ((jsonData !== "{}")) {
      jsonview.render(tree, document.querySelector('.tree'));
      jsonview.collapse(tree);
    }
  }
}
