//
//  TaskView.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 04.09.2024.
//

import SwiftUI

struct TaskView: View {
    @ObservedObject var viewModel: ToDoViewModel
    
    var item: Item
    var itemFormatter: DateFormatter
    var deleteAction: () -> Void
    
    var body: some View {
        HStack {
            if !viewModel.deletIsTapped {
                NavigationLink(destination: TaskDetailView(item: item, viewModel: viewModel)) {
                    taskContent
                }
            } else {
                if viewModel.deletIsTapped {
                    Button(action: {
                        deleteAction()
                    }) {
                        taskContent
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
    var taskContent: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.todo ?? "No Title")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .strikethrough(item.completed, color: .black)
                Spacer()
                if item.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
            }
            HStack {
                if let creationDate = item.creationDate {
                    VStack(alignment: .leading) {
                        Divider()
                        Text("Created on \(creationDate, formatter: itemFormatter)")
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                if viewModel.deletIsTapped {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(.trailing, 4)
                        .padding(.top, 8)
                }
            }
        }
    }
}
