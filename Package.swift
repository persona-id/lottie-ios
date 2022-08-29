// swift-tools-version:5.3
import PackageDescription

let package = Package(
  name: "PersonaLottie2",
  platforms: [.iOS("11.0"), .macOS("10.10"), .tvOS("11.0")],
  products: [.library(name: "PersonaLottie2", targets: ["PersonaLottie2"])],
  targets: [.target(name: "PersonaLottie2", path: "Sources")])
