//
//  TodoEditMode.swift
//  Presentation
//
//  Created by namdghyun on 10/29/24.
//

import SwiftUI
import Domain

/// 할 일 편집 모드를 정의하는 열거형입니다.
enum TodoEditMode {
  case add
  case edit(Todo)
  
  var title: String {
    switch self {
    case .add:
      return "할 일 추가"
    case .edit:
      return "할 일 수정"
    }
  }
  
  var initialText: String {
    switch self {
    case .add:
      return ""
    case .edit(let todo):
      return todo.title
    }
  }
}

/// 할 일을 추가하거나 수정하는 시트 뷰입니다.
struct TodoEditView: View {
  let mode: TodoEditMode
  let onSubmit: (String) -> Void
  
  @Environment(\.dismiss) private var dismiss
  @State private var title: String = ""
  @FocusState private var isFocused: Bool
  
  init(mode: TodoEditMode, onSubmit: @escaping (String) -> Void) {
    self.mode = mode
    self.onSubmit = onSubmit
    self._title = State(initialValue: mode.initialText)
  }
  
  var body: some View {
    NavigationView {
      Form {
        TextField("할 일을 입력하세요", text: $title)
          .focused($isFocused)
      }
      .navigationTitle(mode.title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("취소") {
            dismiss()
          }
        }
        
        ToolbarItem(placement: .confirmationAction) {
          Button("완료") {
            onSubmit(title)
          }
          .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
        }
      }
    }
    .onAppear {
      isFocused = true
    }
  }
}
