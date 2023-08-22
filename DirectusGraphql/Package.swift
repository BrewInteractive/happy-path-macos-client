// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "DirectusGraphql",
  platforms: [
    .iOS(.v12),
    .macOS(.v10_14),
    .tvOS(.v12),
    .watchOS(.v5),
  ],
  products: [
    .library(name: "DirectusGraphql", targets: ["DirectusGraphql"]),
    .library(name: "GraphqlTestMocks", targets: ["GraphqlTestMocks"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apollographql/apollo-ios.git", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "DirectusGraphql",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-ios"),
      ],
      path: "./Sources"
    ),
    .target(
      name: "GraphqlTestMocks",
      dependencies: [
        .product(name: "ApolloTestSupport", package: "apollo-ios"),
        .target(name: "DirectusGraphql"),
      ],
      path: "./GraphqlTestMocks"
    ),
  ]
)
