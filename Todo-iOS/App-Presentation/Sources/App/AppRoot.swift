//
//  AppRoot.swift
//  App
//
//  Created by namdghyun on 10/29/24.
//


import SwiftUI

@main
struct AppRoot: App {
  var body: some Scene {
    WindowGroup {
      TodoListView(viewModel: DIContainer().makeTodoViewModel())
    }
  }
}
