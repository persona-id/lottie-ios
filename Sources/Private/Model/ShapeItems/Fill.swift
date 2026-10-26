//
//  FillShape.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

// MARK: - FillRule

enum FillRule: Int {
  case none
  case nonZeroWinding
  case evenOdd
}

// MARK: - Fill

final class Fill: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let opacityDictionary: [String: Any] = try dictionary.value(for: CodingKeys.opacity)
    opacity = try KeyframeGroup<LottieVector1D>(dictionary: opacityDictionary)
    let colorDictionary: [String: Any] = try dictionary.value(for: CodingKeys.color)
    color = try KeyframeGroup<LottieColor>(dictionary: colorDictionary)
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

  /// The color keyframes for the fill
  let color: KeyframeGroup<LottieColor>

  /// The fill rule to use when filling a path
  let fillRule: FillRule


  // MARK: Private

  private enum CodingKeys: String {
    case opacity = "o"
    case color = "c"
    case fillRule = "r"
  }
}
