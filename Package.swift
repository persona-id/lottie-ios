// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "PersonaLottie2",
  // Minimum platform versions should be kept in sync with the per-platform targets in Lottie.xcodeproj, lottie-ios.podspec, and lottie-spm's Package.swift
  platforms: [.iOS("13.0"), .macOS("10.15"), .tvOS("13.0"), .custom("visionOS", versionString: "1.0")],
  products: [.library(name: "PersonaLottie2", targets: ["PersonaLottie2"])],
  // dependencies: [
  //  .package(url: "https://github.com/airbnb/swift", .upToNextMajor(from: "1.0.1")),
  // ],
  targets: [
    .target(
      name: "PersonaLottie2",
      path: "Sources",
      exclude: [
        "Private/EmbeddedLibraries/README.md",
        "Private/EmbeddedLibraries/ZipFoundation/README.md",
        "Private/EmbeddedLibraries/EpoxyCore/README.md",
        "Private/EmbeddedLibraries/LRUCache/README.md",
      ],
      resources: [.copy("PrivacyInfo.xcprivacy")],
      swiftSettings: [
        // ConciseMagicFile (SE-0274): expand #file to "Module/File.swift" instead of the build
        // machine's absolute path. Shrinks the compiled binary and keeps builder paths out of it.
        // Default in Swift 6; enabled here since this package builds in the Swift 5 language mode.
        .enableUpcomingFeature("ConciseMagicFile"),
      ]),
  ])
