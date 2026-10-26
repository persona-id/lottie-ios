//
//  TransformItem.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

final class ShapeTransform: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    if
      let anchorDictionary = dictionary[CodingKeys.anchor.rawValue] as? [String: Any],
      let anchor = try? KeyframeGroup<LottieVector3D>(dictionary: anchorDictionary)
    {
      self.anchor = anchor
    } else {
      anchor = KeyframeGroup(LottieVector3D(x: Double(0), y: 0, z: 0))
    }
    if
      let positionDictionary = dictionary[CodingKeys.position.rawValue] as? [String: Any],
      let position = try? KeyframeGroup<LottieVector3D>(dictionary: positionDictionary)
    {
      self.position = position
    } else {
      position = KeyframeGroup(LottieVector3D(x: Double(0), y: 0, z: 0))
    }
    if
      let scaleDictionary = dictionary[CodingKeys.scale.rawValue] as? [String: Any],
      let scale = try? KeyframeGroup<LottieVector3D>(dictionary: scaleDictionary)
    {
      self.scale = scale
    } else {
      scale = KeyframeGroup(LottieVector3D(x: Double(100), y: 100, z: 100))
    }

    if
      let rotationDictionary = dictionary[CodingKeys.rotationX.rawValue] as? [String: Any],
      let rotation = try? KeyframeGroup<LottieVector1D>(dictionary: rotationDictionary)
    {
      rotationX = rotation
    } else {
      rotationX = KeyframeGroup(LottieVector1D(0))
    }

    if
      let rotationDictionary = dictionary[CodingKeys.rotationY.rawValue] as? [String: Any],
      let rotation = try? KeyframeGroup<LottieVector1D>(dictionary: rotationDictionary)
    {
      rotationY = rotation
    } else {
      rotationY = KeyframeGroup(LottieVector1D(0))
    }

    if
      let rotationDictionary = dictionary[CodingKeys.rotation.rawValue] as? [String: Any],
      let rotation = try? KeyframeGroup<LottieVector1D>(dictionary: rotationDictionary)
    {
      rotationZ = rotation
    } else if
      let rotationDictionary = dictionary[CodingKeys.rotationZ.rawValue] as? [String: Any],
      let rotation = try? KeyframeGroup<LottieVector1D>(dictionary: rotationDictionary)
    {
      rotationZ = rotation
    } else {
      rotationZ = KeyframeGroup(LottieVector1D(0))
    }

    if
      let opacityDictionary = dictionary[CodingKeys.opacity.rawValue] as? [String: Any],
      let opacity = try? KeyframeGroup<LottieVector1D>(dictionary: opacityDictionary)
    {
      self.opacity = opacity
    } else {
      opacity = KeyframeGroup(LottieVector1D(100))
    }
    if
      let skewDictionary = dictionary[CodingKeys.skew.rawValue] as? [String: Any],
      let skew = try? KeyframeGroup<LottieVector1D>(dictionary: skewDictionary)
    {
      self.skew = skew
    } else {
      skew = KeyframeGroup(LottieVector1D(0))
    }
    if
      let skewAxisDictionary = dictionary[CodingKeys.skewAxis.rawValue] as? [String: Any],
      let skewAxis = try? KeyframeGroup<LottieVector1D>(dictionary: skewAxisDictionary)
    {
      self.skewAxis = skewAxis
    } else {
      skewAxis = KeyframeGroup(LottieVector1D(0))
    }

    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// Anchor Point
  let anchor: KeyframeGroup<LottieVector3D>

  /// Position
  let position: KeyframeGroup<LottieVector3D>

  /// Scale
  let scale: KeyframeGroup<LottieVector3D>

  /// Rotation on X axis
  let rotationX: KeyframeGroup<LottieVector1D>

  /// Rotation on Y axis
  let rotationY: KeyframeGroup<LottieVector1D>

  /// Rotation on Z axis
  let rotationZ: KeyframeGroup<LottieVector1D>

  /// opacity
  let opacity: KeyframeGroup<LottieVector1D>

  /// Skew
  let skew: KeyframeGroup<LottieVector1D>

  /// Skew Axis
  let skewAxis: KeyframeGroup<LottieVector1D>


  // MARK: Private

  private enum CodingKeys: String {
    case anchor = "a"
    case position = "p"
    case scale = "s"
    case rotation = "r"
    case rotationX = "rx"
    case rotationY = "ry"
    case rotationZ = "rz"
    case opacity = "o"
    case skew = "sk"
    case skewAxis = "sa"
  }
}
