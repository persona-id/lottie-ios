//
//  KeyframeGroup.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/14/19.
//

// MARK: - KeyframeGroup

/// Used for coding/decoding a group of Keyframes by type.
///
/// Keyframe data is wrapped in a dictionary { "k" : KeyframeData }.
/// The keyframe data can either be an array of keyframes or, if no animation is present, the raw value.
/// This helper object is needed to properly decode the json.
final class KeyframeGroup<T> {

  // MARK: Lifecycle

  init(
    keyframes: ContiguousArray<Keyframe<T>>,
    unsupportedAfterEffectsExpression: String? = nil)
  {
    self.keyframes = keyframes
    self.unsupportedAfterEffectsExpression = unsupportedAfterEffectsExpression
  }

  init(
    _ value: T,
    unsupportedAfterEffectsExpression: String? = nil)
  {
    keyframes = [Keyframe(value)]
    self.unsupportedAfterEffectsExpression = unsupportedAfterEffectsExpression
  }

  // MARK: Internal

  enum KeyframeWrapperKey: String {
    case keyframeData = "k"
    case unsupportedAfterEffectsExpression = "x"
  }

  let keyframes: ContiguousArray<Keyframe<T>>

  /// lottie-ios doesn't support After Effects expressions, but we parse them so we can log diagnostics.
  /// More info: https://helpx.adobe.com/after-effects/using/expression-basics.html
  let unsupportedAfterEffectsExpression: String?

}

// MARK: DictionaryInitializable

extension KeyframeGroup: DictionaryInitializable where T: AnyInitializable {
  convenience init(dictionary: [String: Any]) throws {
    var keyframes = ContiguousArray<Keyframe<T>>()
    let unsupportedAfterEffectsExpression = dictionary[KeyframeWrapperKey.unsupportedAfterEffectsExpression.rawValue] as? String
    if
      let rawValue = dictionary[KeyframeWrapperKey.keyframeData.rawValue],
      let value = try? T(value: rawValue)
    {
      keyframes = [Keyframe<T>(value)]
    } else {
      let frameDictionaries: [[String: Any]] =
        if
          let singleFrameDictionary =
          dictionary[KeyframeWrapperKey.keyframeData.rawValue] as? [String: Any]
        {
          [singleFrameDictionary]
        } else {
          try dictionary.value(for: KeyframeWrapperKey.keyframeData)
        }
      var previousKeyframeData: KeyframeData<T>?
      for frameDictionary in frameDictionaries {
        let data = try KeyframeData<T>(dictionary: frameDictionary)
        guard
          let value: T = data.startValue ?? previousKeyframeData?.endValue,
          let time = data.time
        else {
          throw InitializableError.invalidInput()
        }
        keyframes.append(Keyframe<T>(
          value: value,
          time: time,
          isHold: data.isHold,
          inTangent: previousKeyframeData?.inTangent,
          outTangent: data.outTangent,
          spatialInTangent: previousKeyframeData?.spatialInTangent,
          spatialOutTangent: data.spatialOutTangent))
        previousKeyframeData = data
      }
    }

    self.init(
      keyframes: keyframes,
      unsupportedAfterEffectsExpression: unsupportedAfterEffectsExpression)
  }
}

// MARK: Equatable

extension KeyframeGroup: Equatable where T: Equatable {
  static func == (_ lhs: KeyframeGroup<T>, _ rhs: KeyframeGroup<T>) -> Bool {
    lhs.keyframes == rhs.keyframes
  }
}

// MARK: Hashable

extension KeyframeGroup: Hashable where T: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(keyframes)
  }
}

// MARK: Sendable

extension KeyframeGroup: Sendable where T: Sendable { }

extension Keyframe {
  /// Creates a copy of this `Keyframe` with the same timing data, but a different value
  func withValue<Value>(_ newValue: Value) -> Keyframe<Value> {
    Keyframe<Value>(
      value: newValue,
      time: time,
      isHold: isHold,
      inTangent: inTangent,
      outTangent: outTangent,
      spatialInTangent: spatialInTangent,
      spatialOutTangent: spatialOutTangent)
  }
}

extension KeyframeGroup {
  /// Maps the values of each individual keyframe in this group
  func map<NewValue>(_ transformation: (T) throws -> NewValue) rethrows -> KeyframeGroup<NewValue> {
    KeyframeGroup<NewValue>(
      keyframes: ContiguousArray(try keyframes.map { keyframe in
        keyframe.withValue(try transformation(keyframe.value))
      }),
      unsupportedAfterEffectsExpression: unsupportedAfterEffectsExpression)
  }
}

// MARK: - AnyKeyframeGroup

/// A type-erased wrapper for `KeyframeGroup`s
protocol AnyKeyframeGroup {
  /// An untyped copy of these keyframes
  var untyped: KeyframeGroup<Any> { get }

  /// An untyped `KeyframeInterpolator` for these keyframes
  var interpolator: AnyValueProvider { get }
}

// MARK: - KeyframeGroup + AnyKeyframeGroup

extension KeyframeGroup: AnyKeyframeGroup where T: AnyInterpolatable {
  var untyped: KeyframeGroup<Any> {
    map { $0 as Any }
  }

  var interpolator: AnyValueProvider {
    KeyframeInterpolator(keyframes: keyframes)
  }
}
