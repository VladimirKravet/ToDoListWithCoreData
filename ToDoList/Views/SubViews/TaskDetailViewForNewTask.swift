//
//  TaskDetailViewForNewTask.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 04.09.2024.
//

import SwiftUI

struct TaskDetailViewForNewTask: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: ToDoViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var tempTaskTitle: String = ""
    @State private var tempTaskDetails: String = ""
    @State private var tempCompleted: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Task Details")) {
                TextField("Task Title", text: $tempTaskTitle)
                TextField("Description", text: $tempTaskDetails)
                Toggle("Completed", isOn: $tempCompleted)
            }
        }
        .navigationTitle("Task Details")
        .navigationBarItems(trailing: Button("Save") {
            viewModel.taskTitle = tempTaskTitle
            viewModel.taskDetails = tempTaskDetails
            viewModel.completed = tempCompleted
            viewModel.addItem()
            viewModel.taskTitle = ""
            viewModel.taskDetails = ""
            viewModel.completed = false
            viewModel.fetchItems()
            
            dismiss()
        })
        .onAppear {
            tempTaskTitle = viewModel.taskTitle
            tempTaskDetails = viewModel.taskDetails
            tempCompleted = viewModel.completed
        }
    }
}
