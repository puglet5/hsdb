import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import * as d3 from "d3"

Chart.register(...registerables)

export default class extends Controller {
  static values = {
    url: String
  }

  static targets = ["canvas"]

  visualize() {

    let canvasId = this.canvasTarget.id

    d3.csv(this.urlValue)
      .then(makeChart)

    function makeChart(csv) {

      // eslint-disable-next-line no-unused-vars
      let scatterChart = new Chart(canvasId, {
        type: "scatter",
        data: {
          datasets: [{
            label: "test",
            data: parseCvs(csv)
          }]
        },
        options: {
          animation: false,
          parsing: false
        }
      })
    }

    const parseCvs = (csv) => {

      let xValue = csv.map((d) => {
        return parseFloat(Object.values(d)[0])
      })

      let yValue = csv.map((d) => {
        return parseFloat(Object.values(d)[1])
      })

      let data = xValue
        .map((v, i) => {
          return [v, yValue[i]]
        })
        .map((v) => {
          let [x, y] = v
          return { x, y }
        })

      return data
    }
  }

}
