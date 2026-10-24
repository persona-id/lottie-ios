// Created by Cal Stephens on 8/14/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

final class ColorEffectValue: EffectValue {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let valueDictionary: [String: Any] = try dictionary.value(for: CodingKeys.value)
    value = try KeyframeGroup<LottieColor>(dictionary: valueDictionary)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The value of the color
  let value: KeyframeGroup<LottieColor>?


  // MARK: Private

  private enum CodingKeys: String {
    case value = "v"
  }
}
