// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iosMath",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "iosMath",
            targets: ["iosMath"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "iosMath",
            dependencies: [],
            path: "iosMath",
            resources: [.copy("img"), .copy("fonts")],
            cSettings: [
                .headerSearchPath(".")
            ])
//        .testTarget(
//            name: "iosMathTests",
//            dependencies: ["iosMath"],
//            path: "./iosMathTests",
//            exclude:["iosMathTests-Info.plist", "en.lproj"],
//            cSettings: [
//                .headerSearchPath(".")
//            ])
    ]
)
