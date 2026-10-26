//
//  GradientFill.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

// MARK: - GradientType

enum GradientType: Int, Sendable {
  case none
  case linear
  case radial
}

// MARK: - GradientFill

final class GradientFill: ShapeItem {

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
    let colorsDictionary: [String: Any] = try dictionary.value(for: CodingKeys.colors)
    let nestedColorsDictionary: [String: Any] = try colorsDictionary.value(for: GradientDataKeys.colors)
    colors = try KeyframeGroup<[Double]>(dictionary: nestedColorsDictionary)
    numberOfColors = try colorsDictionary.value(for: GradientDataKeys.numberOfColors)
    if
      let fillRuleRawValue = dictionary[CodingKeys.fillRule.rawValue] as? Int,
      let fillRule = FillRule(rawValue: fillRuleRawValue)
    {
      self.fillRule = fillRule
    } else {
      fillRule = .nonZeroWinding
    }
    try super.init(dictionary: dictionary)
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

  /// The fill rule to use when filling a path
  let fillRule: FillRule


  // MARK: Private

  private enum CodingKeys: String {
    case opacity = "o"
    case startPoint = "s"
    case endPoint = "e"
    case gradientType = "t"
    case highlightLength = "h"
    case highlightAngle = "a"
    case colors = "g"
    case fillRule = "r"
  }

  private enum GradientDataKeys: String {
    case numberOfColors = "p"
    case colors = "k"
  }
}
