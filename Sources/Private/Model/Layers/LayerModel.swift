//
//  Layer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/7/19.
//

// MARK: - LayerType

public enum LayerType: Int {
  case precomp
  case solid
  case image
  case null
  case shape
  case text
  case unknown
}

// MARK: - MatteType

public enum MatteType: Int {
  case none
  case add
  case invert
  case unknown
}

// MARK: - BlendMode

public enum BlendMode: Int {
  case normal
  case multiply
  case screen
  case overlay
  case darken
  case lighten
  case colorDodge
  case colorBurn
  case hardLight
  case softLight
  case difference
  case exclusion
  case hue
  case saturation
  case color
  case luminosity
}

// MARK: - LayerModel

/// A base top container for shapes, images, and other view objects.
class LayerModel: DictionaryInitializable {

  // MARK: Lifecycle

  required init(dictionary: [String: Any]) throws {
    name = (try? dictionary.value(for: CodingKeys.name)) ?? "Layer"
    index = try dictionary.value(for: CodingKeys.index) ?? .random(in: Int.min...Int.max)
    type = LayerType(rawValue: try dictionary.value(for: CodingKeys.type)) ?? .null
    if
      let coordinateSpaceRawValue = dictionary[CodingKeys.coordinateSpace.rawValue] as? Int,
      let coordinateSpace = CoordinateSpace(rawValue: coordinateSpaceRawValue)
    {
      self.coordinateSpace = coordinateSpace
    } else {
      coordinateSpace = .type2d
    }
    inFrame = try dictionary.value(for: CodingKeys.inFrame)
    outFrame = try dictionary.value(for: CodingKeys.outFrame)
    startTime = try dictionary.value(for: CodingKeys.startTime)
    parent = try? dictionary.value(for: CodingKeys.parent)
    if
      let transformDictionary: [String: Any] = try dictionary.value(for: CodingKeys.transform),
      let transform = try? Transform(dictionary: transformDictionary)
    {
      self.transform = transform
    } else {
      transform = .default
    }
    if
      let blendModeRawValue = dictionary[CodingKeys.blendMode.rawValue] as? Int,
      let blendMode = BlendMode(rawValue: blendModeRawValue)
    {
      self.blendMode = blendMode
    } else {
      blendMode = .normal
    }
    if let maskDictionaries = dictionary[CodingKeys.masks.rawValue] as? [[String: Any]] {
      masks = try maskDictionaries.map { try Mask(dictionary: $0) }
    } else {
      masks = nil
    }
    timeStretch = (try? dictionary.value(for: CodingKeys.timeStretch)) ?? 1
    if let matteRawValue = dictionary[CodingKeys.matte.rawValue] as? Int {
      matte = MatteType(rawValue: matteRawValue)
    } else {
      matte = nil
    }
    hidden = (try? dictionary.value(for: CodingKeys.hidden)) ?? false
    if let styleDictionaries = dictionary[CodingKeys.styles.rawValue] as? [[String: Any]] {
      styles = try [LayerStyle].fromDictionaries(styleDictionaries)
    } else {
      styles = []
    }
    if let effectDictionaries = dictionary[CodingKeys.effects.rawValue] as? [[String: Any]] {
      effects = try [LayerEffect].fromDictionaries(effectDictionaries)
    } else {
      effects = []
    }
  }

  // MARK: Internal

  /// The readable name of the layer
  let name: String

  /// The index of the layer
  let index: Int

  /// The type of the layer.
  let type: LayerType

  /// The coordinate space
  let coordinateSpace: CoordinateSpace

  /// The in time of the layer in frames.
  let inFrame: Double
  /// The out time of the layer in frames.
  let outFrame: Double

  /// The start time of the layer in frames.
  let startTime: Double

  /// The transform of the layer
  let transform: Transform

  /// The index of the parent layer, if applicable.
  let parent: Int?

  /// The blending mode for the layer
  let blendMode: BlendMode

  /// An array of masks for the layer.
  let masks: [Mask]?

  /// A number that stretches time by a multiplier
  let timeStretch: Double

  /// The type of matte if any.
  let matte: MatteType?

  /// Whether or not this layer is hidden, in which case it will not be rendered.
  let hidden: Bool

  /// A list of styles to apply to this layer
  let styles: [LayerStyle]

  /// A list of effects to apply to this layer
  let effects: [LayerEffect]

  // MARK: Fileprivate

  fileprivate enum CodingKeys: String {
    case name = "nm"
    case index = "ind"
    case type = "ty"
    case coordinateSpace = "ddd"
    case inFrame = "ip"
    case outFrame = "op"
    case startTime = "st"
    case transform = "ks"
    case parent
    case blendMode = "bm"
    case masks = "masksProperties"
    case timeStretch = "sr"
    case matte = "tt"
    case hidden = "hd"
    case styles = "sy"
    case effects = "ef"
  }
}

extension [LayerModel] {

  static func fromDictionaries(_ dictionaries: [[String: Any]]) throws -> [LayerModel] {
    try dictionaries.compactMap { dictionary in
      let layerType = dictionary[LayerModel.CodingKeys.type.rawValue] as? Int
      switch LayerType(rawValue: layerType ?? LayerType.null.rawValue) {
      case .precomp:
        return try PreCompLayerModel(dictionary: dictionary)
      case .solid:
        return try SolidLayerModel(dictionary: dictionary)
      case .image:
        return try ImageLayerModel(dictionary: dictionary)
      case .null:
        return try LayerModel(dictionary: dictionary)
      case .shape:
        return try ShapeLayerModel(dictionary: dictionary)
      case .text:
        return try TextLayerModel(dictionary: dictionary)
      case .unknown:
        return try LayerModel(dictionary: dictionary)
      case .none:
        return nil
      }
    }
  }
}

// MARK: - LayerModel + Sendable

/// Since `LayerModel` isn't `final`, we have to use `@unchecked Sendable` instead of `Sendable.`
/// All `LayerModel` subclasses are immutable `Sendable` values.
// swiftlint:disable:next no_unchecked_sendable
extension LayerModel: @unchecked Sendable { }
