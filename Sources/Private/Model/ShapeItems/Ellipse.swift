//
//  EllipseItem.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

// MARK: - PathDirection

enum PathDirection: Int {
  case clockwise = 1
  case userSetClockwise = 2
  case counterClockwise = 3
}

// MARK: - Ellipse

final class Ellipse: ShapeItem {

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
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The direction of the ellipse.
  let direction: PathDirection

  /// The position of the ellipse
  let position: KeyframeGroup<LottieVector3D>

  /// The size of the ellipse
  let size: KeyframeGroup<LottieVector3D>


  // MARK: Private

  private enum CodingKeys: String {
    case direction = "d"
    case position = "p"
    case size = "s"
  }
}
