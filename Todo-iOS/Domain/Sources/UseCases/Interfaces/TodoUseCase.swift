//
//  TodoUseCase.swift
//  Domain
//
//  Created by namdghyun on 10/29/24.
//

import Foundation

public protocol TodoUseCase {
  func fetchTodos() async throws -> [Todo]
  
  func createTodo(_ title: String) async throws
  
  func toggleTodo(_ todo: Todo) async throws
  
  func deleteTodo(_ id: UUID) async throws
  
  func updateTodoTitle(_ todo: Todo, newTitle: String) async throws
}
