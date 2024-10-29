//
//  TodoSD.swift
//  TodoCleanArchitecture
//
//  Created by namdghyun on 10/29/24.
//

import Foundation
import Domain
import SwiftData

/// `Todo` 엔티티의 SwiftData 모델입니다.
/// SwiftData를 사용한 영구 저장소 구현을 위한 모델 클래스입니다.
///
/// SwiftData의 요구사항:
/// - `@Model` 매크로를 사용하여 모델임을 선언
/// - 클래스로 구현되어야 함
/// - 모든 저장 프로퍼티는 관리 가능한 타입이어야 함
@Model
class TodoSD {
    /// 할 일의 고유 식별자입니다.
    /// `@Attribute(.unique)`를 사용하여 유니크 제약조건을 설정합니다.
    @Attribute(.unique) var id: UUID
    
    /// 할 일의 제목입니다.
    var title: String
    
    /// 할 일의 완료 여부입니다.
    var isCompleted: Bool
    
    /// 할 일이 생성된 시각입니다.
    var createdAt: Date
    
    /// 할 일이 마지막으로 수정된 시각입니다.
    var updatedAt: Date
    
    /// 새로운 SwiftData 모델을 생성합니다.
    /// - Parameters:
    ///   - id: 할 일의 고유 식별자. 기본값은 새로운 UUID
    ///   - title: 할 일의 제목
    ///   - isCompleted: 완료 여부. 기본값은 false
    ///   - createdAt: 생성 시각. 기본값은 현재 시각
    ///   - updatedAt: 수정 시각. 기본값은 현재 시각
    init(
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

// MARK: - Mapping Methods
extension TodoSD {
    /// SwiftData 모델을 Domain 엔티티로 변환합니다.
    /// - Returns: 변환된 `Todo` 엔티티
    func toDomain() -> Todo {
        Todo(
            id: id,
            title: title,
            isCompleted: isCompleted,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
    
    /// Domain 엔티티의 값으로 현재 모델을 업데이트합니다.
    /// - Parameter domain: 업데이트할 값을 가진 `Todo` 엔티티
    func update(from domain: Todo) {
        self.title = domain.title
        self.isCompleted = domain.isCompleted
        self.updatedAt = domain.updatedAt
    }
    
    /// Domain 엔티티로부터 새로운 SwiftData 모델을 생성합니다.
    /// - Parameter domain: 변환할 `Todo` 엔티티
    convenience init(from domain: Todo) {
        self.init(
            id: domain.id,
            title: domain.title,
            isCompleted: domain.isCompleted,
            createdAt: domain.createdAt,
            updatedAt: domain.updatedAt
        )
    }
}
