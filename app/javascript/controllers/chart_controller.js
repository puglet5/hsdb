import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import { csv as importCsv } from "d3"

Chart.register(...registerables)

export default class extends Controller {
  static values = {
    url: String
  }


  visualize() {
    if (window.scatterChart) { window.scatterChart.destroy() }

    importCsv(this.urlValue)
      .then(makeChart)

    function makeChart(csv) {

      window.scatterChart = new Chart("canvas", {
        type: "scatter",
        data: {
          datasets: [{
            label: "test",
            data: parseCsv(csv)
          }]
        },
        options: {
          animation: false,
          parsing: false
        }
      })
    }

    const parseCsv = (csv) => {

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
