//
//  RoundedCorners.swift
//  Lottie
//
//  Created by Duolingo on 10/31/22.
//

// MARK: - RoundedCorners

final class RoundedCorners: ShapeItem {

  // MARK: Lifecycle


  required init(dictionary: [String: Any]) throws {
    let radiusDictionary: [String: Any] = try dictionary.value(for: CodingKeys.radius)
    radius = try KeyframeGroup<LottieVector1D>(dictionary: radiusDictionary)
    try super.init(dictionary: dictionary)
  }

  // MARK: Internal

  /// The radius of rounded corners
  let radius: KeyframeGroup<LottieVector1D>


  // MARK: Private

  private enum CodingKeys: String {
    case radius = "r"
  }
}
