//
//  TodoViewModel.swift
//  Presentation
//
//  Created by namdghyun on 10/29/24.
//

import Foundation
import Domain

/// TodoViewModel은 할 일(Todo) 목록의 상태를 관리하고 사용자 인터랙션을 처리하는 뷰모델입니다.
/// Clean Architecture 패턴을 따르며, 단방향 데이터 흐름(Unidirectional Data Flow)을 구현합니다.
///
/// # 주요 책임
/// - 할 일 목록의 상태 관리 (로딩, 에러, 데이터 표시)
/// - 사용자 액션 처리 (생성, 수정, 삭제, 토글)
/// - 데이터 계층(Domain)과의 통신
/// - UI 상태 업데이트 및 화면 전환 관리
///
/// # 상태 관리
/// - `uiState`: 현재 UI의 상태를 나타내며, 외부에서는 읽기만 가능
/// - `presentationState`: 모달/시트 표시 상태를 관리
///
/// # 동시성 처리
/// - UI 업데이트는 `@MainActor`를 통해 메인 스레드에서 처리
/// - 데이터 작업은 백그라운드 스레드에서 처리
///
/// # 에러 처리
/// - Domain 계층의 에러를 catch하여 사용자가 이해할 수 있는 메시지로 변환
/// - 에러 발생 시 UI 상태를 error 상태로 변경
@Observable
final class TodoViewModel {
  /// 현재 UI의 상태를 나타냅니다.
  /// 외부에서는 읽기만 가능하며, 내부에서만 수정할 수 있습니다.
  private(set) var uiState: UIState = .idle
  
  /// 현재 표시되어야 하는 프레젠테이션 상태를 나타냅니다.
  /// 시트나 모달 표시에 사용되며, nil이면 시트가 표시되지 않습니다.
  var presentationState: PresentationState?
  
  /// 비즈니스 로직을 처리하는 유스케이스 인스턴스입니다.
  /// Domain 계층과의 통신을 담당합니다.
  private let useCase: TodoUseCase
  
  /// 뷰모델을 초기화하고 초기 데이터를 로드합니다.
  /// - Parameter useCase: 할 일 관련 비즈니스 로직을 처리할 유스케이스
  init(useCase: TodoUseCase) {
    self.useCase = useCase
    send(.onAppear)  // 초기 데이터 로드 시작
  }
}

// MARK: - Types
extension TodoViewModel {
  /// UI의 현재 상태를 나타내는 열거형입니다.
  enum UIState {
    /// 초기 상태입니다. 아직 데이터 로드가 시작되지 않았습니다.
    case idle
    /// 데이터를 로드 중인 상태입니다. 로딩 인디케이터가 표시됩니다.
    case loading
    /// 데이터 로드가 완료된 상태입니다. Todo 배열을 포함합니다.
    case loaded([Todo])
    /// 에러가 발생한 상태입니다. 에러 메시지를 포함합니다.
    case error(String)
  }
  
  /// 사용자 또는 시스템에 의해 발생할 수 있는 액션들을 정의합니다.
  enum Action {
    case onAppear
    case onCreateTodo(String)
    case onToggleTodo(Todo)
    case onDeleteTodo(UUID)
    case onEditTodo(Todo, String)
  }
  
  /// UI 상태 변경을 위한 내부 이벤트를 정의합니다.
  private enum Effect {
    case setLoading
    case setError(String)
    case setTodos([Todo])
    case dismissSheet
  }
}

// MARK: - Action Handler
extension TodoViewModel {
  /// 사용자 액션을 처리하기 위한 진입점입니다.
  /// 비동기 작업을 위한 Task를 생성하고 handle 메서드를 호출합니다.
  /// - Parameter action: 처리할 액션
  func send(_ action: Action) {
    Task {
      await handle(action)
    }
  }
  
  /// 액션을 실제로 처리하고 적절한 Effect를 발생시킵니다.
  /// useCase를 통해 데이터 작업을 수행하고, 결과에 따라 UI 상태를 업데이트합니다.
  /// - Parameter action: 처리할 액션
  @MainActor
  private func handle(_ action: Action) async {
    do {
      switch action {
      case .onAppear:
        await setEffect(.setLoading)
        let todos = try await useCase.fetchTodos()
        await setEffect(.setTodos(todos))
        
      case .onCreateTodo(let title):
        await setEffect(.setLoading)
        try await useCase.createTodo(title)
        let todos = try await useCase.fetchTodos()
        await setEffect(.setTodos(todos))
        await setEffect(.dismissSheet)
        
      case .onToggleTodo(let todo):
        await setEffect(.setLoading)
        try await useCase.toggleTodo(todo)
        let todos = try await useCase.fetchTodos()
        await setEffect(.setTodos(todos))
        
      case .onDeleteTodo(let id):
        await setEffect(.setLoading)
        try await useCase.deleteTodo(id)
        let todos = try await useCase.fetchTodos()
        await setEffect(.setTodos(todos))
        
      case .onEditTodo(let todo, let title):
        await setEffect(.setLoading)
        try await useCase.updateTodoTitle(todo, newTitle: title)
        let todos = try await useCase.fetchTodos()
        await setEffect(.setTodos(todos))
        await setEffect(.dismissSheet)
      }
    } catch {
      await setEffect(.setError(error.localizedDescription))
    }
  }
}

// MARK: - Effect Handler
extension TodoViewModel {
  /// Effect에 따라 UI 상태를 업데이트합니다.
  /// 모든 UI 상태 변경은 메인 스레드에서 이루어져야 하므로 @MainActor로 선언되어 있습니다.
  /// - Parameter effect: 적용할 Effect
  @MainActor
  private func setEffect(_ effect: Effect) async {
    switch effect {
    case .setLoading:
      uiState = .loading
      
    case .setError(let message):
      uiState = .error(message)
      
    case .setTodos(let todos):
      uiState = .loaded(todos)
      
    case .dismissSheet:
      presentationState = nil
    }
  }
}

// MARK: - Navigation
extension TodoViewModel {
  /// 할 일 추가 화면을 표시합니다.
  /// UI 상태를 변경하므로 메인 스레드에서 실행되어야 합니다.
  @MainActor
  func showAddTodo() {
    presentationState = .addTodo
  }
  
  /// 할 일 수정 화면을 표시합니다.
  /// - Parameter todo: 수정할 할 일
  /// UI 상태를 변경하므로 메인 스레드에서 실행되어야 합니다.
  @MainActor
  func showEditTodo(_ todo: Todo) {
    presentationState = .editTodo(todo)
  }
}
