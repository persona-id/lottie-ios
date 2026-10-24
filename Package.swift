// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "PersonaLottie2",
  // Trimmed for the Persona iOS SDK: iOS only, Main Thread rendering engine only.
  platforms: [.iOS("13.0")],
  products: [.library(name: "PersonaLottie2", targets: ["PersonaLottie2"])],
  targets: [
    .target(
      name: "PersonaLottie2",
      path: "Sources",
      exclude: [
        "Private/EmbeddedLibraries/README.md",
        "Private/EmbeddedLibraries/LRUCache/README.md",
      ],
      resources: [.copy("PrivacyInfo.xcprivacy")],
      swiftSettings: [
        // ConciseMagicFile (SE-0274): expand #file to "Module/File.swift" instead of the build
        // machine's absolute path. Shrinks the compiled binary and keeps builder paths out of it.
        // Default in Swift 6; enabled here since this package builds in the Swift 5 language mode.
        .enableUpcomingFeature("ConciseMagicFile"),
        // Lottie never reads its own reflection metadata outside debug descriptions.
        .unsafeFlags(["-Xfrontend", "-disable-reflection-metadata"]),
      ]),
  ])
