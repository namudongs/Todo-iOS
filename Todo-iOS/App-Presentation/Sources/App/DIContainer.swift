//
//  DIContainer.swift
//  App
//
//  Created by namdghyun on 10/29/24.
//

import Foundation
import Domain
import Data

/// 앱의 의존성을 관리하고 주입하는 컨테이너입니다.
struct DIContainer {
  /// Todo Repository 인스턴스를 생성합니다.
  private func makeTodoRepository() -> TodoRepository {
    TodoRepositoryImplSD()
  }
  
  /// Todo UseCase 인스턴스를 생성합니다.
  private func makeTodoUseCase() -> TodoUseCase {
    TodoUseCaseImpl(repository: makeTodoRepository())
  }
  
  /// Todo ViewModel 인스턴스를 생성합니다.
  @MainActor
  func makeTodoViewModel() -> TodoViewModel {
    TodoViewModel(useCase: makeTodoUseCase())
  }
}
