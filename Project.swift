import ProjectDescription

let project = Project(
  name: "Todo-iOS",
  targets: [
    .target(
      name: "App-Presentation",
      destinations: .iOS,
      product: .app,
      bundleId: "com.namudi.todo-ios",
      infoPlist: .extendingDefault(
        with: [
          "UILaunchScreen": [
            "UIColorName": "",
            "UIImageName": "",
          ],
        ]
      ),
      sources: ["Todo-iOS/App-Presentation/Sources/**"],
      resources: ["Todo-iOS/App-Presentation/Resources/**"],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "Data")
      ]
    ),
    .target(
      name: "Domain",
      destinations: .iOS,
      product: .framework,
      bundleId: "com.namudi.todo-domain",
      infoPlist: .default,
      sources: ["Todo-iOS/Domain/Sources/**"],
      resources: [],
      dependencies: []
    ),
    .target(
      name: "Data",
      destinations: .iOS,
      product: .framework,
      bundleId: "com.namudi.todo-data",
      infoPlist: .default,
      sources: ["Todo-iOS/Data/Sources/**"],
      resources: [],
      dependencies: [
        .target(name: "Domain")
      ]
    ),
  ]
)
