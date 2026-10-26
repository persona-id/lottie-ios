//
//  Vector.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/7/19.
//

import CoreGraphics
import Foundation
import QuartzCore

// MARK: - LottieVector1D

extension LottieVector1D {

  // MARK: Internal

  var cgFloatValue: CGFloat {
    CGFloat(value)
  }

}

// MARK: - LottieVector1D + AnyInitializable

extension LottieVector1D: AnyInitializable {

  init(value: Any) throws {
    if
      let array = value as? [Double],
      let double = array.first
    {
      self.value = double
    } else if let double = value as? Double {
      self.value = double
    } else {
      throw InitializableError.invalidInput()
    }
  }

}

extension Double {
  var vectorValue: LottieVector1D {
    LottieVector1D(self)
  }
}

// MARK: - LottieVector2D

/// Needed for decoding json {x: y:} to a CGPoint
public struct LottieVector2D: Hashable, Sendable {

  // MARK: Lifecycle

  init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }

  // MARK: Internal

  var x: Double
  var y: Double

  var pointValue: CGPoint {
    CGPoint(x: x, y: y)
  }

  // MARK: Private

  private enum CodingKeys: String {
    case x
    case y
  }
}

// MARK: AnyInitializable

extension LottieVector2D: AnyInitializable {

  init(value: Any) throws {
    guard let dictionary = value as? [String: Any] else {
      throw InitializableError.invalidInput()
    }

    if
      let array = dictionary[CodingKeys.x.rawValue] as? [Double],
      let double = array.first
    {
      x = double
    } else if let double = dictionary[CodingKeys.x.rawValue] as? Double {
      x = double
    } else {
      throw InitializableError.invalidInput()
    }
    if
      let array = dictionary[CodingKeys.y.rawValue] as? [Double],
      let double = array.first
    {
      y = double
    } else if let double = dictionary[CodingKeys.y.rawValue] as? Double {
      y = double
    } else {
      throw InitializableError.invalidInput()
    }
  }
}

extension CGPoint {
  var vector2dValue: LottieVector2D {
    LottieVector2D(x: Double(x), y: Double(y))
  }
}

// MARK: - LottieVector3D

/// A three dimensional vector.
/// These vectors are decoded from [Double]

extension LottieVector3D {

  // MARK: Lifecycle

  init(x: CGFloat, y: CGFloat, z: CGFloat) {
    self.x = Double(x)
    self.y = Double(y)
    self.z = Double(z)
  }

}

// MARK: - LottieVector3D + AnyInitializable

extension LottieVector3D: AnyInitializable {

  init(value: Any) throws {
    guard var array = value as? [Double] else {
      throw InitializableError.invalidInput()
    }
    x = array.count > 0 ? array.removeFirst() : 0
    y = array.count > 0 ? array.removeFirst() : 0
    z = array.count > 0 ? array.removeFirst() : 0
  }

}

extension LottieVector3D {
  public var pointValue: CGPoint {
    CGPoint(x: x, y: y)
  }

  public var sizeValue: CGSize {
    CGSize(width: x, height: y)
  }
}

extension CGPoint {
  var vector3dValue: LottieVector3D {
    LottieVector3D(x: x, y: y, z: 0)
  }
}

extension CGSize {
  var vector3dValue: LottieVector3D {
    LottieVector3D(x: width, y: height, z: 1)
  }
}

extension CATransform3D {

  enum Axis {
    case x, y, z
  }

  static func makeSkew(skew: CGFloat, skewAxis: CGFloat) -> CATransform3D {
    let mCos = cos(skewAxis.toRadians())
    let mSin = sin(skewAxis.toRadians())
    let aTan = tan(skew.toRadians())

    let transform1 = CATransform3D(
      m11: mCos,
      m12: mSin,
      m13: 0,
      m14: 0,
      m21: -mSin,
      m22: mCos,
      m23: 0,
      m24: 0,
      m31: 0,
      m32: 0,
      m33: 1,
      m34: 0,
      m41: 0,
      m42: 0,
      m43: 0,
      m44: 1)

    let transform2 = CATransform3D(
      m11: 1,
      m12: 0,
      m13: 0,
      m14: 0,
      m21: aTan,
      m22: 1,
      m23: 0,
      m24: 0,
      m31: 0,
      m32: 0,
      m33: 1,
      m34: 0,
      m41: 0,
      m42: 0,
      m43: 0,
      m44: 1)

    let transform3 = CATransform3D(
      m11: mCos,
      m12: -mSin,
      m13: 0,
      m14: 0,
      m21: mSin,
      m22: mCos,
      m23: 0,
      m24: 0,
      m31: 0,
      m32: 0,
      m33: 1,
      m34: 0,
      m41: 0,
      m42: 0,
      m43: 0,
      m44: 1)
    return CATransform3DConcat(transform3, CATransform3DConcat(transform2, transform1))
  }

  static func makeTransform(
    anchor: CGPoint,
    position: CGPoint,
    scale: CGSize,
    rotationX: CGFloat,
    rotationY: CGFloat,
    rotationZ: CGFloat,
    skew: CGFloat?,
    skewAxis: CGFloat?)
    -> CATransform3D
  {
    if let skew, let skewAxis {
      return CATransform3DMakeTranslation(position.x, position.y, 0)
        .rotated(rotationX, axis: .x)
        .rotated(rotationY, axis: .y)
        .rotated(rotationZ, axis: .z)
        .skewed(skew: -skew, skewAxis: skewAxis)
        .scaled(scale * 0.01)
        .translated(anchor * -1)
    }
    return CATransform3DMakeTranslation(position.x, position.y, 0)
      .rotated(rotationX, axis: .x)
      .rotated(rotationY, axis: .y)
      .rotated(rotationZ, axis: .z)
      .scaled(scale * 0.01)
      .translated(anchor * -1)
  }

  func rotated(_ degrees: CGFloat, axis: Axis) -> CATransform3D {
    CATransform3DRotate(
      self,
      degrees.toRadians(),
      axis == .x ? 1 : 0,
      axis == .y ? 1 : 0,
      axis == .z ? 1 : 0)
  }

  func translated(_ translation: CGPoint) -> CATransform3D {
    CATransform3DTranslate(self, translation.x, translation.y, 0)
  }

  func scaled(_ scale: CGSize) -> CATransform3D {
    CATransform3DScale(self, scale.width, scale.height, 1)
  }

  func skewed(skew: CGFloat, skewAxis: CGFloat) -> CATransform3D {
    CATransform3DConcat(CATransform3D.makeSkew(skew: skew, skewAxis: skewAxis), self)
  }

}
