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
    urls: Array,
    data: Array,
    initialData: Array,
    filenames: Array,
    ids: Array,
    axesSpec: Object,
    labels: Array,
    dark: Boolean,
    compare: Boolean,
    canvasId: String,
    dataStep: Number,
    controlsDisabled: Boolean
  }

  static targets = ["canvas", "interpolateButton", "normalizeButton", "gaussianFilterSlider", "showLabelsButton", "derivativeButton"]

  normalized = false
  derivativePlot = false
  showLabels = true
  cubicInterpolationMode = undefined
  displayLabelValues = this.labelsValue.map(e => e.map(o => o.position).map(Number))

  connect() {
    if (this.compareValue) {
      this.disableControls()
      this.visualize()
    }
  }

  async import(url) {
    return Promise.all(url.map(u => fetch(u))).then(responses =>
      Promise.all(responses.map(res => res.text()))
    )
  }

  parse(rawData) {

    let data = Papa.parse(rawData).data
    this.dataStepValue = data[0][0] - data[1][0]

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

    let id = this.canvasIdValue

    const makeChart = (data, filenames) => {

      window.scatterChart = new Chart(`canvas-${id}`, {
        type: "scatter",
        data: {
          datasets: data.map((d, i) => ({
            label: filenames[i],
            data: d,
            showLine: true,
            lineTension: 0,
            cubicInterpolationMode: this.cubicInterpolationMode,
            datalabels: {
              anchor: "center",
              align: "top",
              clip: true,
              borderRadius: 2,
              labels: {
                value: {},
                title: {
                  color: this.darkValue ? "white" : "black",
                  // backgroundColor: "rgba(34, 81, 163, .1)",
                }
              },
              display: (context) => {
                if (this.showLabels)
                  return (this.displayLabelValues[i].includes(context.dataIndex) ? "auto" : false)
                else
                  return false
              },
              formatter: (value) => {
                return parseFloat(value["x"]).toFixed(1)
              }
            },
          })),
        },
        options: {
          animation: false,
          parsing: true,
          responsive: true,
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
            line: this.compareValue ? {
              borderWidth: 2
            } :
              {
                backgroundColor: this.darkValue ? "#ffffff" : "#000000",
                borderColor: this.darkValue ? "#ffffff" : "#000000",
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
                color: this.darkValue ? "#1e1e1e" : "#e1e1e1"
              },
              grace: "5%"
            },
            x: {
              title: {
                text: this.axesSpecValue["labels"][0],
                display: true
              },
              grid: {
                borderDash: [8, 4],
                color: this.darkValue ? "#1e1e1e" : "#e1e1e1"
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
              displayColors: !this.compareValue,
              callbacks: {
                label: function (tooltipItem) {
                  return tooltipItem.formattedValue
                },
                title: function () {
                  return
                }
              },
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
            },
            datalabels: {
              display: false
            }
          }
        }
      })
    }

    if (window.scatterChart) { window.scatterChart.destroy() }

    if (this.hasDataValue) {
      makeChart(this.dataValue, this.filenamesValue)
    } else {
      const raw = await this.import(this.urlsValue)
      this.dataValue = raw.map(r => this.parse(r))
      makeChart(this.dataValue, this.filenamesValue)
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
    if (this.compareValue) return

    if (!this.normalized) {
      window.scatterChart.resetZoom()

      this.normalized = true

      let data = this.hasInitialDataValue ? this.initialDataValue[0] : this.dataValue[0]
      let range = this.getRange(data)
      let normalizedY = data.map(e => e["y"] / range[1][1])

      this.initialDataValue = [data]

      this.dataValue = [data.map((e, i) => (
        {
          x: e["x"],
          y: normalizedY[i],
        }
      ))]
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
    this.dataValue = this.hasInitialDataValue ? this.initialDataValue : this.dataValue
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
    if (this.compareValue) return

    window.scatterChart.resetZoom()

    let radius = this.gaussianFilterSliderTarget.value

    if (radius < 0 || radius > 10) { return }

    let data = this.hasInitialDataValue ? this.initialDataValue[0] : this.dataValue[0]
    let smoothedY = blur(data.map(e => e["y"]), radius)

    this.initialDataValue = [data]

    this.dataValue = [data.map((e, i) => (
      {
        x: e["x"],
        y: smoothedY[i],
      }
    ))]
    this.visualize()
  }

  toggleLabels() {
    window.scatterChart.resetZoom()
    this.showLabels = !this.showLabels
    this.showLabelsButtonTarget.classList.toggle("hidden")
    this.visualize()
  }

  disableControls() {
    this.controlsDisabledValue = true
    this.normalizeButtonTarget.parentElement.disabled = true
    this.normalizeButtonTarget.parentElement.classList.add("!text-gray-300")
    this.gaussianFilterSliderTarget.disabled = true
  }

  enableControls() {
    this.controlsDisabledValue = false
    this.normalizeButtonTarget.parentElement.disabled = false
    this.normalizeButtonTarget.parentElement.classList.remove("!text-gray-300")
    this.gaussianFilterSliderTarget.disabled = false
  }

  toggleSecondDerivative() {
    this.derivativePlot = !this.derivativePlot
    if (this.derivativePlot) {
      this.toggleNormalize()
      this.compareValue = true
      this.disableControls()
      window.scatterChart.resetZoom()

      let data = this.hasInitialDataValue ? this.initialDataValue[0] : this.dataValue[0]

      this.initialDataValue = [data]

      let derY = data.flatMap((e, i) => i < data.length - 4 ? (2 * e["y"] - 5 * data[(i + 1)]["y"] + 4 * data[(i + 2)]["y"] - data[(i + 3)]["y"]) / (this.dataStepValue ** 2) : 0)
      let smoothedDerY = blur(derY, 2)
      let [min, max] = [Math.min(...smoothedDerY), Math.max(...smoothedDerY)]
      let rescaledSmoothedDerY = smoothedDerY.map(e => (e - min) / (max - min))

      this.dataValue = [this.dataValue[0], data.map((e, i) => (
        {
          x: e["x"],
          y: rescaledSmoothedDerY[i],
        }
      ))]

      console.log(this.normalized)

      this.displayLabelValues.push([])
      this.filenamesValue = [...this.filenamesValue, "2nd Derivative"]

      this.visualize()
    }
    else {
      this.compareValue = false
      window.scatterChart.resetZoom()
      this.toggleNormalize()
      this.enableControls()
      this.dataValue = this.initialDataValue
      this.displayLabelValues.pop()
      this.filenamesValue.pop()

      this.visualize()
    }
    this.derivativeButtonTarget.classList.toggle("hidden")
  }
}
