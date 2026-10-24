//
//  Trim.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

// MARK: - TrimType

enum TrimType: Int {
  case simultaneously = 1
  case individually = 2
}

// MARK: - Trim

final class Trim: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let startDictionary: [String: Any] = try dictionary.value(for: CodingKeys.start)
    start = try KeyframeGroup<LottieVector1D>(dictionary: startDictionary)
    let endDictionary: [String: Any] = try dictionary.value(for: CodingKeys.end)
    end = try KeyframeGroup<LottieVector1D>(dictionary: endDictionary)
    let offsetDictionary: [String: Any] = try dictionary.value(for: CodingKeys.offset)
    offset = try KeyframeGroup<LottieVector1D>(dictionary: offsetDictionary)
    let trimTypeRawValue: Int = try dictionary.value(for: CodingKeys.trimType)
    guard let trimType = TrimType(rawValue: trimTypeRawValue) else {
      throw InitializableError.invalidInput()
    }
    self.trimType = trimType
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The start of the trim
  let start: KeyframeGroup<LottieVector1D>

  /// The end of the trim
  let end: KeyframeGroup<LottieVector1D>

  /// The offset of the trim
  let offset: KeyframeGroup<LottieVector1D>

  let trimType: TrimType

  /// If this trim doesn't affect the path at all then we can consider it empty
  var isEmpty: Bool {
    start.keyframes.count == 1
      && start.keyframes[0].value.value == 0
      && end.keyframes.count == 1
      && end.keyframes[0].value.value == 100
  }


  // MARK: Private

  private enum CodingKeys: String {
    case start = "s"
    case end = "e"
    case offset = "o"
    case trimType = "m"
  }
}
