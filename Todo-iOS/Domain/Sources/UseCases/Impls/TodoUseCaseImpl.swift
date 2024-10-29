//
//  TodoUseCaseImpl.swift
//  Domain
//
//  Created by namdghyun on 10/30/24.
//

import Foundation

public final class TodoUseCaseImpl: TodoUseCase {
  private let repository: TodoRepository
  
  public init(repository: TodoRepository) {
    self.repository = repository
  }
  
  public func fetchTodos() async throws -> [Todo] {
    try await repository.getTodos()
  }
  
  public func createTodo(_ title: String) async throws {
    guard !title.isEmpty else {
      return print("제목은 비울 수 없습니다.")
    }
    
    let todo = Todo(title: title)
    return try await repository.saveTodo(todo)
  }
  
  public func toggleTodo(_ todo: Todo) async throws {
    var updatedTodo = todo
    updatedTodo.toggleCompletion()
    return try await repository.updateTodo(updatedTodo)
  }
  
  public func deleteTodo(_ id: UUID) async throws {
    try await repository.deleteTodo(id)
  }
  
  public func updateTodoTitle(_ todo: Todo, newTitle: String) async throws {
    guard !newTitle.isEmpty else {
      return print("제목은 비울 수 없습니다.")
    }
    
    var updatedTodo = todo
    updatedTodo.updateTitle(newTitle)
    return try await repository.updateTodo(updatedTodo)
  }
}
