
import Papa from "papaparse"
import { SpectrumData, AxesSpec, Point, normalizeData, getDataRange, SpectrumDataset, toSmoothedData, calculateSecondDerivative } from "./utils.ts"
import { createId } from "@paralleldrive/cuid2"

const produce = <O extends object>(proto: O, base: Data, values: any): O =>
  Object.freeze(Object.assign(Object.seal(Object.assign(Object.create(proto), base)), values))

const transformNaN = (e: string) => { return e === "nan" ? NaN : e }

class Data {
  static create<T extends Data>(
    this: { new(t: Data): T },
    values?: Omit<Partial<T>, keyof Data>,
  ): T {
    return produce(this.prototype as T, new this(Data), values)
  }
}

export class Spectrum extends Data {
  public readonly id: number
  public readonly processed_file_url: string
  public readonly processed_filename: string
  public axes: AxesSpec
  public data: Partial<SpectrumData>

  parseRawData(rawData: string) {
    const config = {
      header: this.axes.spectroscopyMethod === "thz",
      dynamicTyping: true,
      skipEmptyLines: true,
      transform: transformNaN
    }

    const { data, meta } = Papa.parse(rawData, config)

    const rows: number[][] = data.map(e => Object.values(e))
    const cols: number[][] = rows[0].map((_, colIndex) => rows.map(row => row[colIndex])).map(e => e.filter(x => !Number.isNaN(x)))

    this.data.header = meta.fields ?? this.axes.axesLabels
    const xLabels = this.data.header.flatMap((e, i) => this.axes.columnAxisType.split("")[i] === "x" ? e : []) ?? ["x"]
    const yLabels = this.data.header.flatMap((e, i) => this.axes.columnAxisType.split("")[i] === "y" ? e : []) ?? ["y"]

    const pointData = this.dataToPoints(cols, this.axes.columnAxisType)

    this.data.dimensions = pointData.dimensions

    this.data.datasets = pointData.data.map((e, i) => {
      let traceNum = 0
      if (i === this.data.dimensions[0]) {
        traceNum += 1
      }
      return {
        id: createId(),
        originalData: e,
        data: e,
        hidden: i >= 1,
        yAxisID: createId(),
        xAxisID: createId(),
        xLabel: xLabels[traceNum],
        yLabel: yLabels[i],
        yAxisMin: this.axes.yAxisMin,
        xAxisReverse: this.axes.xAxisReverse,
        normalized: false,
        isSecondDerivativeData: false,
        originalRange: getDataRange(e),
        peaks: this.data.metadata.peaks
      } satisfies Partial<SpectrumDataset>
    })
  }

  getPeakPositions() {
    return this.data.datasets[0].peaks?.map(o => o.position).map(Number) ?? []
  }

  dataToPoints(data: Readonly<number[][]>, columnCoordinates: AxesSpec["columnAxisType"]) {
    const parsedData: number[][][] = []
    let latestXIndex = -1
    columnCoordinates.split("").forEach((e, i) => {
      if (e === "x") {
        latestXIndex += 1
        parsedData.push([data[i]])
      } else if (e === "y") {
        parsedData[latestXIndex].push(data[i])
      }
    })

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

  toggleNormalizeDatasetEntry(id: string) {
    const dataset = this.findDatasetByID(id)

    if (dataset.normalized) {
      Object.assign(dataset, {
        ...dataset,
        data: normalizeData(dataset.data, dataset.originalRange[1][1]),
        normalized: false
      })
    } else {
      Object.assign(dataset, {
        ...dataset,
        data: normalizeData(dataset.data),
        normalized: true
      })
    }
  }

  smoothDatasetEntry(id: string, r: number) {
    const dataset = this.findDatasetByID(id)
    console.log(dataset)
    const data = toSmoothedData(dataset.originalData, r)

    if (dataset.normalized) {
      Object.assign(dataset, { ...dataset, data: normalizeData(data) })
    } else {
      Object.assign(dataset, { ...dataset, data })
    }
  }

  addSecondDerivativeDataset(id: string) {
    const dataset = this.findDatasetByID(id)

    const derivativeDataset = {
      ...dataset,
      id: createId(),
      yAxisMin: 0,
      yLabel: `${dataset.yLabel} (2nd Derivative)`,
      isSecondDerivativeData: true,
      normalized: true,
      hidden: false,
      data: calculateSecondDerivative(dataset.data)
    } satisfies SpectrumDataset

    this.data.datasets = [...this.data.datasets, derivativeDataset]
  }

  resetData() {
    this.data.datasets = this.data.datasets.flatMap(ds => {
      if (ds.isSecondDerivativeData) { return [] }
      return {
        ...ds,
        normalized: false,
        data: ds.originalData,
        xAxisReverse: this.axes.xAxisReverse
      }
    })
  }

  findDatasetByID(id: string) {
    return this.data.datasets.filter(e => e.id === id)[0]
  }
}