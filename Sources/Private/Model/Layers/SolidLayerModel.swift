//
//  SolidLayer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

/// A layer that holds a solid color.
final class SolidLayerModel: LayerModel {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    colorHex = try dictionary.value(for: CodingKeys.colorHex)
    width = try dictionary.value(for: CodingKeys.width)
    height = try dictionary.value(for: CodingKeys.height)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The color of the solid in Hex // Change to value provider.
  let colorHex: String

  /// The Width of the color layer
  let width: Double

  /// The height of the color layer
  let height: Double


  // MARK: Private

  private enum CodingKeys: String {
    case colorHex = "sc"
    case width = "sw"
    case height = "sh"
  }
}
