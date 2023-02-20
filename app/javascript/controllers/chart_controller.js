import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"
import zoomPlugin from "chartjs-plugin-zoom"
import ChartDataLabels from "chartjs-plugin-datalabels"
import Papa from "papaparse"
import { blur } from "d3-array"

Chart.register(...registerables)
Chart.register(zoomPlugin)
Chart.register(ChartDataLabels)

export default class extends Controller {

  static values = {
    url: String,
    data: Array,
    initialData: Array,
    filename: String,
    id: Number,
    axesSpec: Object,
    labels: Array,
  }

  static targets = ["canvas", "interpolateButton", "normalizeButton", "gaussianFilterSlider"]

  normalized = false
  cubicInterpolationMode = undefined
  displayLabelValues = this.labelsValue.map(o => o.position).map(Number)

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
          text: this.axesSpecValue["labels"][1],
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
          text: this.axesSpecValue["labels"][0],
          display: true
        },
        grid: {
          borderDash: [8, 4],
          color: "#e1e1e1"
        },
        reverse: this.axesSpecValue["reverse"]
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
        },
      },
      datalabels: {
        anchor: "center",
        align: "top",
        clip: true,
        borderRadius: 2,
        labels: {
          value: {},
          title: {
            color: "black",
            backgroundColor: "rgba(34, 81, 163, .1)",
          }
        },
        display: (context) => {
          return (this.displayLabelValues.includes(context.dataIndex))
        },
        formatter: (value) => {
          return parseFloat(value["y"]).toFixed(3)
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
    }).filter(value => !Number.isNaN(value))

    let yValue = data.map((d) => {
      return parseFloat(Object.values(d)[1])
    }).filter(value => !Number.isNaN(value))

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
            lineTension: 0,
            cubicInterpolationMode: this.cubicInterpolationMode,
          }],
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

  toggleNormalize() {
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
    else {
      window.scatterChart.resetZoom()

      this.normalized = false
      this.dataValue = this.initialDataValue
      this.visualize()
    }
    this.normalizeButtonTarget.classList.toggle("hidden")
  }

  reset() {
    this.normalized = false
    this.dataValue = this.initialDataValue ? this.initialDataValue : this.dataValue
    this.cubicInterpolationMode = undefined
    window.scatterChart.resetZoom()
    this.gaussianFilterSliderTarget.value = 0
    this.interpolateButtonTarget.classList.remove("hidden")
    this.normalizeButtonTarget.classList.remove("hidden")

    this.visualize()
  }

  resetZoom() {
    window.scatterChart.resetZoom()
  }

  toggleInterpolate() {
    window.scatterChart.resetZoom()
    if (this.cubicInterpolationMode == undefined) {
      this.cubicInterpolationMode = "monotone"
    }
    else {
      this.cubicInterpolationMode = undefined
    }
    this.interpolateButtonTarget.classList.toggle("hidden")
    this.visualize()
  }

  applyGaussianFilter() {
    window.scatterChart.resetZoom()

    let radius = this.gaussianFilterSliderTarget.value

    if (radius < 0 || radius > 10) { return }

    let data = this.hasInitialDataValue ? this.initialDataValue : this.dataValue
    let normalizedY = blur(data.map(e => e["y"]), radius)

    this.initialDataValue = data

    this.dataValue = data.map((e, i) => (
      {
        x: e["x"],
        y: normalizedY[i],
      }
    ))
    this.visualize()
  }
}
