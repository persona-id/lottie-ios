//
//  AssetLibrary.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/9/19.
//

final class AssetLibrary: AnyInitializable, Sendable {

  // MARK: Lifecycle

  init(value: Any) throws {
    guard let dictionaries = value as? [[String: Any]] else {
      throw InitializableError.invalidInput()
    }
    var decodedAssets = [String : Asset]()
    var imageAssets = [String : ImageAsset]()
    var precompAssets = [String : PrecompAsset]()
    for dictionary in dictionaries {
      if dictionary[PrecompAsset.CodingKeys.layers.rawValue] != nil {
        let asset = try PrecompAsset(dictionary: dictionary)
        decodedAssets[asset.id] = asset
        precompAssets[asset.id] = asset
      } else if let asset = try? ImageAsset(dictionary: dictionary) {
        decodedAssets[asset.id] = asset
        imageAssets[asset.id] = asset
      }
    }
    assets = decodedAssets
    self.precompAssets = precompAssets
    self.imageAssets = imageAssets
  }

  // MARK: Internal

  /// The Assets
  let assets: [String: Asset]

  let imageAssets: [String: ImageAsset]
  let precompAssets: [String: PrecompAsset]
}
