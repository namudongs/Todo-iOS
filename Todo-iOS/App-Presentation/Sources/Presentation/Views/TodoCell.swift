//
//  TodoCell.swift
//  Presentation
//
//  Created by namdghyun on 10/29/24.
//

import SwiftUI
import Domain

/// 각각의 할 일 항목을 표시하는 셀 뷰입니다.
struct TodoCell: View {
  let todo: Todo
  let onToggle: () -> Void
  let onEdit: () -> Void
  
  var body: some View {
    HStack {
      Button {
        onToggle()
      } label: {
        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
          .foregroundStyle(todo.isCompleted ? .green : .gray)
      }
      .buttonStyle(.plain)
      
      VStack(alignment: .leading, spacing: 4) {
        Text(todo.title)
          .strikethrough(todo.isCompleted)
          .foregroundStyle(todo.isCompleted ? .gray : .primary)
        
        Text(todo.updatedAt.formatted(date: .abbreviated, time: .shortened))
          .font(.caption2)
          .foregroundStyle(.gray)
      }
      
      Spacer()
      
      Button {
        onEdit()
      } label: {
        Image(systemName: "pencil")
          .foregroundStyle(.blue)
      }
      .buttonStyle(.plain)
    }
    .contentShape(Rectangle())
  }
}
