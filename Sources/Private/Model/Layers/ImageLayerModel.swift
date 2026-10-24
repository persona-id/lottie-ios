//
//  ImageLayer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

/// A layer that holds an image.
final class ImageLayerModel: LayerModel {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    referenceID = try dictionary.value(for: CodingKeys.referenceID)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The reference ID of the image.
  let referenceID: String


  // MARK: Private

  private enum CodingKeys: String {
    case referenceID = "refId"
  }
}
