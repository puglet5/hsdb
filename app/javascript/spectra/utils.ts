

function blur(values, r) {
  if (!((r = +r) >= 0)) throw new RangeError("invalid r")
  let length = values.length
  if (!((length = Math.floor(length)) >= 0)) throw new RangeError("invalid length")
  if (!length || !r) return values
  const blur = blurf(r)
  const temp = values.slice()
  blur(values, temp, 0, length, 1)
  blur(temp, values, 0, length, 1)
  blur(values, temp, 0, length, 1)
  return values
}

function bluri(radius) {
  const w = 2 * radius + 1
  return (T, S, start, stop, step) => { // stop must be aligned!
    if (!((stop -= step) >= start)) return // inclusive stop
    let sum = radius * S[start]
    const s = step * radius
    for (let i = start, j = start + s; i < j; i += step) {
      sum += S[Math.min(stop, i)]
    }
    for (let i = start, j = stop; i <= j; i += step) {
      sum += S[Math.min(stop, i + s)]
      T[i] = sum / w
      sum -= S[Math.max(start, i - s)]
    }
  }
}

function blurf(radius) {
  const radius0 = Math.floor(radius)
  if (radius0 === radius) return bluri(radius)
  const t = radius - radius0
  const w = 2 * radius + 1
  return (T, S, start, stop, step) => { // stop must be aligned!
    if (!((stop -= step) >= start)) return // inclusive stop
    let sum = radius0 * S[start]
    const s0 = step * radius0
    const s1 = s0 + step
    for (let i = start, j = start + s0; i < j; i += step) {
      sum += S[Math.min(stop, i)]
    }
    for (let i = start, j = stop; i <= j; i += step) {
      sum += S[Math.min(stop, i + s0)]
      T[i] = (sum + t * (S[Math.max(start, i - s1)] + S[Math.min(stop, i + s1)])) / w
      sum -= S[Math.max(start, i - s0)]
    }
  }
}

export interface Point {
  x: number
  y: number
}

export interface Peak {
  position: number
}

export interface AxesSpec {
  axesLabels: string[]
  xAxisReverse: boolean
  yAxisMin: number | null
  xLabels: string[]
  yLabels: string[]
  columnAxisType: "xy" | "xyyxy" | string
  peakLabelPrecision: number
  spectroscopyMethod: string
}

export interface SpectrumData {
  rawData: string
  chartData: Point[][]
  alteredData: Point[][]
  header: string[]
  dimensions: number[]
  peaks: Peak[]
  secondDerivativeData: Point[][]
  normalizedData: Point[][]
}

export function getDataRange(data: Point[]): number[][] {
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

export function normalizeData(data: Point[]) {
  const range: number[][] = getDataRange(data)
  const normalizationFactor = range[1][1]
  const normalizedY: number[] = data.map(e => e["y"] / normalizationFactor)

  data.map((e, i) => (
    {
      x: e["x"],
      y: normalizedY[i],
    }
  ))
  return data
}

export function calculateSecondDerivative(data: Point[]) {
  const dataStep = data[1]["x"] - data[0]["x"]
  const derY: number[] = data.flatMap((e, i) => i < data.length - 4 ? (2 * e["y"] - 5 * data[(i + 1)]["y"] + 4 * data[(i + 2)]["y"] - data[(i + 3)]["y"]) / (dataStep ** 2) : 0)
  const smoothedDerY: number[] = blur(derY, 2)
  const [min, max] = [Math.min(...smoothedDerY), Math.max(...smoothedDerY)]
  const rescaledSmoothedDerY: number[] = smoothedDerY.map(e => (e - min) / (max - min))

  const derivativeData = data.map((e, i) => (
    {
      x: e["x"],
      y: rescaledSmoothedDerY[i],
    }
  ))

  return derivativeData
}

export function toTransmissionData(data: Point[]) {
  const range: number[][] = getDataRange(data)
  const normalizedY: number[] = data.map(e => e["y"] / range[1][1])
  const transmY: number[] = normalizedY.map((e) => (10 ** (-e)) * 100)

  const transmissionData = data.map((e, i) => (
    {
      x: e["x"],
      y: transmY[i],
    }
  ))

  return transmissionData
}

export function smoothData(data: Point[], radius: number) {
  if (radius < 0 || radius > 10) { return }

  const smoothedY: number[] = blur(data.map(e => e["y"]), radius)
  const smoothedData = data.map((e, i) => (
    {
      x: e["x"],
      y: smoothedY[i],
    }
  ))

  return smoothedData
}