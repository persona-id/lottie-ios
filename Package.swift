// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "PersonaLottie",
    platforms: [.iOS(.v9)],
    // platforms: [.iOS("9.0"), .macOS("10.10"), tvOS("9.0"), .watchOS("2.0")],
    products: [
        .library(name: "PersonaLottie", targets: ["PersonaLottie"])
    ],
    targets: [
        .target(
            name: "PersonaLottie",
            path: "lottie-swift/src",
            exclude: ["Public/MacOS"]
        )
    ]
)
