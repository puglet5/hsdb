import Papa from "papaparse"
import { SpectrumData, AxesSpec, Point } from "./utils.ts"

const produce = (proto: object, base: Data, values: any) =>
  Object.freeze(Object.assign(Object.seal(Object.assign(Object.create(proto), base)), values))

const transformNaN = (e: string) => { return e === "nan" ? NaN : e }

class Data {
  static create<Type extends Data>(
    this: { new(t: Data): Type },
    values?: Omit<Partial<Type>, keyof Data>,
  ): Type {
    return produce(this.prototype, new this(Data), values)
  }
}

export class Spectrum extends Data {
  public id: number
  public processed_file_url: string
  public processed_filename: string
  public axes: AxesSpec
  public data: Partial<SpectrumData> = {} as SpectrumData

  parseRawData(rawData: string) {
    const config = {
      header: this.axes.spectroscopyMethod === "thz",
      dynamicTyping: true,
      skipEmptyLines: true,
      transform: transformNaN
    }

    const { data, meta } = Papa.parse(rawData, config)

    const rows: number[][] = data.map(e => Object.values(e))
    const cols: number[][] = rows[0].map((_, colIndex) => rows.map(row => row[colIndex]))

    this.data.header = meta.fields ?? this.axes.axesLabels
    this.axes.xLabels = this.data.header.flatMap((e, i) => this.axes.columnAxisType.split("")[i] === "x" ? e : []) ?? ["x"]
    this.axes.yLabels = this.data.header.flatMap((e, i) => this.axes.columnAxisType.split("")[i] === "y" ? e : []) ?? ["y"]
    this.data.chartData = this.toChartData(cols, this.axes.columnAxisType).data
    this.data.dimensions = this.toChartData(cols, this.axes.columnAxisType).dimensions

    return this.data.chartData
  }

  getPeakPositions() {
    return this.data.peaks?.map(o => o.position).map(Number)
  }

  toChartData(data: number[][], axesSpec: string) {
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
}