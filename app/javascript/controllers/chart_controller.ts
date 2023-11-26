import { Controller } from "@hotwired/stimulus"
import { Chart, ChartComponentLike, ChartConfiguration, ChartDataset, ChartEvent, DatasetChartOptions, LegendElement, LegendItem, registerables } from "chart.js"
import zoomPlugin from "chartjs-plugin-zoom"
import ChartDataLabels, { Context } from "chartjs-plugin-datalabels"
import { Spectrum } from "../spectra/spectrum.ts"
import { Typed } from "stimulus-typescript"
import { Point, SpectrumDataset } from "../spectra/utils.ts"

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
  smoothingRadiusSlider: HTMLInputElement,
  showLabelsButton: HTMLButtonElement,
  derivativePlotButton: HTMLButtonElement,
  transmissionPlotButton: HTMLButtonElement,
  reverseXAxisButton: HTMLButtonElement,
}

export default class ChartController extends Typed(Controller, { values, targets }) {

  labelAlignment: "top" | "bottom" = "top"
  cubicInterpolationMode: DatasetChartOptions["scatter"]["datasets"]["cubicInterpolationMode"] = "monotone"
  allowedKeys = Object.getOwnPropertyNames(new Spectrum) as (keyof Spectrum)[]
  chart: Chart

  spectra = this.spectraValue
    .map(r => JSON.parse(r))
    .map(e => Spectrum.create({
      ...this.allowedKeys.reduce((obj, key) => ({ ...obj, [key]: e[key] }), {}),
      data: {
        metadata: e.metadata
      }
    }))

  defaultLegendClickHandler = Chart.defaults.plugins.legend.onClick
  customLegendClickHandler = function (_e: ChartEvent, legendItem: LegendItem) {
    const chart: Chart = this.chart
    
    chart.config.data.datasets.forEach((ds: ChartDataset, i: number) => {
      const dataset: SpectrumDataset = this.spectra.map((s: Spectrum) => {
        return s.findDatasetByID(chart.config.data.datasets[i]["id"])
      })[0]
      ds.hidden = i !== legendItem.datasetIndex
      Object.assign(dataset, { ...dataset, hidden: ds.hidden })
    })
    
    chart.update()
  }

  legendClickHandler = this.compareValue ?
    this.defaultLegendClickHandler :
    this.customLegendClickHandler

  async connect() {
    const rawData = await this.importData(this.spectra.map(e => e.processed_file_url))
    this.spectra.map((e, i) => e.parseRawData(rawData[i]))

    if (this.compareValue) this.visualize()
    console.log(this.spectra[0].data.datasets)
    this.visualize()
  }

  async importData(url: string[]): Promise<string[]> {
    return Promise.all(url.map(u => fetch(u))).then(responses =>
      Promise.all(responses.map(res => res.text()))
    )
  }

  constructDatasets(spectrum: Readonly<Spectrum>) {
    const peaks = spectrum.getPeakPositions()
    return spectrum.data.datasets.map(ds => {
      return {
        id: ds.id,
        data: ds.data,
        label: `${spectrum.processed_filename.split(".")[0]} (${ds.yLabel})`,
        hidden: ds.hidden,
        showLine: true,
        cubicInterpolationMode: this.cubicInterpolationMode,
        yAxisID: this.compareValue ? "y" : ds.yAxisID,
        xAxisID: this.compareValue ? "x" : ds.xAxisID,
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
            return (peaks.includes(context.dataIndex) ? "auto" : false)
          },
          formatter: (value: Point) => {
            return value["x"].toFixed(spectrum.axes.peakLabelPrecision)
          }
        }
      } as ChartConfiguration<"scatter">["data"]["datasets"][number]
    })
  }

  constructScales(spectrum: Readonly<Spectrum>) {
    const grid = {
      color: this.darkValue ? "#1e1e1e" : "#e1e1e1",
      tickBorderDash: [0, 0],
      tickLength: 10,
      tickWidth: 1,
    }
    const border = { dash: [4, 4] }
    const type = "linear"
    const display = "auto"

    const yAxes: [string, object][] = spectrum.data.datasets.map(ds => {
      return [ds.yAxisID, {
        border,
        display,
        type,
        position: "left",
        title: {
          text: ds.yLabel,
          display: true
        },
        min: ds.yAxisMin,
        grid,
        grace: "5%"
      } as ChartScale[keyof ChartScale]]
    })

    const xAxes: [string, object][] = spectrum.data.datasets.map(ds => {
      return [ds.xAxisID, {
        display,
        type,
        position: "bottom",
        border,
        title: {
          text: ds.xLabel,
          display: true
        },
        grid,
        reverse: ds.xAxisReverse
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
          text: spectrum.data.datasets.map(ds => ds.xLabel),
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
          text: spectrum.data.datasets.map(ds => ds.yLabel),
          display: true
        },
        grid,
        reverse: spectrum.axes.xAxisReverse
      }
    }

    return this.compareValue ? compareAxes : axes
  }

  updateControls(e: ChartEvent, legendItem: LegendItem, legend: LegendElement<"scatter">) {
    this.legendClickHandler.bind(this)(e, legendItem, legend)

    const chart = this.chart
    chart.resetZoom()
    const allDatasets = this.chart.data.datasets
    const displayedDatasetIds: string[] = allDatasets.flatMap((ds, i) => this.chart.isDatasetVisible(i) ? ds["id"] : [])

    if (displayedDatasetIds.length > 1 || this.spectra.length > 1) {
      this.derivativePlotButtonTarget.disabled = true
      this.smoothingRadiusSliderTarget.disabled = true
      return
    }

    this.derivativePlotButtonTarget.disabled = false
    this.smoothingRadiusSliderTarget.disabled = false

    const dataset = this.spectra[0].findDatasetByID(displayedDatasetIds[0])

    if (dataset.xAxisReverse) {
      this.reverseXAxisButtonTarget.classList.add("scale-x-[-1]")
    } else {
      this.reverseXAxisButtonTarget.classList.remove("scale-x-[-1]")
    }

    if (dataset.normalized) {
      this.normalizeButtonTarget.classList.add("hidden")
    } else {
      this.normalizeButtonTarget.classList.remove("hidden")
    }

    chart.update()
  }

  visualize() {
    const datasets = this.spectra.map(e => this.constructDatasets(e)).flat() as ChartDataset[]
    const scalesArray = this.spectra.map(e => this.constructScales(e)).flat()
    const scales = Object.assign({}, ...scalesArray) as ChartConfiguration["options"]["scales"]

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
            onClick: this.updateControls.bind(this),
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

    this.chart = window.scatterChart
  }

  resetAll() {
    this.chart.resetZoom()
    this.interpolateButtonTarget.classList.remove("hidden")
    this.normalizeButtonTarget.classList.remove("hidden")
    this.reverseXAxisButtonTarget.classList.remove("scale-x-[-1]")

    if (!this.compareValue) {
      this.smoothingRadiusSliderTarget.value = "0"
    }

    this.spectra.map(e => e.resetData())

    this.visualize()
  }

  toggleInterpolation() {
    if (this.cubicInterpolationMode == undefined) {
      this.cubicInterpolationMode = "monotone"
    }
    else {
      this.cubicInterpolationMode = undefined
    }
    this.interpolateButtonTarget.classList.toggle("hidden")
    this.chart.data.datasets.forEach(e => (e as ChartConfiguration["options"]["datasets"]["scatter"]).cubicInterpolationMode = this.cubicInterpolationMode)
    this.chart.update()
  }

  toggleLabels() {
    this.showLabelsButtonTarget.classList.toggle("hidden")
    this.chart.data.datasets.forEach(e => {
      return e.datalabels.opacity = 1 - (e.datalabels.opacity as number)
    })
    this.chart.update()
  }

  toggleReverseXAxis() {
    const displayedDatasetIds: string[] = this.chart.data.datasets.flatMap((ds, i) => this.chart.isDatasetVisible(i) ? ds["id"] : [])

    this.spectra.map(e => {
      displayedDatasetIds.map(id => {
        const dataset = e.findDatasetByID(id)
        if (dataset) { dataset.xAxisReverse = !dataset.xAxisReverse }
        this.chart.options.scales[dataset.xAxisID] = {
          ...this.chart.options.scales[dataset.xAxisID], reverse: dataset.xAxisReverse
        }
      })
    })

    this.chart.resetZoom()
    this.chart.update()
    this.reverseXAxisButtonTarget.classList.toggle("scale-x-[-1]")
  }

  toggleNormalize() {
    const displayedDatasetIds: string[] = this.chart.data.datasets.flatMap((ds, i) => this.chart.isDatasetVisible(i) ? ds["id"] : [])

    this.spectra.map(e => {
      displayedDatasetIds.map(id => {
        const dataset = e.findDatasetByID(id)
        if (dataset) e.toggleNormalizeDatasetEntry(id)
      })
    })

    const newDatasets = this.spectra.map(e => this.constructDatasets(e)).flat() as ChartDataset[]
    newDatasets.map((e, i) => {
      e.hidden = !this.chart.isDatasetVisible(i)
    })

    this.chart.config.data.datasets = newDatasets

    this.chart.resetZoom()
    this.chart.update()
    this.normalizeButtonTarget.classList.toggle("hidden")
  }

  applySmoothing() {
    const displayedDatasetIds: string[] = this.chart.data.datasets.flatMap((ds, i) => this.chart.isDatasetVisible(i) ? ds["id"] : [])

    this.spectra.map(e => {
      displayedDatasetIds.map(id => {
        const dataset = e.findDatasetByID(id)
        if (dataset) e.smoothDatasetEntry(id, +this.smoothingRadiusSliderTarget.value)
      })
    })

    const newDatasets = this.spectra.map(e => this.constructDatasets(e)).flat() as ChartDataset[]
    newDatasets.map((e, i) => {
      e.hidden = !this.chart.isDatasetVisible(i)
    })

    this.chart.config.data.datasets = newDatasets

    this.chart.update()
  }

  toggleSecondDerivativePlot() {
    if (this.compareValue) { return }

    const allDatasets = this.chart.data.datasets
    const displayedDatasetIDs: string[] = allDatasets.map((ds, i) => this.chart.isDatasetVisible(i) ? ds["id"] : undefined).filter(Boolean)

    if (displayedDatasetIDs.length !== 1) { return }

    this.spectra.map(s => {
      displayedDatasetIDs.map(id => {
        const dataset = s.findDatasetByID(id)
        if (dataset) {
          s.toggleNormalizeDatasetEntry(id)
          s.addSecondDerivativeDataset(id)
        }
      })
    })

    const datasets = this.spectra.map(e => this.constructDatasets(e)).flat() as ChartDataset[]

    this.chart.config.data.datasets = datasets

    this.chart.update()
  }
}
