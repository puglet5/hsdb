import { Controller } from "@hotwired/stimulus"
import { Chart, ChartComponentLike, ChartConfiguration, ChartDataset, DatasetChartOptions, registerables } from "chart.js"
import zoomPlugin from "chartjs-plugin-zoom"
import ChartDataLabels from "chartjs-plugin-datalabels"
import { AxesSpec, Peak, Point } from "../spectra/utils.ts"
import { Spectrum } from "../spectra/spectrum.ts"
import { Object_, Typed } from "stimulus-typescript"

Chart.register(...registerables)
Chart.register(zoomPlugin as unknown as ChartComponentLike)
Chart.register(ChartDataLabels)

declare global {
  interface Window {
    scatterChart: Chart
  }
}

const values = {
  urls: Array<string>,
  currentPlotData: Array<Array<Point>>,
  unmodifiedPlotData: Array<Array<Point>>,
  filenames: Array<string>,
  ids: Array<string>,
  axesSpec: Object_<AxesSpec>,
  labels: Array<Array<Peak>>,
  dark: Boolean,
  compare: Boolean,
  canvasId: String,
  controlsDisabled: Boolean
}

const targets = {
  canvas: HTMLCanvasElement,
  interpolateButton: HTMLElement,
  normalizeButton: HTMLElement,
  gaussianFilterSlider: HTMLInputElement,
  showLabelsButton: HTMLElement,
  derivativePlotButton: HTMLElement,
  transmissionPlotButton: HTMLElement,
  reverseXAxisButton: HTMLElement,
}

export default class extends Typed(Controller, { values, targets }) {

  normalized = false
  normalizeFactor = 1
  labelAlignment: "top" | "bottom" = "top"
  derivativePlot = false
  transmissionPlot = false
  showLabels = true
  cubicInterpolationMode: DatasetChartOptions["scatter"]["datasets"]["cubicInterpolationMode"] = "monotone"
  displayLabelValues: number[][] = this.labelsValue?.map(e => e?.map(o => o.position).map(Number)) ?? []
  spectrum: Spectrum = Spectrum.create({ filename: this.filenamesValue, axes: this.axesSpecValue })

  async connect() {
    const rawData = await this.importData(this.urlsValue)
    this.spectrum.parseRawData(rawData[0])

    console.log(this.spectrum)
  }

  async importData(url: string[]): Promise<string[]> {
    return Promise.all(url.map(u => fetch(u))).then(responses =>
      Promise.all(responses.map(res => res.text()))
    )
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
            return parseFloat(value["x"]).toFixed(this.axesSpecValue.peakLabelPrecision)
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
          text: labels.slice(1, dimensions[0] + 1) ?? this.axesSpecValue.axesLabels[1],
          display: true
        },
        min: this.axesSpecValue.yAxisMin,
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
          text: labels.slice(dimensions[0] + dimensions[1] + 1) ?? this.axesSpecValue.axesLabels[1],
          display: true
        },
        min: this.axesSpecValue.yAxisMin,
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
          text: labels[0] ?? this.axesSpecValue.axesLabels[0],
          display: true
        },
        grid: {
          color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
          tickBorderDash: [0, 0],
          tickLength: 10,
          tickWidth: 1,
        },
        reverse: this.spectrum.axes.xAxisReverse
      },
      x2: {
        display: "auto",
        position: "bottom",
        border: { dash: [4, 4] },
        title: {
          text: labels.slice(dimensions[0] + 1, dimensions[0] + dimensions[1] + 1)
            ?? this.axesSpecValue.axesLabels[1],
          display: true
        },
        min: this.axesSpecValue.yAxisMin,
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
    const { chartData, dimensions } = this.spectrum.data
    const datasets: ChartDataset[] = this.constructDatasets(chartData, dimensions, this.spectrum.data.traceLabels) as ChartDataset[]

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
        scales: this.constructScales(dimensions, this.spectrum.data.header),
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
              mode: "xy",
              enabled: true,
              onPan(ctx) {
                ctx.chart.options.plugins.tooltip.enabled = false
              },
              onPanComplete(ctx) {
                ctx.chart.options.plugins.tooltip.enabled = true
                const active = ctx.chart.getActiveElements()
                if (active) {
                  ctx.chart.tooltip.setActiveElements([{ datasetIndex: 0, index: active[0].index }], { x: 1, y: 1 })
                }
                ctx.chart.update()
              }
            },
            limits: {
              x: { min: "original", max: "original" },
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

  toggleReverseXAxis() {
    window.scatterChart.resetZoom()
    this.spectrum.axes.xAxisReverse = !this.spectrum.axes.xAxisReverse
    this.visualize()
  }
}
