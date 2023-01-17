import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import { dsv } from "d3"

Chart.register(...registerables)

export default class extends Controller {
  static values = {
    url: String,
    data: Array,
    filename: String,
    id: Number
  }

  static targets = ["canvas"]

  async import(url) {
    return await dsv(",", url, d => { return d })
  }

  parse(raw) {

    let xValue = raw.map((d) => {
      return parseFloat(Object.values(d)[0])
    })

    let yValue = raw.map((d) => {
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

  async visualize() {

    let id = this.idValue

    const makeChart = (data, filename) => {

      window.scatterChart = new Chart(`canvas-${id}`, {
        type: "scatter",
        data: {
          datasets: [{
            label: filename,
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

    if (window.scatterChart) { window.scatterChart.destroy() }

    if (this.hasDataValue) {
      makeChart(this.dataValue, this.filenameValue)
      console.log(this.dataValue, this.filenameValue)

    } else {
      const raw = await this.import(this.urlValue)
      this.dataValue = this.parse(raw)
      makeChart(this.dataValue, this.filenameValue)
    }
  }

  getRange(data) {
    const y = data
      .map(e => Object.values(e))
      .map(e => e[1])

    const x = data
      .map(e => Object.values(e))
      .map(e => e[0])

    return [
      [Math.min(...x), Math.max(...x)],
      [Math.min(...y), Math.max(...y)]
    ]
  }
}
