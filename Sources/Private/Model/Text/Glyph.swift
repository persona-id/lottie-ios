//
//  Glyph.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/9/19.
//

/// A model that holds a vector character
final class Glyph: Sendable, DictionaryInitializable {

  // MARK: Lifecycle


  init(dictionary: [String: Any]) throws {
    character = try dictionary.value(for: CodingKeys.character)
    fontSize = try dictionary.value(for: CodingKeys.fontSize)
    fontFamily = try dictionary.value(for: CodingKeys.fontFamily)
    fontStyle = try dictionary.value(for: CodingKeys.fontStyle)
    width = try dictionary.value(for: CodingKeys.width)
    if
      let shapes = dictionary[CodingKeys.shapeWrapper.rawValue] as? [String: Any],
      let shapeDictionaries = shapes[ShapeKey.shapes.rawValue] as? [[String: Any]]
    {
      self.shapes = try [ShapeItem].fromDictionaries(shapeDictionaries)
    } else {
      shapes = [ShapeItem]()
    }
  }

  // MARK: Internal

  /// The character
  let character: String

  /// The font size of the character
  let fontSize: Double

  /// The font family of the character
  let fontFamily: String

  /// The Style of the character
  let fontStyle: String

  /// The Width of the character
  let width: Double

  /// The Shape Data of the Character
  let shapes: [ShapeItem]


  // MARK: Private

  private enum CodingKeys: String {
    case character = "ch"
    case fontSize = "size"
    case fontFamily = "fFamily"
    case fontStyle = "style"
    case width = "w"
    case shapeWrapper = "data"
  }

  private enum ShapeKey: String {
    case shapes
  }
}
