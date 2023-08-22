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
      // `DropShadowStyle.size` is approximately double as large
      // as the visually-equivalent `cornerRadius` value
      LottieVector1D(sizeValue.cgFloatValue / 2)
    }
  }
}

// MARK: - DropShadowEffect + DropShadowModel

extension DropShadowEffect: DropShadowModel {
  var _color: KeyframeGroup<LottieColor>? { color?.value }

  var _distance: KeyframeGroup<LottieVector1D>? {
    distance?.value?.map { distanceValue in
      // `DropShadowEffect.distance` doesn't seem to map cleanly to
      // `CALayer.shadowOffset` (e.g. with a simple multiplier).
      // Instead, this uses a custom quadratic regression eyeballed
      // to match the expected appearance of the start / end of the
      // `issue_1169_shadow_effect_animated.json` sample animation:
      //  - `distance=5` roughly corresponds to an offset value of 4
      //  - `distance=10` roughly corresponds to an offset value of 5
      // This could probably be improved with more examples.
      let x = distanceValue.cgFloatValue
      let cornerRadiusMapping = (-0.06 * pow(x, 2)) + (1.1 * x)

      return LottieVector1D(cornerRadiusMapping)
    }
  }

  var _radius: KeyframeGroup<LottieVector1D>? {
    softness?.value?.map { softnessValue in
      // `DropShadowEffect.softness` doesn't seem to map cleanly to
      // `CALayer.cornerRadius` (e.g. with a simple multiplier).
      // Instead, this uses a custom quadratic regression eyeballed
      // to match the expected appearance of the start / end of the
      // `issue_1169_shadow_effect_animated.json` sample animation:
      //  - `softness=10` roughly corresponds to `cornerRadius=2.5`
      //  - `softness=50` roughly corresponds to `cornerRadius=6.25`
      // This could probably be improved with more examples.
      let x = softnessValue.cgFloatValue
      let cornerRadiusMapping = (-0.003 * pow(x, 2)) + (0.281 * x)

      return LottieVector1D(cornerRadiusMapping)
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

// MARK: - CALayer + DropShadowModel

extension CALayer {

  // MARK: Internal

  /// Adds drop shadow animations from the given `DropShadowModel` to this layer
  @nonobjc
  func addDropShadowAnimations(
    for dropShadowModel: DropShadowModel,
    context: LayerAnimationContext)
    throws
  {
    try addShadowOpacityAnimation(from: dropShadowModel, context: context)
    try addShadowColorAnimation(from: dropShadowModel, context: context)
    try addShadowRadiusAnimation(from: dropShadowModel, context: context)
    try addShadowOffsetAnimation(from: dropShadowModel, context: context)
  }

  // MARK: Private

  private func addShadowOpacityAnimation(from model: DropShadowModel, context: LayerAnimationContext) throws {
    guard let opacityKeyframes = model._opacity else { return }

    try addAnimation(
      for: .shadowOpacity,
      keyframes: opacityKeyframes,
      value: {
        // Lottie animation files express opacity as a numerical percentage value
        // (e.g. 0%, 50%, 100%) so we divide by 100 to get the decimal values
        // expected by Core Animation (e.g. 0.0, 0.5, 1.0).
        $0.cgFloatValue / 100
      },
      context: context)
  }

  private func addShadowColorAnimation(from model: DropShadowModel, context: LayerAnimationContext) throws {
    guard let shadowColorKeyframes = model._color else { return }

    try addAnimation(
      for: .shadowColor,
      keyframes: shadowColorKeyframes,
      value: \.cgColorValue,
      context: context)
  }

  private func addShadowRadiusAnimation(from model: DropShadowModel, context: LayerAnimationContext) throws {
    guard let shadowSizeKeyframes = model._radius else { return }

    try addAnimation(
      for: .shadowRadius,
      keyframes: shadowSizeKeyframes,
      value: \.cgFloatValue,
      context: context)
  }

  private func addShadowOffsetAnimation(from model: DropShadowModel, context: LayerAnimationContext) throws {
    guard
      let angleKeyframes = model._angle,
      let distanceKeyframes = model._distance
    else { return }

    let offsetKeyframes = Keyframes.combined(angleKeyframes, distanceKeyframes) { angleDegrees, distance -> CGSize in
      // Lottie animation files express rotation in degrees
      // (e.g. 90º, 180º, 360º) so we convert to radians to get the
      // values expected by Core Animation (e.g. π/2, π, 2π)
      let angleRadians = (angleDegrees.cgFloatValue * .pi) / 180

      // Lottie animation files express the `shadowOffset` as (angle, distance) pair,
      // which we convert to the expected x / y offset values:
      let offsetX = distance.cgFloatValue * cos(angleRadians)
      let offsetY = distance.cgFloatValue * sin(angleRadians)
      return CGSize(width: offsetX, height: offsetY)
    }

    try addAnimation(
      for: .shadowOffset,
      keyframes: offsetKeyframes,
      value: { $0 },
      context: context)
  }

}
