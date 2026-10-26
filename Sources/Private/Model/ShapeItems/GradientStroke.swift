//
//  GradientStroke.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

// MARK: - LineCap

enum LineCap: Int, Sendable {
  case none
  case butt
  case round
  case square
}

// MARK: - LineJoin

enum LineJoin: Int, Sendable {
  case none
  case miter
  case round
  case bevel
}

// MARK: - GradientStroke

final class GradientStroke: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let opacityDictionary: [String: Any] = try dictionary.value(for: CodingKeys.opacity)
    opacity = try KeyframeGroup<LottieVector1D>(dictionary: opacityDictionary)
    let startPointDictionary: [String: Any] = try dictionary.value(for: CodingKeys.startPoint)
    startPoint = try KeyframeGroup<LottieVector3D>(dictionary: startPointDictionary)
    let endPointDictionary: [String: Any] = try dictionary.value(for: CodingKeys.endPoint)
    endPoint = try KeyframeGroup<LottieVector3D>(dictionary: endPointDictionary)
    let gradientRawType: Int = try dictionary.value(for: CodingKeys.gradientType)
    guard let gradient = GradientType(rawValue: gradientRawType) else {
      throw InitializableError.invalidInput()
    }
    gradientType = gradient
    if let highlightLengthDictionary = dictionary[CodingKeys.highlightLength.rawValue] as? [String: Any] {
      highlightLength = try? KeyframeGroup<LottieVector1D>(dictionary: highlightLengthDictionary)
    } else {
      highlightLength = nil
    }
    if let highlightAngleDictionary = dictionary[CodingKeys.highlightAngle.rawValue] as? [String: Any] {
      highlightAngle = try? KeyframeGroup<LottieVector1D>(dictionary: highlightAngleDictionary)
    } else {
      highlightAngle = nil
    }
    let widthDictionary: [String: Any] = try dictionary.value(for: CodingKeys.width)
    width = try KeyframeGroup<LottieVector1D>(dictionary: widthDictionary)
    if
      let lineCapRawValue = dictionary[CodingKeys.lineCap.rawValue] as? Int,
      let lineCap = LineCap(rawValue: lineCapRawValue)
    {
      self.lineCap = lineCap
    } else {
      lineCap = .round
    }
    if
      let lineJoinRawValue = dictionary[CodingKeys.lineJoin.rawValue] as? Int,
      let lineJoin = LineJoin(rawValue: lineJoinRawValue)
    {
      self.lineJoin = lineJoin
    } else {
      lineJoin = .round
    }
    miterLimit = (try? dictionary.value(for: CodingKeys.miterLimit)) ?? 4
    let colorsDictionary: [String: Any] = try dictionary.value(for: CodingKeys.colors)
    let nestedColorsDictionary: [String: Any] = try colorsDictionary.value(for: GradientDataKeys.colors)
    colors = try KeyframeGroup<[Double]>(dictionary: nestedColorsDictionary)
    numberOfColors = try colorsDictionary.value(for: GradientDataKeys.numberOfColors)
    let dashPatternDictionaries = dictionary[CodingKeys.dashPattern.rawValue] as? [[String: Any]]
    dashPattern = try? dashPatternDictionaries?.map { try DashElement(dictionary: $0) }
    try super.init(dictionary: dictionary)
  }

  init(
    name: String,
    hidden: Bool,
    opacity: KeyframeGroup<LottieVector1D>,
    startPoint: KeyframeGroup<LottieVector3D>,
    endPoint: KeyframeGroup<LottieVector3D>,
    gradientType: GradientType,
    highlightLength: KeyframeGroup<LottieVector1D>?,
    highlightAngle: KeyframeGroup<LottieVector1D>?,
    numberOfColors: Int,
    colors: KeyframeGroup<[Double]>,
    width: KeyframeGroup<LottieVector1D>,
    lineCap: LineCap,
    lineJoin: LineJoin,
    miterLimit: Double,
    dashPattern: [DashElement]?)
  {
    self.opacity = opacity
    self.startPoint = startPoint
    self.endPoint = endPoint
    self.gradientType = gradientType
    self.highlightLength = highlightLength
    self.highlightAngle = highlightAngle
    self.numberOfColors = numberOfColors
    self.colors = colors
    self.width = width
    self.lineCap = lineCap
    self.lineJoin = lineJoin
    self.miterLimit = miterLimit
    self.dashPattern = dashPattern
    super.init(name: name, type: .gradientStroke, hidden: hidden)
  }

  // MARK: Internal

  /// The opacity of the fill
  let opacity: KeyframeGroup<LottieVector1D>

  /// The start of the gradient
  let startPoint: KeyframeGroup<LottieVector3D>

  /// The end of the gradient
  let endPoint: KeyframeGroup<LottieVector3D>

  /// The type of gradient
  let gradientType: GradientType

  /// Gradient Highlight Length. Only if type is Radial
  let highlightLength: KeyframeGroup<LottieVector1D>?

  /// Highlight Angle. Only if type is Radial
  let highlightAngle: KeyframeGroup<LottieVector1D>?

  /// The number of color points in the gradient
  let numberOfColors: Int

  /// The Colors of the gradient.
  let colors: KeyframeGroup<[Double]>

  /// The width of the stroke
  let width: KeyframeGroup<LottieVector1D>

  /// Line Cap
  let lineCap: LineCap

  /// Line Join
  let lineJoin: LineJoin

  /// Miter Limit
  let miterLimit: Double

  /// The dash pattern of the stroke
  let dashPattern: [DashElement]?

  /// Creates a copy of this GradientStroke with the given updated width keyframes
  func copy(width newWidth: KeyframeGroup<LottieVector1D>) -> GradientStroke {
    GradientStroke(
      name: name,
      hidden: hidden,
      opacity: opacity,
      startPoint: startPoint,
      endPoint: endPoint,
      gradientType: gradientType,
      highlightLength: highlightLength,
      highlightAngle: highlightAngle,
      numberOfColors: numberOfColors,
      colors: colors,
      width: newWidth,
      lineCap: lineCap,
      lineJoin: lineJoin,
      miterLimit: miterLimit,
      dashPattern: dashPattern)
  }


  // MARK: Private

  private enum CodingKeys: String {
    case opacity = "o"
    case startPoint = "s"
    case endPoint = "e"
    case gradientType = "t"
    case highlightLength = "h"
    case highlightAngle = "a"
    case colors = "g"
    case width = "w"
    case lineCap = "lc"
    case lineJoin = "lj"
    case miterLimit = "ml"
    case dashPattern = "d"
  }

  private enum GradientDataKeys: String {
    case numberOfColors = "p"
    case colors = "k"
  }
}
