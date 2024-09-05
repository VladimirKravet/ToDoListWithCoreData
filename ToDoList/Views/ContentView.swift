//
//  ContentView.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 03.09.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ToDoViewModel
    @State private var isPresentingTaskDetail = false
    
    
    init(viewModel: ToDoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Today's Task")
                                .font(.system(size: 24))
                            Text(DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .none))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        NavigationLink(destination: TaskDetailViewForNewTask(viewModel: viewModel)) {
                            HStack {
                                Image(systemName: "plus")
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.blue)
                                Text("New Task")
                                    .font(.system(size: 18))
                                    .foregroundColor(.blue)
                            }
                        }
                        .disabled(viewModel.deletIsTapped)
                        .padding()
                        Button(action: {
                            viewModel.deletIsTapped.toggle()
                            
                        }) {
                            Image(systemName: "trash")
                                .frame(width: 16, height: 16)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    Picker("Filter", selection: $viewModel.filter) {
                        Text("All (\(viewModel.totalTasks))").tag(ToDoViewModel.TaskFilter.all)
                        Text("Open (\(viewModel.openTasks))").tag(ToDoViewModel.TaskFilter.open)
                        Text("Closed (\(viewModel.closedTasks))").tag(ToDoViewModel.TaskFilter.closed)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.filteredItems) { item in
                                TaskView(viewModel: viewModel, item: item, itemFormatter: viewModel.itemFormatter, deleteAction: {
                                    if viewModel.deletIsTapped {
                                        viewModel.taskToDelete = item
                                        viewModel.isPresentingDeleteAlert = true
                                    }
                                })
                            }
                        }
                        .padding()
                    }
                }
            }
            .alert(isPresented: $viewModel.isPresentingDeleteAlert) {
                Alert(
                    title: Text("Delete Task"),
                    message: Text("Are you sure you want to delete this task?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let task = viewModel.taskToDelete {
                            viewModel.deleteItem(task)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .onAppear {
                NotificationCenter.default.addObserver(forName: .didUpdateData, object: nil, queue: .main) { _ in
                    viewModel.fetchItems()
                }
            }
        }
    }
}
