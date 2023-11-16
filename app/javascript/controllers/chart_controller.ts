import { Controller } from "@hotwired/stimulus"
import { Chart, ChartComponentLike, ChartConfiguration, ChartDataset, DatasetChartOptions, registerables } from "chart.js"
import zoomPlugin from "chartjs-plugin-zoom"
import ChartDataLabels from "chartjs-plugin-datalabels"
import Papa from "papaparse"
import { blur } from "d3-array"

Chart.register(...registerables)
Chart.register(zoomPlugin as unknown as ChartComponentLike)
Chart.register(ChartDataLabels)

interface Point {
  x: number
  y: number
}

interface Peak {
  position: number
}

interface AxesSpec {
  labels: string[]
  reverse: boolean
  y_min: number | null
  type: string
  cols_type: string
  peak_label_precision: number
}

declare global {
  interface Window {
    scatterChart: Chart
  }
}

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

  urlsValue: string[]
  currentPlotDataValue: Point[][]
  unmodifiedPlotDataValue: Point[][]
  filenamesValue: string[]
  idsValue: string[]
  axesSpecValue!: AxesSpec
  labelsValue!: Peak[][]
  darkValue: boolean
  compareValue: boolean
  canvasIdValue: string
  dataStepValue: number
  controlsDisabledValue: boolean

  readonly hasUrlsValue: boolean
  readonly hasCurrentPlotDataValue: boolean
  readonly hasUnmodifiedPlotDataValue: boolean
  readonly hasFilenamesValue: boolean
  readonly hasIdsValue: boolean
  readonly hasAxesSpecValue: boolean
  readonly hasLabelsValue: boolean
  readonly hasDarkValue: boolean
  readonly hasCompareValue: boolean
  readonly hasCanvasIdValue: boolean
  readonly hasDataStepValue: boolean
  readonly hasControlsDisabledValue: boolean

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

  readonly canvasTarget!: HTMLCanvasElement
  readonly interpolateButtonTarget!: HTMLElement
  readonly normalizeButtonTarget!: HTMLElement
  readonly gaussianFilterSliderTarget!: HTMLInputElement
  readonly showLabelsButtonTarget!: HTMLElement
  readonly derivativePlotButtonTarget!: HTMLElement
  readonly transmissionPlotButtonTarget!: HTMLElement
  readonly reverseXAxisButtonTarget!: HTMLElement

  readonly hasCanvasTarget!: boolean
  readonly hasInterpolateButtonTarget!: boolean
  readonly hasNormalizeButtonTarget!: boolean
  readonly hasGaussianFilterSliderTarget!: boolean
  readonly hasShowLabelsButtonTarget!: boolean
  readonly hasDerivativePlotButtonTarget!: boolean
  readonly hasTransmissionPlotButtonTarget!: boolean
  readonly hasReverseXAxisButtonTarget!: boolean

  normalized = false
  normalizeFactor = 1
  labelAlignment: "top" | "bottom" = "top"
  derivativePlot = false
  transmissionPlot = false
  showLabels = true
  cubicInterpolationMode: DatasetChartOptions["scatter"]["datasets"]["cubicInterpolationMode"] = "monotone"
  displayLabelValues: number[][] = this.labelsValue?.map(e => e?.map(o => o.position).map(Number)) ?? []
  reverseXAxis: boolean = this.axesSpecValue.reverse
  // @ts-ignore
  traceLabels: string[] = this.filenamesValue
  dataHeader: string[] = ["x", "y"]

  connect() {
    this.visualize()
    if (this.compareValue) {
      this.disableControls()
      this.visualize()
    }
  }

  async import(url: string[]): Promise<string[]> {
    return Promise.all(url.map(u => fetch(u))).then(responses =>
      Promise.all(responses.map(res => res.text()))
    )
  }

  parseCSV(rawData: string) {

    const transformNaN = (e: string) => { return e === "nan" ? NaN : e }

    const config = {
      header: this.axesSpecValue.type === "thz",
      dynamicTyping: true,
      skipEmptyLines: true,
      transform: transformNaN
    }

    const { data, meta } = Papa.parse(rawData, config)

    const header = meta.fields ?? this.axesSpecValue.labels

    const rows: number[][] = data.map(e => Object.values(e))
    const cols: number[][] = rows[0].map((_, colIndex) => rows.map(row => row[colIndex]))

    const labels = header.flatMap((e, i) => this.axesSpecValue.cols_type.split("")[i] === "y" ? e : [])

    this.dataHeader = header
    this.traceLabels = labels

    return this.toChartData(cols, this.axesSpecValue.cols_type)
  }

  toChartData(data: number[][], axesSpec: string) {
    // [[x[], y[], y[]], [x[], y[]]]
    const parsedData: number[][][] = []
    let latestXIndex: number = -1
    axesSpec.split("").forEach((e, i) => {
      if (e === "x") {
        latestXIndex += 1
        parsedData.push([data[i]])
      } else if (e === "y") {
        parsedData[latestXIndex].push(data[i])
      }
    })

    // [[x[], y[]], ...]

    const convertedDataIntermediate = parsedData.map(traceE => traceE.map((e, i) => {
      return [traceE[0], traceE[i]]
    }).slice(1))

    const dataDimensions = convertedDataIntermediate.map(e => e.length)
    const convertedData = convertedDataIntermediate.flat()

    const objectData: Point[][] = convertedData.map(data => {
      return data[0].map((v, i) => {
        return [v, data[1][i]]
      })
        .map((v) => {
          const [x, y] = v
          return { x, y }
        })
    })

    return { data: objectData, dimensions: dataDimensions }
  }

  constructDatasets(data: Point[][], dimensions: number[], labels: string[]) {
    let traceNum = 1
    return labels.map((label, i) => {
      if (i === dimensions[0]) {
        traceNum += 1
      }
      return {
        data: data[i],
        label: label,
        hidden: i >= 1,
        showLine: true,
        lineTension: 0,
        cubicInterpolationMode: this.cubicInterpolationMode,
        yAxisID: `y${traceNum}`,
        xAxisID: `x${traceNum}`,
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
              return (this.displayLabelValues[i]?.includes(context.dataIndex) ? "auto" : false)
            else
              return false
          },
          formatter: (value) => {
            return parseFloat(value["x"]).toFixed(this.axesSpecValue.peak_label_precision)
          }
        },
      } as ChartConfiguration["options"]["datasets"]
    })
  }

  constructScales(dimensions: number[], labels: string[]) {
    return {
      y: { display: false },
      x: { display: false },
      y1: {
        border: { dash: [4, 4] },
        display: "auto",
        type: "linear",
        position: "left",
        title: {
          text: labels.slice(1, dimensions[0] + 1) ?? this.axesSpecValue.labels[1],
          display: true
        },
        min: this.axesSpecValue.y_min,
        grid: {
          color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
          tickBorderDash: [0, 0],
          tickLength: 10,
          tickWidth: 1,
        },
        grace: "5%"
      },
      y2: {
        display: "auto",
        type: "linear",
        position: "left",
        border: { dash: [4, 4] },
        title: {
          text: labels.slice(dimensions[0] + dimensions[1] + 1) ?? this.axesSpecValue.labels[1],
          display: true
        },
        min: this.axesSpecValue.y_min,
        grid: {
          color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
          tickBorderDash: [0, 0],
          tickLength: 10,
          tickWidth: 1,
        },
        grace: "5%"
      },
      x1: {
        display: "auto",
        type: "linear",
        position: "bottom",
        border: { dash: [4, 4] },
        title: {
          text: labels[0] ?? this.axesSpecValue.labels[0],
          display: true
        },
        grid: {
          color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
          tickBorderDash: [0, 0],
          tickLength: 10,
          tickWidth: 1,
        },
        reverse: this.reverseXAxis
      },
      x2: {
        display: "auto",
        position: "bottom",
        border: { dash: [4, 4] },
        title: {
          text: labels.slice(dimensions[0] + 1, dimensions[0] + dimensions[1] + 1)
            ?? this.axesSpecValue.labels[1],
          display: true
        },
        min: this.axesSpecValue.y_min,
        grid: {
          color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
          tickBorderDash: [0, 0],
          tickLength: 10,
          tickWidth: 1,
        },
      }
    } as ChartConfiguration["options"]["scales"]
  }

  async visualize() {

    // if (!this.hasCurrentPlotDataValue && !this.hasUnmodifiedPlotDataValue) {
    //   const raw = await this.import(this.urlsValue)
    //   this.unmodifiedPlotDataValue = raw.map(r => this.parseCSV(r))
    // }

    // if (this.hasUnmodifiedPlotDataValue && !this.hasCurrentPlotDataValue) {
    //   this.currentPlotDataValue = this.unmodifiedPlotDataValue
    // }

    const rawData = await this.import(this.urlsValue)
    const parsedData = rawData.map(r => this.parseCSV(r)).flat()[0]
    const dataDimensions = parsedData.dimensions
    const chartData = parsedData.data
    const datasets: ChartDataset[] = this.constructDatasets(chartData, dataDimensions, this.traceLabels) as ChartDataset[]

    if (window.scatterChart) { window.scatterChart.destroy() }

    window.scatterChart = new Chart(`canvas-${this.canvasIdValue}`, {
      type: "scatter",
      data: {
        datasets: datasets
      },
      options: {
        events: ["dblclick", "mousemove", "mouseout", "click", "drag", "wheel"],
        locale: "fr",
        animation: false,
        responsive: true,
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
        scales: this.constructScales(dataDimensions, this.dataHeader),
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
              enabled: true,
              //@ts-ignore
              onPanStart(ctx) {
                ctx.chart.options.plugins.tooltip.enabled = false
              },
              onPanComplete(ctx) {
                ctx.chart.options.plugins.tooltip.enabled = true
                const active = ctx.chart.getActiveElements()
                ctx.chart.tooltip.setActiveElements([{ datasetIndex: 0, index: active[0].index }], { x: 1, y: 1 })
                ctx.chart.update()
              }
            },
            limits: {
              x: { min: "original", max: "original" },
              y: { min: "original", max: "original" }
            },
          },
          legend:
          {
            onClick: function (e, legendItem) {
              const index = legendItem.datasetIndex
              const chart = this.chart

              chart.data.datasets.forEach(function (e, i) {
                const meta = chart.getDatasetMeta(i)

                if (i !== index) {
                  meta.hidden = true
                } else if (i === index) {
                  meta.hidden = false
                }
              })

              chart.update()
            },
            labels: {
              boxWidth: 0,
            }
          },
          datalabels: {
            display: false
          }
        }
      },
      plugins: [
        {
          id: "doubleClick",
          afterEvent(chart, evt) {
            if (evt.event.type === "dblclick") {
              setTimeout(() => {
                chart.resetZoom()
              }, 0)
            }
          }
        },
        {
          id: "toolbarHider",
          afterEvent: (chart, evt) => {
            const { left, right, bottom, top } = chart.chartArea
            const e = evt.event
            const status = e.x >= left && e.x <= right && e.y <= bottom && e.y >= top
            if (status !== chart.options.plugins.tooltip.enabled) {
              chart.options.plugins.tooltip.enabled = status
              chart.update()
            }
          }
        },
      ]
    })

  }

  getRange(data: Point[]): number[][] {
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

      const data: Point[] = this.currentPlotDataValue[0]
      const range: number[][] = this.getRange(data)
      this.normalizeFactor = range[1][1]
      const normalizedY: number[] = data.map(e => e["y"] / this.normalizeFactor)

      this.currentPlotDataValue = [data.map((e, i) => (
        {
          x: e["x"],
          y: normalizedY[i],
        }
      ))]
    }
    else {
      window.scatterChart.resetZoom()

      const data: Point[] = this.currentPlotDataValue[0]
      const denormalizedY: number[] = data.map(e => e["y"] * this.normalizeFactor)

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
    this.gaussianFilterSliderTarget.value = "0"
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

    const radius = parseFloat(this.gaussianFilterSliderTarget.value)
    if (radius < 0 || radius > 10) { return }

    const data = this.unmodifiedPlotDataValue[0]
    const smoothedY: number[] = blur(data.map(e => e["y"]), radius)

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
    this.controlsDisabledValue = true;
    (this.normalizeButtonTarget.parentElement as HTMLButtonElement).disabled = true;
    (this.normalizeButtonTarget.parentElement as HTMLButtonElement).classList.add("!text-gray-300");
    (this.transmissionPlotButtonTarget.parentElement as HTMLButtonElement).disabled = true;
    (this.transmissionPlotButtonTarget.parentElement as HTMLButtonElement).classList.add("!text-gray-300")
    this.gaussianFilterSliderTarget.disabled = true
  }

  enableControls() {
    this.controlsDisabledValue = false;
    (this.normalizeButtonTarget.parentElement as HTMLButtonElement).disabled = false;
    (this.normalizeButtonTarget.parentElement as HTMLButtonElement).classList.remove("!text-gray-300");
    (this.transmissionPlotButtonTarget.parentElement as HTMLButtonElement).disabled = false;
    (this.transmissionPlotButtonTarget.parentElement as HTMLButtonElement).classList.remove("!text-gray-300")
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

      const data: Point[] = this.currentPlotDataValue[0]

      const derY: number[] = data.flatMap((e, i) => i < data.length - 4 ? (2 * e["y"] - 5 * data[(i + 1)]["y"] + 4 * data[(i + 2)]["y"] - data[(i + 3)]["y"]) / (this.dataStepValue ** 2) : 0)
      const smoothedDerY: number[] = blur(derY, 2)
      const [min, max] = [Math.min(...smoothedDerY), Math.max(...smoothedDerY)]
      const rescaledSmoothedDerY: number[] = smoothedDerY.map(e => (e - min) / (max - min))

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

      const data: Point[] = this.currentPlotDataValue[0]
      const range: number[][] = this.getRange(data)
      const normalizedY: number[] = data.map(e => e["y"] / range[1][1])
      const transmY: number[] = normalizedY.map((e) => (10 ** (-e)) * 100)

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
