//
//  Stroke.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

final class Stroke: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let opacityDictionary: [String: Any] = try dictionary.value(for: CodingKeys.opacity)
    opacity = try KeyframeGroup<LottieVector1D>(dictionary: opacityDictionary)
    let colorDictionary: [String: Any] = try dictionary.value(for: CodingKeys.color)
    color = try KeyframeGroup<LottieColor>(dictionary: colorDictionary)
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
    let dashPatternDictionaries = dictionary[CodingKeys.dashPattern.rawValue] as? [[String: Any]]
    dashPattern = try? dashPatternDictionaries?.map { try DashElement(dictionary: $0) }
    try super.init(dictionary: dictionary)
  }

  init(
    name: String,
    hidden: Bool,
    opacity: KeyframeGroup<LottieVector1D>,
    color: KeyframeGroup<LottieColor>,
    width: KeyframeGroup<LottieVector1D>,
    lineCap: LineCap,
    lineJoin: LineJoin,
    miterLimit: Double,
    dashPattern: [DashElement]?)
  {
    self.opacity = opacity
    self.color = color
    self.width = width
    self.lineCap = lineCap
    self.lineJoin = lineJoin
    self.miterLimit = miterLimit
    self.dashPattern = dashPattern
    super.init(name: name, type: .stroke, hidden: hidden)
  }

  // MARK: Internal

  /// The opacity of the stroke
  let opacity: KeyframeGroup<LottieVector1D>

  /// The Color of the stroke
  let color: KeyframeGroup<LottieColor>

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

  /// Creates a copy of this Stroke with the given updated width keyframes
  func copy(width newWidth: KeyframeGroup<LottieVector1D>) -> Stroke {
    Stroke(
      name: name,
      hidden: hidden,
      opacity: opacity,
      color: color,
      width: newWidth,
      lineCap: lineCap,
      lineJoin: lineJoin,
      miterLimit: miterLimit,
      dashPattern: dashPattern)
  }


  // MARK: Private

  private enum CodingKeys: String {
    case opacity = "o"
    case color = "c"
    case width = "w"
    case lineCap = "lc"
    case lineJoin = "lj"
    case miterLimit = "ml"
    case dashPattern = "d"
  }
}
