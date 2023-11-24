import { Controller } from "@hotwired/stimulus"
import { Chart, ChartComponentLike, ChartConfiguration, ChartDataset, ChartEvent, DatasetChartOptions, LegendItem, registerables } from "chart.js"
import zoomPlugin from "chartjs-plugin-zoom"
import ChartDataLabels, { Context } from "chartjs-plugin-datalabels"
import { Spectrum } from "../spectra/spectrum.ts"
import { Typed } from "stimulus-typescript"
import { Point } from "../spectra/utils.ts"

Chart.register(...registerables)
Chart.register(zoomPlugin as unknown as ChartComponentLike)
Chart.register(ChartDataLabels)

type ChartScale = ChartConfiguration["options"]["scales"]

declare global {
  interface Window {
    scatterChart: Chart
  }
}

const values = {
  dark: Boolean,
  compare: Boolean,
  canvasId: String,
  controlsDisabled: Boolean,
  spectra: Array<string>
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
  labelAlignment: "top" | "bottom" = "top"
  cubicInterpolationMode: DatasetChartOptions["scatter"]["datasets"]["cubicInterpolationMode"] = "monotone"
  allowedKeys = Object.getOwnPropertyNames(new Spectrum) as (keyof Spectrum)[]

  spectra = this.spectraValue
    .map(r => JSON.parse(r))
    .map(e => Spectrum.create({
      ...this.allowedKeys.reduce((obj, key) => ({ ...obj, [key]: e[key] }), {}),
      data: {}
    }))

  async connect() {
    const rawData = await this.importData(this.spectra.map(e => e.processed_file_url))
    this.spectra.map((e, i) => e.parseRawData(rawData[i]))
    
    if (this.compareValue) this.visualize()
  }

  async importData(url: string[]): Promise<string[]> {
    return Promise.all(url.map(u => fetch(u))).then(responses =>
      Promise.all(responses.map(res => res.text()))
    )
  }

  constructDatasets(spectrum: Spectrum, data: Point[][]) {
    let traceNum = 0
    return spectrum.axes.yLabels.map((label, i) => {
      if (i === spectrum.data.dimensions[0]) {
        traceNum += 1
      }
      return {
        data: data[i],
        label: `${spectrum.processed_filename.split(".")[0]} (${label})`,
        hidden: i >= 1,
        showLine: true,
        cubicInterpolationMode: this.cubicInterpolationMode,
        yAxisID: this.compareValue ? "y" : `y${spectrum.id}${i}`,
        xAxisID: this.compareValue ? "x" : `x${spectrum.id}${traceNum}`,
        datalabels: {
          anchor: "center",
          align: "top",
          clip: true,
          opacity: 1,
          borderRadius: 2,
          backgroundColor: "rgba(255, 255, 255, .75)",
          labels: {
            value: {},
            title: {
              color: this.darkValue ? "white" : "black",
              // backgroundColor: "rgba(34, 81, 163, .1)",
            }
          },
          display: (context: Context) => {
            return (spectrum.getPeakPositions().includes(context.dataIndex) ? "auto" : false)
          },
          formatter: (value: Point) => {
            return value["x"].toFixed(spectrum.axes.peakLabelPrecision)
          }
        }
      } as ChartConfiguration<"scatter">["data"]["datasets"][number]
    })
  }

  constructScales(spectrum: Spectrum) {

    const grid = {
      color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
      tickBorderDash: [0, 0],
      tickLength: 10,
      tickWidth: 1,
    }
    const border = { dash: [4, 4] }
    const type = "linear"
    const display = "auto"

    const yAxes: [string, object][] = spectrum.axes.yLabels.map((e, i) => {
      return [`y${spectrum.id}${i}`, {
        border,
        display,
        type,
        position: "left",
        title: {
          text: e,
          display: true
        },
        min: spectrum.axes.yAxisMin,
        grid,
        grace: "5%"
      } as ChartScale[keyof ChartScale]]
    })

    const xAxes: [string, object][] = spectrum.axes.xLabels.map((e, i) => {
      return [`x${spectrum.id}${i}`, {
        display,
        type,
        position: "bottom",
        border,
        title: {
          text: e,
          display: true
        },
        grid,
        reverse: spectrum.axes.xAxisReverse
      } as ChartScale[keyof ChartScale]]
    })

    const entries = new Map([
      ["y", { display: false }],
      ["x", { display: false }],
      ...xAxes,
      ...yAxes
    ])

    const axes = Object.fromEntries(entries) as ChartScale

    const compareAxes = {
      x: {
        display,
        border,
        type,
        position: "left",
        title: {
          text: spectrum.axes.xLabels,
          display: true
        },
        min: spectrum.axes.yAxisMin,
        grid,
        grace: "5%"
      },
      y: {
        display,
        type,
        position: "bottom",
        border,
        title: {
          text: spectrum.axes.yLabels,
          display: true
        },
        grid,
        reverse: spectrum.axes.xAxisReverse
      }
    }

    return this.compareValue ? compareAxes : axes
  }

  async visualize() {
    const datasets = this.spectra.map(e => this.constructDatasets(e, e.data.datasets.map(e => e.originalData))).flat() as ChartDataset[]
    const scalesArray = this.spectra.map(e => this.constructScales(e)).flat()
    const scales = Object.assign({}, ...scalesArray) as ChartConfiguration["options"]["scales"]

    const defaultLegendClickHandler = Chart.defaults.plugins.legend.onClick
    const customLegendClickHandler = function (_e: ChartEvent, legendItem: LegendItem) {
      const chart: Chart = this.chart

      chart.data.datasets.forEach((_, i) => {
        const meta = chart.getDatasetMeta(i)
        meta.hidden = i !== legendItem.datasetIndex
      })

      chart.update()
    }
    const legendClickHandler = this.compareValue ? defaultLegendClickHandler : customLegendClickHandler

    if (window.scatterChart) { window.scatterChart.destroy() }

    window.scatterChart = new Chart(`canvas-${this.canvasIdValue}`, {
      type: "scatter",
      data: {
        datasets
      },
      options: {
        events: ["dblclick", "mousemove", "mouseout", "click", "drag", "wheel"],
        locale: "en",
        animation: false,
        responsive: true,
        normalized: true,
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
        scales,
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
                if (active[0]) {
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
            onClick: legendClickHandler,
            labels: {
              boxWidth: 0,
            }
          },
          datalabels: {
            display: false
          }
        },
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
    if (this.cubicInterpolationMode == undefined) {
      this.cubicInterpolationMode = "monotone"
    }
    else {
      this.cubicInterpolationMode = undefined
    }
    this.interpolateButtonTarget.classList.toggle("hidden")
    window.scatterChart.data.datasets.forEach(e => (e as ChartConfiguration["options"]["datasets"]["scatter"]).cubicInterpolationMode = this.cubicInterpolationMode)
    window.scatterChart.update()
  }

  toggleLabels() {
    this.showLabelsButtonTarget.classList.toggle("hidden")
    window.scatterChart.data.datasets.forEach(e => {
      return e.datalabels.opacity = 1 - (e.datalabels.opacity as number)
    })
    window.scatterChart.update()
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
    this.spectra.map(e => e.axes.xAxisReverse = !e.axes.xAxisReverse)
    this.visualize()
  }

  toggleNormalize() {
    const chart = window.scatterChart

    const allDatasets = chart.data.datasets
    const displayedDatasetIds = allDatasets.flatMap((_ds, i) => chart.isDatasetVisible(i) ? i : [])

    const datasetsPerSpectrum = this.spectra.map(e => e.data.datasets.length)

    const datasetsBySpectrum = datasetsPerSpectrum.map((de, di) => {
      let mask = displayedDatasetIds.map((id, i) => de * (di + 1) > id && id >= de * di)
      return displayedDatasetIds.filter((_e, i) => mask[i]).map(e => e % de)
    })

    this.spectra.map((e, i) => {
      datasetsBySpectrum[i].map(de => {
        e.toggleNormalizeDatasetEntry(de)
      })
    })

    const newDatasets = this.spectra.map(e => this.constructDatasets(e, e.data.datasets.map(e => e.data))).flat() as ChartDataset[]
    newDatasets.map((e, i) => {
      e.hidden = !chart.isDatasetVisible(i)
    })

    chart.config.data.datasets = newDatasets

    chart.resetZoom()
    chart.update()
    this.normalizeButtonTarget.classList.toggle("hidden")

  }
}
