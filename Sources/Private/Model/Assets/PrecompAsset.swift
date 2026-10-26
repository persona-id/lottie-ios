//
//  PrecompAsset.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/9/19.
//

final class PrecompAsset: Asset {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let layerDictionaries: [[String: Any]] = try dictionary.value(for: CodingKeys.layers)
    layers = try [LayerModel].fromDictionaries(layerDictionaries)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  enum CodingKeys: String {
    case layers
  }

  /// Layers of the precomp
  let layers: [LayerModel]

}
