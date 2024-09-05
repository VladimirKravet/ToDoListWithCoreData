//
//  TaskDetailView.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 03.09.2024.
//


import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var item: Item
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ToDoViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var tempTitle: String
    @State private var tempDescription: String
    @State private var tempCompleted: Bool
    
    init(item: Item, viewModel: ToDoViewModel) {
        self.item = item
        self.viewModel = viewModel
        
        _tempTitle = State(initialValue: item.todo ?? "")
        _tempDescription = State(initialValue: item.taskDescription ?? "")
        _tempCompleted = State(initialValue: item.completed)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Title", text: $tempTitle)
                TextField("Description", text: $tempDescription)
                Toggle("Completed", isOn: $tempCompleted)
            }
        }
        .navigationTitle("Edit Task")
        .navigationBarItems(trailing: Button("Save") {
            item.todo = tempTitle
            item.taskDescription = tempDescription
            item.completed = tempCompleted
            try? viewContext.save()
            viewModel.fetchItems()
            dismiss()
        })
    }
}
