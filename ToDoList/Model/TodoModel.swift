//
//  TodoModel.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 03.09.2024.
//

import Foundation

struct TodoModel: Codable, Identifiable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TodosResponse: Codable {
    let todos: [TodoModel]
}
