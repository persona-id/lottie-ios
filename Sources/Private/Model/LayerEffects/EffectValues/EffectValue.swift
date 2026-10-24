// Created by Cal Stephens on 8/15/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

// MARK: - EffectValueType

/// https://lottiefiles.github.io/lottie-docs/schema/#/$defs/effect-values
enum EffectValueType: Int, Sendable {
  case slider = 0
  case angle = 1
  case color = 2
  case unknown = 9999
}

// MARK: - EffectValue

class EffectValue: DictionaryInitializable {

  // MARK: Lifecycle

  required init(dictionary: [String: Any]) throws {
    type = (try? dictionary.value(for: CodingKeys.type)).flatMap(EffectValueType.init(rawValue:)) ?? .unknown
    name = (try? dictionary.value(for: CodingKeys.name)) ?? "Effect"
  }

  // MARK: Internal

  /// The type of effect value
  let type: EffectValueType

  /// The name of the effect value
  let name: String

  // MARK: Fileprivate

  fileprivate enum CodingKeys: String {
    case type = "ty"
    case name = "nm"
  }
}

extension [EffectValue] {
  static func fromDictionaries(_ dictionaries: [[String: Any]]) throws -> [EffectValue] {
    try dictionaries.compactMap { dictionary in
      let shapeType = dictionary[EffectValue.CodingKeys.type.rawValue] as? Int
      switch EffectValueType(rawValue: shapeType ?? EffectValueType.unknown.rawValue) {
      case .slider:
        return try Vector1DEffectValue(dictionary: dictionary)
      case .angle:
        return try Vector1DEffectValue(dictionary: dictionary)
      case .color:
        return try ColorEffectValue(dictionary: dictionary)
      case .unknown:
        // Unsupported
        return try EffectValue(dictionary: dictionary)
      case nil:
        return nil
      }
    }
  }
}

// MARK: - EffectValue + Sendable

/// Since `EffectValue` isn't `final`, we have to use `@unchecked Sendable` instead of `Sendable.`
/// All `EffectValue` subclasses are immutable `Sendable` values.
// swiftlint:disable:next no_unchecked_sendable
extension EffectValue: @unchecked Sendable { }
