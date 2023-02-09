import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import zoomPlugin from "chartjs-plugin-zoom"

import Papa from "papaparse"

Chart.register(...registerables)
Chart.register(zoomPlugin)

export default class extends Controller {
  static values = {
    url: String,
    data: Array,
    initialData: Array,
    filename: String,
    id: Number
  }

  static targets = ["canvas"]
  normalized = false
  options = {
    animation: false,
    parsing: true,
    showAllTooltips: true,
    layout: {
      padding: {
        left: 20,
        right: 20,
        top: 20,
        bottom: 20
      },
    },
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
        title: {
          text: "Intensity, a.u.",
          display: true
        },
        min: 0,
        grid: {
          borderDash: [8, 4],
          color: "#e1e1e1"
        }
      },
      x: {
        title: {
          text: "Energy, keV",
          display: true
        },
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
    plugins: {
      tooltip: {
        displayColors: false,
        callbacks: {
          label: function (tooltipItem) {
            return tooltipItem.formattedValue
          },
          title: function () {
            return
          }
        }
      },
      zoom: {
        zoom: {
          wheel: {
            enabled: true,
          },
          pinch: {
            enabled: false
          },
          mode: "xy",
        },
        pan: {
          enabled: true
        },
        limits: {
          x: { min: "original", max: "original" },
          y: { min: "original", max: "original" }
        },
        animation: {
          duration: 100,
          easing: "easeOutCubic"
        }
      },
      legend:
      {
        labels: {
          boxWidth: 0,
        }
      }
    }
  }

  async import(url) {
    return await fetch(url)
      .then((response) => response.text())
  }

  parse(rawData) {

    let data = Papa.parse(rawData).data

    let xValue = data.map((d) => {
      return parseFloat(Object.values(d)[0])
    })

    let yValue = data.map((d) => {
      return parseFloat(Object.values(d)[1])
    })

    let parsedData = xValue
      .map((v, i) => {
        return [v, yValue[i]]
      })
      .map((v) => {
        let [x, y] = v
        return { x, y }
      })

    return parsedData
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
            lineTension: 0
          }]
        },
        options: this.options
      })
    }

    if (window.scatterChart) { window.scatterChart.destroy() }

    if (this.hasDataValue) {
      makeChart(this.dataValue, this.filenameValue)
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
      [x[0], x.slice(-2)[0]],
      [Math.min(...y), Math.max(...y)]
    ]
  }

  normalize() {
    if (!this.normalized) {
      window.scatterChart.resetZoom()

      this.normalized = true

      let data = this.dataValue
      let range = this.getRange(data)
      let normalizedY = data.map(e => e["y"] / range[1][1])

      this.initialDataValue = this.dataValue

      this.dataValue = data.map((e, i) => (
        {
          x: e["x"],
          y: normalizedY[i],
        }
      ))
      this.visualize()
    }
    else return
  }

  reset() {
    if (this.normalized) {
      this.normalized = false
      this.dataValue = this.initialDataValue
      this.visualize()
    }
    else return
  }

  resetZoom() {
    window.scatterChart.resetZoom()

  }
}
