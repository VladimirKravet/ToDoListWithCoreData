//
//  ToDoViewModel.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 04.09.2024.
//

import SwiftUI
import CoreData

class ToDoViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    @Published var items: [Item] = []
    @Published var isLoading: Bool = true
    @Published var completed: Bool = false
    @Published var taskTitle = ""
    @Published var taskDetails = ""
    @Published var filter: TaskFilter = .all
    @Published var taskToDelete: Item?
    @Published var isPresentingDeleteAlert = false
    @Published var deletIsTapped = false
    
    var totalTasks: Int {
        items.count
    }
    
    var openTasks: Int {
        items.filter { !$0.completed }.count
    }
    
    var closedTasks: Int {
        items.filter { $0.completed }.count
    }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchItems()
    }
    
    func fetchItems() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.id, ascending: true)]
        
        DispatchQueue.global(qos: .background).async {
            do {
                let fetchedItems = try self.viewContext.fetch(fetchRequest)
                
                DispatchQueue.main.async {
                    self.items = fetchedItems
                    self.isLoading = false
                }
            } catch {
                print("Failed to fetch items: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            if let maxID = items.map({ $0.id }).max() {
                newItem.id = maxID + 1
            } else {
                newItem.id = 1
            }
            
            newItem.todo = taskTitle
            newItem.completed = completed
            newItem.taskDescription = taskDetails
            newItem.creationDate = Date()
            
            do {
                try viewContext.save()
                fetchItems()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteItem(_ item: Item) {
        withAnimation {
            viewContext.delete(item)
            do {
                try viewContext.save()
                fetchItems()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    enum TaskFilter {
        case all, open, closed
    }
    
    var filteredItems: [Item] {
        switch filter {
        case .all:
            return items
        case .open:
            return items.filter { !$0.completed }
        case .closed:
            return items.filter { $0.completed }
        }
    }
}
