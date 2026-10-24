//
//  TextLayer.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

/// A layer that holds text.
final class TextLayerModel: LayerModel {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let containerDictionary: [String: Any] = try dictionary.value(for: CodingKeys.textGroup)
    let textDictionary: [String: Any] = try containerDictionary.value(for: TextCodingKeys.text)
    text = try KeyframeGroup<TextDocument>(dictionary: textDictionary)
    let animatorDictionaries: [[String: Any]] = try containerDictionary.value(for: TextCodingKeys.animators)
    animators = try animatorDictionaries.map { try TextAnimator(dictionary: $0) }
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The text for the layer
  let text: KeyframeGroup<TextDocument>

  /// Text animators
  let animators: [TextAnimator]


  // MARK: Private

  private enum CodingKeys: String {
    case textGroup = "t"
  }

  private enum TextCodingKeys: String {
    case text = "d"
    case animators = "a"
  }
}
