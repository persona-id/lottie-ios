// Created by Cal Stephens on 8/14/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

final class Vector1DEffectValue: EffectValue {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let valueDictionary: [String: Any] = try dictionary.value(for: CodingKeys.value)
    value = try KeyframeGroup<LottieVector1D>(dictionary: valueDictionary)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The value of the slider
  let value: KeyframeGroup<LottieVector1D>?


  // MARK: Private

  private enum CodingKeys: String {
    case value = "v"
  }
}
