// Created by Cal Stephens on 8/14/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

// MARK: - LayerEffectType

/// https://lottiefiles.github.io/lottie-docs/schema/#/$defs/effects
enum LayerEffectType: Int, Sendable {
  case dropShadow = 25
  case unknown = 9999
}

// MARK: - LayerEffect

class LayerEffect: DictionaryInitializable {

  // MARK: Lifecycle

  required init(dictionary: [String: Any]) throws {
    name = (try? dictionary.value(for: CodingKeys.name)) ?? "Layer"
    type = LayerEffectType(rawValue: try dictionary.value(for: CodingKeys.type)) ?? .unknown
    if let valueDictionaries = dictionary[CodingKeys.effects.rawValue] as? [[String: Any]] {
      effects = try [EffectValue].fromDictionaries(valueDictionaries)
    } else {
      effects = []
    }
  }

  // MARK: Internal

  /// The name of the effect
  let name: String

  /// The type of effect
  let type: LayerEffectType

  /// Values that configure the behavior of the effect
  let effects: [EffectValue]

  /// Retrieves the `EffectValue` for the given name
  func value<ValueType: EffectValue>(named name: String) -> ValueType? {
    effects.first(where: {
      $0.name == name && $0 is ValueType
    }) as? ValueType
  }

  // MARK: Fileprivate

  fileprivate enum CodingKeys: String {
    case name = "nm"
    case type = "ty"
    case effects = "ef"
  }
}

extension [LayerEffect] {
  static func fromDictionaries(_ dictionaries: [[String: Any]]) throws -> [LayerEffect] {
    try dictionaries.compactMap { dictionary in
      let shapeType = dictionary[LayerEffect.CodingKeys.type.rawValue] as? Int
      switch LayerEffectType(rawValue: shapeType ?? LayerEffectType.unknown.rawValue) {
      case .dropShadow:
        return try DropShadowEffect(dictionary: dictionary)
      case .unknown, nil:
        // Unsupported
        return try LayerEffect(dictionary: dictionary)
      }
    }
  }
}

// MARK: - LayerEffect + Sendable

/// Since `LayerEffect` isn't `final`, we have to use `@unchecked Sendable` instead of `Sendable.`
/// All `LayerEffect` subclasses are immutable `Sendable` values.
// swiftlint:disable:next no_unchecked_sendable
extension LayerEffect: @unchecked Sendable { }
