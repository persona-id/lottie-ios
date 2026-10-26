//
//  GroupItem.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/8/19.
//

/// An item that define a a group of shape items
final class Group: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let itemDictionaries: [[String: Any]] = try dictionary.value(for: CodingKeys.items)
    items = try [ShapeItem].fromDictionaries(itemDictionaries)
    try super.init(dictionary: dictionary)
  }

  init(items: [ShapeItem], name: String) {
    self.items = items
    super.init(name: name, type: .group, hidden: false)
  }

  // MARK: Internal

  /// A list of shape items.
  let items: [ShapeItem]


  // MARK: Private

  private enum CodingKeys: String {
    case items = "it"
  }
}
