//
//  Persistence.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 03.09.2024.
//

import CoreData
import SwiftUI

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ToDoList")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true

        if !inMemory && isCoreDataEmpty() {
            fetchTodos()
        }
    }
    
     func isCoreDataEmpty() -> Bool {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let count = try container.viewContext.count(for: fetchRequest)
            return count == 0
        } catch {
            print("Failed to fetch items count: \(error.localizedDescription)")
            return false
        }
    }
    
     func fetchTodos() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let todosResponse = try decoder.decode(TodosResponse.self, from: data)
                let viewContext = self.container.viewContext
                
                for todo in todosResponse.todos {
                    let newItem = Item(context: viewContext)
                    newItem.id = Int16(todo.id)
                    newItem.todo = todo.todo
                    newItem.completed = todo.completed
                    newItem.userId = Int16(todo.userId)
                    newItem.creationDate = Date()
                }
                
                try viewContext.save()
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .didUpdateData, object: nil)
                }
            } catch {
                print("Failed to decode todos: \(error.localizedDescription)")
            }
        }.resume()
    }
}

extension Notification.Name {
    static let didUpdateData = Notification.Name("didUpdateData")
}
