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

      let data = parseCsv(csv)

      window.scatterChart = new Chart("canvas", {
        type: "scatter",
        data: {
          datasets: [{
            label: "test",
            data: data,
            showLine: true,
          }]
        },
        options: {
          animation: false,
          parsing: true,
          showAllTooltips: true,
          elements: {
            point: {
              radius: 0
            },
            line: {
              backgroundColor: "#000000",
              borderColor: "#000000",
              borderWidth: 2
            }
          },
          scales: {
            y: {
              min: 0,
              grid: {
                borderDash: [8, 4],
                color: "#e1e1e1"
              }
            },
            x: {
              grid: {
                borderDash: [8, 4],
                color: "#e1e1e1"
              }
            }
          },
          interaction: {
            mode: "nearest",
            axis: "x",
            intersect: false
          },
          tooltip: {
            position: "nearest",
          },
          plugins: {
            tooltip: {
              displayColors: false
            },
            legend:
            {
              labels: {
                boxWidth: 0,
              }
            }
          }
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
