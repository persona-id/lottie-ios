// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "PersonaLottie2",
    platforms: [.iOS(.v9)],
    // platforms: [.iOS("9.0"), .macOS("10.10"), tvOS("9.0"), .watchOS("2.0")],
    products: [
        .library(name: "PersonaLottie2", targets: ["PersonaLottie2"])
    ],
    targets: [
        .target(
            name: "PersonaLottie2",
            path: "lottie-swift/src",
            exclude: ["Public/MacOS"],
            resources: [.copy("PrivacyInfo.xcprivacy")])
        )
    ]
)
