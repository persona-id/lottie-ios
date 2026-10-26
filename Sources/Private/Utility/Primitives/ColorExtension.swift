//
//  LottieColor.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/14/19.
//

import CoreGraphics

// MARK: - LottieColor + AnyInitializable

extension LottieColor: AnyInitializable {

  init(value: Any) throws {
    guard var array = value as? [Double] else {
      throw InitializableError.invalidInput()
    }
    var r: Double = array.count > 0 ? array.removeFirst() : 0
    var g: Double = array.count > 0 ? array.removeFirst() : 0
    var b: Double = array.count > 0 ? array.removeFirst() : 0
    if r > 1, g > 1, b > 1 {
      r /= 255
      g /= 255
      b /= 255
    }
    self.r = r
    self.g = g
    self.b = b

    // The Lottie JSON schema supports alpha values in theory, as the fourth value in this array.
    // We intentionally do not support this, though, for consistency with Lottie on other platforms.
    a = 1
  }

}

extension LottieColor {
  static var clearColor: CGColor {
    .rgba(0, 0, 0, 0)
  }

  var cgColorValue: CGColor {
    .rgba(CGFloat(r), CGFloat(g), CGFloat(b), CGFloat(a))
  }
}
