//
//  Collection+SafeSubscript.swift
//  Presentation
//
//  Created by namdghyun on 10/29/24.
//

extension Collection {
    /// 안전한 인덱스 접근을 위한 subscript 확장입니다.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

/*
 let array = ["A", "B", "C"]

 // 일반적인 접근
 print(array[0]) // "A"
 print(array[3]) // 크래시 발생! - Index out of range

 // safe 접근
 print(array[safe: 0]) // Optional("A")
 print(array[safe: 3]) // nil - 크래시 없음
 */
