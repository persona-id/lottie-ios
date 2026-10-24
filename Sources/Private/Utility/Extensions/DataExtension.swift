//
//  DataExtension.swift
//  Lottie
//
//  Created by René Fouquet on 03.05.21.
//

import UIKit

// MARK: - LottieAssetError

enum LottieAssetError: Error {
  /// Asset with this name was not found in the provided bundle.
  case assetNotFound(name: String, bundle: Bundle?)
}

extension Data {

  init(assetName: String, in bundle: Bundle) throws {
    if let asset = NSDataAsset(name: assetName, bundle: bundle) {
      self = asset.data
    } else {
      throw LottieAssetError.assetNotFound(name: assetName, bundle: bundle)
    }
  }
}
