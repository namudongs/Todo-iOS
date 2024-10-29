//
//  PresentationState.swift
//  Presentation
//
//  Created by namdghyun on 10/29/24.
//

import Foundation
import Domain

/// 앱의 네비게이션 상태를 관리하는 열거형입니다.
enum PresentationState: Identifiable {
  case addTodo
  case editTodo(Todo)
  
  var id: String {
    switch self {
    case .addTodo:
      return "addTodo"
    case .editTodo(let todo):
      return "editTodo_\(todo.id)"
    }
  }
}
