// Created by Cal Stephens on 1/11/22.
// Copyright © 2022 Airbnb Inc. All rights reserved.

// MARK: - PropertyName

/// The name of a customizable property that can be used in an `AnimationKeypath`
///  - These values form the public API of the `AnimationKeypath` system.
enum PropertyName: String, CaseIterable {
  case color = "Color"
  case opacity = "Opacity"
  case scale = "Scale"
  case position = "Position"
  case rotation = "Rotation"
  case strokeWidth = "Stroke Width"
  case gradientColors = "Colors"
}
