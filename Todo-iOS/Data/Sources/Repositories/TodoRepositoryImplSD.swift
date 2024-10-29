//
//  TodoRepositoryImplSD.swift
//  Data
//
//  Created by namdghyun on 10/29/24.
//

import Domain
import Foundation
import SwiftData

public final class TodoRepositoryImplSD: TodoRepository {
  private let container: ModelContainer
  
  public init() {
    do {
      let schema = Schema([TodoSD.self])
      let config = ModelConfiguration(schema: schema)
      self.container = try ModelContainer(for: schema, configurations: [config])
    } catch {
      fatalError("Failed to initialize SwiftData: \(error)")
    }
  }
  
  public func getTodos() async throws -> [Domain.Todo] {
    let context = ModelContext(container)
    
    let descriptor = FetchDescriptor<TodoSD>(
      sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
    )
    
    return try await Task.detached(priority: .background) {
      let todos = try context.fetch(descriptor)
      print("Impl with SwiftData Concurrency: ", #function)
      return todos.map { $0.toDomain() }
    }.value
  }
  
  public func saveTodo(_ todo: Domain.Todo) async throws {
    let context = ModelContext(container)
    
    try await Task.detached(priority: .background) {
      let todo = TodoSD(from: todo)
      context.insert(todo)
      try context.save()
      print("Impl with SwiftData Concurrency: ", #function)
    }.value
  }
  
  public func updateTodo(_ todo: Domain.Todo) async throws {
    let context = ModelContext(container)
    let todoId = todo.id
    
    let predicate = #Predicate<TodoSD> { todoSD in
      todoSD.id == todoId
    }
    
    let descriptor = FetchDescriptor<TodoSD>(
      predicate: predicate
    )
    
    try await Task.detached(priority: .background) {
      let todoSDs = try context.fetch(descriptor)
      guard let todoSD = todoSDs.first else {
        throw DataError.notFoundModels
      }
      
      todoSD.update(from: todo)
      try context.save()
      print("Impl with SwiftData Concurrency: ", #function)
    }.value
  }
  
  public func deleteTodo(_ id: UUID) async throws {
    let context = ModelContext(container)
    
    let predicate = #Predicate<TodoSD> { todoSD in
      todoSD.id == id
    }
    
    let descriptor = FetchDescriptor<TodoSD>(
      predicate: predicate
    )
    
    try await Task.detached(priority: .background) {
      let todoSDs = try context.fetch(descriptor)
      guard let todoSD = todoSDs.first else {
        throw DataError.notFoundModels
      }
      
      context.delete(todoSD)
      try context.save()
      print("Impl with SwiftData Concurrency: ", #function)
    }.value
  }
}

enum DataError: LocalizedError {
  case notFoundModels
  
  var errorDescription: String? {
    switch self {
    case .notFoundModels:
      return "모델을 찾을 수 없습니다."
    }
  }
}
