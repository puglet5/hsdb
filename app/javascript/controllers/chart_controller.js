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
    currentPlotData: Array,
    unmodifiedPlotData: Array,
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

  static targets = [
    "canvas",
    "interpolateButton",
    "normalizeButton",
    "gaussianFilterSlider",
    "showLabelsButton",
    "derivativePlotButton",
    "transmissionPlotButton",
    "reverseXAxisButton"
  ]

  normalized = false
  normalizeFactor = undefined
  labelAlignment = "top"
  derivativePlot = false
  transmissionPlot = false
  showLabels = true
  cubicInterpolationMode = undefined
  displayLabelValues = this.labelsValue.map(e => e.map(o => o.position).map(Number))
  reverseXAxis = this.axesSpecValue["reverse"]

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

  parseCSV(rawData) {

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

    if (!this.hasCurrentPlotDataValue && !this.hasUnmodifiedPlotDataValue) {
      const raw = await this.import(this.urlsValue)
      this.unmodifiedPlotDataValue = raw.map(r => this.parseCSV(r))
    }

    if (this.hasUnmodifiedPlotDataValue && !this.hasCurrentPlotDataValue) {
      this.currentPlotDataValue = this.unmodifiedPlotDataValue
    }

    if (window.scatterChart) { window.scatterChart.destroy() }

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
              align: this.labelAlignment,
              clip: true,
              borderRadius: 2,
              backgroundColor: "rgba(255, 255, 255, .75)",
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
                return parseFloat(value["x"]).toFixed(0)
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
              border: { dash: [4, 4] },
              title: {
                text: this.transmissionPlot ? "Transmission, %" : this.axesSpecValue["labels"][1],
                display: true
              },
              min: 0,
              grid: {
                color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
                tickBorderDash: [0, 0],
                tickLength: 10,
                tickWidth: 1,
              },
              grace: "5%"
            },
            x: {
              border: { dash: [4, 4] },
              title: {
                text: this.axesSpecValue["labels"][0],
                display: true
              },
              grid: {
                color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
                tickBorderDash: [0, 0],
                tickLength: 10,
                tickWidth: 1,
              },
              reverse: this.reverseXAxis
            }
          },
          interaction: {
            mode: "nearest",
            axis: "x",
            intersect: false
          },
          plugins: {
            tooltip: {
              animation: false,
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

    makeChart(this.currentPlotDataValue, this.filenamesValue)
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

      let data = this.currentPlotDataValue[0]
      let range = this.getRange(data)
      this.normalizeFactor = range[1][1]
      let normalizedY = data.map(e => e["y"] / this.normalizeFactor)

      this.currentPlotDataValue = [data.map((e, i) => (
        {
          x: e["x"],
          y: normalizedY[i],
        }
      ))]
    }
    else {
      window.scatterChart.resetZoom()

      let data = this.currentPlotDataValue[0]
      let denormalizedY = data.map(e => e["y"] * this.normalizeFactor)

      this.currentPlotDataValue = [data.map((e, i) => (
        {
          x: e["x"],
          y: denormalizedY[i],
        }
      ))]
    }
    this.normalized = !this.normalized
    this.visualize()
    this.normalizeButtonTarget.classList.toggle("hidden")
  }

  resetAll() {
    this.normalized = false
    this.currentPlotDataValue = this.hasUnmodifiedPlotDataValue ? this.unmodifiedPlotDataValue : this.currentPlotDataValue
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

    let data = this.unmodifiedPlotDataValue[0]
    let smoothedY = blur(data.map(e => e["y"]), radius)

    this.currentPlotDataValue = [data.map((e, i) => (
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
    this.transmissionPlotButtonTarget.parentElement.disabled = true
    this.transmissionPlotButtonTarget.parentElement.classList.add("!text-gray-300")
    this.gaussianFilterSliderTarget.disabled = true
  }

  enableControls() {
    this.controlsDisabledValue = false
    this.normalizeButtonTarget.parentElement.disabled = false
    this.normalizeButtonTarget.parentElement.classList.remove("!text-gray-300")
    this.transmissionPlotButtonTarget.parentElement.disabled = false
    this.transmissionPlotButtonTarget.parentElement.classList.remove("!text-gray-300")
    this.gaussianFilterSliderTarget.disabled = false
  }

  toggleSecondDerivativePlot() {
    this.derivativePlot = !this.derivativePlot

    if (this.normalized) this.toggleNormalize()
    this.normalizeButtonTarget.classList.toggle("hidden")

    if (this.derivativePlot) {
      this.toggleNormalize()
      this.compareValue = true
      this.disableControls()
      window.scatterChart.resetZoom()

      let data = this.currentPlotDataValue[0]

      let derY = data.flatMap((e, i) => i < data.length - 4 ? (2 * e["y"] - 5 * data[(i + 1)]["y"] + 4 * data[(i + 2)]["y"] - data[(i + 3)]["y"]) / (this.dataStepValue ** 2) : 0)
      let smoothedDerY = blur(derY, 2)
      let [min, max] = [Math.min(...smoothedDerY), Math.max(...smoothedDerY)]
      let rescaledSmoothedDerY = smoothedDerY.map(e => (e - min) / (max - min))

      this.currentPlotDataValue = [this.currentPlotDataValue[0], data.map((e, i) => (
        {
          x: e["x"],
          y: rescaledSmoothedDerY[i],
        }
      ))]

      this.displayLabelValues.push([])
      this.filenamesValue = [...this.filenamesValue, "2nd Derivative"]
    }
    else {
      this.compareValue = false
      window.scatterChart.resetZoom()
      this.toggleNormalize()
      this.enableControls()
      this.currentPlotDataValue = [this.currentPlotDataValue[0]]
      this.displayLabelValues.pop()
      this.filenamesValue.pop()
    }

    this.visualize()
    this.derivativePlotButtonTarget.classList.toggle("hidden")
  }

  toggleTransmissionPlot() {

    if (this.normalized) this.toggleNormalize()
    this.normalizeButtonTarget.classList.toggle("hidden")

    if (!this.transmissionPlot) {
      window.scatterChart.resetZoom()

      let data = this.currentPlotDataValue[0]
      let range = this.getRange(data)
      let normalizedY = data.map(e => e["y"] / range[1][1])
      let transmY = normalizedY.map((e) => (10 ** (-e)) * 100)

      this.currentPlotDataValue = [data.map((e, i) => (
        {
          x: e["x"],
          y: transmY[i],
        }
      ))]

      this.labelAlignment = "bottom"
    }
    else {
      this.labelAlignment = "top"
      this.currentPlotDataValue = this.unmodifiedPlotDataValue
    }

    this.transmissionPlot = !this.transmissionPlot
    this.visualize()
    this.transmissionPlotButtonTarget.classList.toggle("hidden")
  }

  toggleReverseXAxis() {
    window.scatterChart.resetZoom()
    this.reverseXAxis = !this.reverseXAxis
    this.visualize()
  }
}
