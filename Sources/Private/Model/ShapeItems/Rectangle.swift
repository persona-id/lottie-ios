//
//  Rectangle.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

final class Rectangle: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    if
      let directionRawType = dictionary[CodingKeys.direction.rawValue] as? Int,
      let direction = PathDirection(rawValue: directionRawType)
    {
      self.direction = direction
    } else {
      direction = .clockwise
    }
    let positionDictionary: [String: Any] = try dictionary.value(for: CodingKeys.position)
    position = try KeyframeGroup<LottieVector3D>(dictionary: positionDictionary)
    let sizeDictionary: [String: Any] = try dictionary.value(for: CodingKeys.size)
    size = try KeyframeGroup<LottieVector3D>(dictionary: sizeDictionary)
    let cornerRadiusDictionary: [String: Any] = try dictionary.value(for: CodingKeys.cornerRadius)
    cornerRadius = try KeyframeGroup<LottieVector1D>(dictionary: cornerRadiusDictionary)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The direction of the rect.
  let direction: PathDirection

  /// The position
  let position: KeyframeGroup<LottieVector3D>

  /// The size
  let size: KeyframeGroup<LottieVector3D>

  /// The Corner radius of the rectangle
  let cornerRadius: KeyframeGroup<LottieVector1D>


  // MARK: Private

  private enum CodingKeys: String {
    case direction = "d"
    case position = "p"
    case size = "s"
    case cornerRadius = "r"
  }
}
