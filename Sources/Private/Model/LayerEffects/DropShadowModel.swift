// Created by Cal Stephens on 8/15/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

import QuartzCore

// MARK: - DropShadowModel

protocol DropShadowModel {
  /// The opacity of the drop shadow, from 0 to 100.
  var _opacity: KeyframeGroup<LottieVector1D>? { get }

  /// The shadow radius of the blur
  var _radius: KeyframeGroup<LottieVector1D>? { get }

  /// The color of the drop shadow
  var _color: KeyframeGroup<LottieColor>? { get }

  /// The angle of the drop shadow, in degrees,
  /// with "90" resulting in a shadow directly beneath the layer.
  /// Combines with the `distance` to form the `shadowOffset`.
  var _angle: KeyframeGroup<LottieVector1D>? { get }

  /// The distance of the drop shadow offset.
  /// Combines with the `angle` to form the `shadowOffset`.
  var _distance: KeyframeGroup<LottieVector1D>? { get }
}

// MARK: - DropShadowStyle + DropShadowModel

extension DropShadowStyle: DropShadowModel {
  var _opacity: KeyframeGroup<LottieVector1D>? { opacity }
  var _color: KeyframeGroup<LottieColor>? { color }
  var _angle: KeyframeGroup<LottieVector1D>? { angle }
  var _distance: KeyframeGroup<LottieVector1D>? { distance }

  var _radius: KeyframeGroup<LottieVector1D>? {
    size.map { sizeValue in
      // After Effects shadow softness uses a different range of values than CALayer.shadowRadius,
      // so shadows render too softly if we directly use the value from After Effects. We find that
      // dividing this value from After Effects by 2 produces results that are visually similar.
      LottieVector1D(sizeValue.cgFloatValue / 2)
    }
  }
}

// MARK: - DropShadowEffect + DropShadowModel

extension DropShadowEffect: DropShadowModel {
  var _color: KeyframeGroup<LottieColor>? { color?.value }
  var _distance: KeyframeGroup<LottieVector1D>? { distance?.value }

  var _radius: KeyframeGroup<LottieVector1D>? {
    softness?.value?.map { softnessValue in
      // After Effects shadow softness uses a different range of values than CALayer.shadowRadius,
      // so shadows render too softly if we directly use the value from After Effects. We find that
      // dividing this value from After Effects by 5 produces results that are visually similar.
      LottieVector1D(softnessValue.cgFloatValue / 5)
    }
  }

  var _opacity: KeyframeGroup<LottieVector1D>? {
    opacity?.value?.map { originalOpacityValue in
      // `DropShadowEffect.opacity` is a value between 0 and 255,
      // but `DropShadowModel._opacity` expects a value between 0 and 100.
      LottieVector1D((originalOpacityValue.value / 255.0) * 100)
    }
  }

  var _angle: KeyframeGroup<LottieVector1D>? {
    direction?.value?.map { originalAngleValue in
      // `DropShadowEffect.distance` is rotated 90º from the
      // angle value representation expected by `DropShadowModel._angle`
      LottieVector1D(originalAngleValue.value - 90)
    }
  }
}
