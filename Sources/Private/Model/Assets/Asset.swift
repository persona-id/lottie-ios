//
//  Asset.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/9/19.
//

// MARK: - Asset

public class Asset: DictionaryInitializable {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    if let id = dictionary[CodingKeys.id.rawValue] as? String {
      self.id = id
    } else if let id = dictionary[CodingKeys.id.rawValue] as? Int {
      self.id = String(id)
    } else {
      throw InitializableError.invalidInput()
    }
  }

  // MARK: Public

  /// The ID of the asset
  public let id: String

  // MARK: Private

  private enum CodingKeys: String {
    case id
  }
}

// MARK: Sendable

/// Since `Asset` isn't `final`, we have to use `@unchecked Sendable` instead of `Sendable.`
/// All `Asset` subclasses are immutable `Sendable` values.
// swiftlint:disable:next no_unchecked_sendable
extension Asset: @unchecked Sendable { }
