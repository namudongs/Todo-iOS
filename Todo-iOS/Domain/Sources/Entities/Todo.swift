//
//  Todo.swift
//  Data
//
//  Created by namdghyun on 10/29/24.
//

import Foundation

/// Todo 엔티티는 할 일 항목을 나타내는 도메인 모델입니다.
/// Clean Architecture에서 가장 안쪽에 위치하며, 비즈니스 규칙을 포함합니다.
public struct Todo: Identifiable, Equatable {
  /// 할 일 항목의 고유 식별자
  public let id: UUID
  /// 할 일 제목
  public var title: String
  /// 할 일 완료 여부
  public var isCompleted: Bool
  /// 생성 일시
  public let createdAt: Date
  /// 수정 일시
  public var updatedAt: Date
  
  public init(
    id: UUID = UUID(),
    title: String,
    isCompleted: Bool = false,
    createdAt: Date = Date(),
    updatedAt: Date = Date()
  ) {
    self.id = id
    self.title = title
    self.isCompleted = isCompleted
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

// MARK: - Business Rules
extension Todo {
  /// 할 일의 완료 상태를 토글합니다.
  public mutating func toggleCompletion() {
    isCompleted.toggle()
    updatedAt = Date()
  }
  
  /// 할 일의 제목을 업데이트합니다.
  /// - Parameter newTitle: 새로운 제목
  public mutating func updateTitle(_ newTitle: String) {
    guard !newTitle.isEmpty else { return }
    title = newTitle
    updatedAt = Date()
  }
}
