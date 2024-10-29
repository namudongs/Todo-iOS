//
//  TodoRepository.swift
//  Domain
//
//  Created by namdghyun on 10/29/24.
//

import Foundation

public protocol TodoRepository {
  func getTodos() async throws -> [Todo]
  func saveTodo(_ todo: Todo) async throws
  func updateTodo(_ todo: Todo) async throws
  func deleteTodo(_ id: UUID) async throws
}
