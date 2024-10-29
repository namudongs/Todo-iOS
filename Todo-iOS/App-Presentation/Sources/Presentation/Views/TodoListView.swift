//
//  TodoListView.swift
//  Presentation
//
//  Created by namdghyun on 10/29/24.
//

import SwiftUI

/// 할 일 목록을 표시하는 메인 뷰입니다.
struct TodoListView: View {
  @State var viewModel: TodoViewModel
  
  var body: some View {
    NavigationStack {
      Group {
        switch viewModel.uiState {
        case .idle, .loading:
          ProgressView()
            .progressViewStyle(.circular)
        case .loaded(let todos):
          if todos.isEmpty {
            ContentUnavailableView(
              "할 일이 없습니다",
              systemImage: "checklist",
              description: Text("새로운 할 일을 추가해보세요")
            )
          } else {
            List {
              ForEach(todos) { todo in
                TodoCell(
                  todo: todo,
                  onToggle: {
                    viewModel.send(.onToggleTodo(todo))
                  },
                  onEdit: {
                    viewModel.showEditTodo(todo)
                  }
                )
              }
              .onDelete { indexSet in
                guard let index = indexSet.first,
                      let id = todos[safe: index]?.id else { return }
                viewModel.send(.onDeleteTodo(id))
              }
            }
          }
        case .error(let message):
          ContentUnavailableView(
            "오류가 발생했습니다",
            systemImage: "exclamationmark.triangle",
            description: Text(message)
          )
        }
      }
      .navigationTitle("할 일 목록")
      .toolbar {
        ToolbarItem(placement: .primaryAction) {
          Button {
            viewModel.showAddTodo()
          } label: {
            Image(systemName: "plus")
          }
        }
      }
    }
    // MARK: - Navigation & Sheet Presentation
    .sheet(item: $viewModel.presentationState) { state in
      switch state {
      case .addTodo:
        TodoEditView(
          mode: .add,
          onSubmit: { title in
            viewModel.send(.onCreateTodo(title))
          }
        )
      case .editTodo(let todo):
        TodoEditView(
          mode: .edit(todo),
          onSubmit: { title in
            viewModel.send(.onEditTodo(todo, title))
          }
        )
      }
    }
  }
}
