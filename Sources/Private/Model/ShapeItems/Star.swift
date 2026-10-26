//
//  Star.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

// MARK: - StarType

enum StarType: Int, Sendable {
  case none
  case star
  case polygon
}

// MARK: - Star

final class Star: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    if
      let directionRawValue = dictionary[CodingKeys.direction.rawValue] as? Int,
      let direction = PathDirection(rawValue: directionRawValue)
    {
      self.direction = direction
    } else {
      direction = .clockwise
    }
    let positionDictionary: [String: Any] = try dictionary.value(for: CodingKeys.position)
    position = try KeyframeGroup<LottieVector3D>(dictionary: positionDictionary)
    let outerRadiusDictionary: [String: Any] = try dictionary.value(for: CodingKeys.outerRadius)
    outerRadius = try KeyframeGroup<LottieVector1D>(dictionary: outerRadiusDictionary)
    let outerRoundnessDictionary: [String: Any] = try dictionary.value(for: CodingKeys.outerRoundness)
    outerRoundness = try KeyframeGroup<LottieVector1D>(dictionary: outerRoundnessDictionary)
    if let innerRadiusDictionary = dictionary[CodingKeys.innerRadius.rawValue] as? [String: Any] {
      innerRadius = try KeyframeGroup<LottieVector1D>(dictionary: innerRadiusDictionary)
    } else {
      innerRadius = nil
    }
    if let innerRoundnessDictionary = dictionary[CodingKeys.innerRoundness.rawValue] as? [String: Any] {
      innerRoundness = try KeyframeGroup<LottieVector1D>(dictionary: innerRoundnessDictionary)
    } else {
      innerRoundness = nil
    }
    let rotationDictionary: [String: Any] = try dictionary.value(for: CodingKeys.rotation)
    rotation = try KeyframeGroup<LottieVector1D>(dictionary: rotationDictionary)
    let pointsDictionary: [String: Any] = try dictionary.value(for: CodingKeys.points)
    points = try KeyframeGroup<LottieVector1D>(dictionary: pointsDictionary)
    let starTypeRawValue: Int = try dictionary.value(for: CodingKeys.starType)
    guard let starType = StarType(rawValue: starTypeRawValue) else {
      throw InitializableError.invalidInput()
    }
    self.starType = starType
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The direction of the star.
  let direction: PathDirection

  /// The position of the star
  let position: KeyframeGroup<LottieVector3D>

  /// The outer radius of the star
  let outerRadius: KeyframeGroup<LottieVector1D>

  /// The outer roundness of the star
  let outerRoundness: KeyframeGroup<LottieVector1D>

  /// The outer radius of the star
  let innerRadius: KeyframeGroup<LottieVector1D>?

  /// The outer roundness of the star
  let innerRoundness: KeyframeGroup<LottieVector1D>?

  /// The rotation of the star
  let rotation: KeyframeGroup<LottieVector1D>

  /// The number of points on the star
  let points: KeyframeGroup<LottieVector1D>

  /// The type of star
  let starType: StarType


  // MARK: Private

  private enum CodingKeys: String {
    case direction = "d"
    case position = "p"
    case outerRadius = "or"
    case outerRoundness = "os"
    case innerRadius = "ir"
    case innerRoundness = "is"
    case rotation = "r"
    case points = "pt"
    case starType = "sy"
  }
}
