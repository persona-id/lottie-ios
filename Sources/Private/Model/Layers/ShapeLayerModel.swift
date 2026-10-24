//
//  ShapeLayer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

/// A layer that holds vector shape objects.
final class ShapeLayerModel: LayerModel {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let itemDictionaries: [[String: Any]] = try dictionary.value(for: CodingKeys.items)
    items = try [ShapeItem].fromDictionaries(itemDictionaries)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// A list of shape items.
  let items: [ShapeItem]


  // MARK: Private

  private enum CodingKeys: String {
    case items = "shapes"
  }
}
