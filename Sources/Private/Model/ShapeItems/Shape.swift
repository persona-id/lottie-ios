//
//  VectorShape.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

/// An item that defines an custom shape
final class Shape: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let pathDictionary: [String: Any] = try dictionary.value(for: CodingKeys.path)
    path = try KeyframeGroup<BezierPath>(dictionary: pathDictionary)
    if
      let directionRawValue = dictionary[CodingKeys.direction.rawValue] as? Int,
      let direction = PathDirection(rawValue: directionRawValue)
    {
      self.direction = direction
    } else {
      direction = nil
    }
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The Path
  let path: KeyframeGroup<BezierPath>

  let direction: PathDirection?


  // MARK: Private

  private enum CodingKeys: String {
    case path = "ks"
    case direction = "d"
  }
}
