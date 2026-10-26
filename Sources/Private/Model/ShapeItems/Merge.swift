//
//  Merge.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

// MARK: - MergeMode

enum MergeMode: Int, Sendable {
  case none
  case merge
  case add
  case subtract
  case intersect
  case exclude
}

// MARK: - Merge

final class Merge: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let modeRawType: Int = try dictionary.value(for: CodingKeys.mode)
    guard let mode = MergeMode(rawValue: modeRawType) else {
      throw InitializableError.invalidInput()
    }
    self.mode = mode
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The mode of the merge path
  let mode: MergeMode


  // MARK: Private

  private enum CodingKeys: String {
    case mode = "mm"
  }
}
