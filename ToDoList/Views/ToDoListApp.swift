//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Vladimir Kravets on 03.09.2024.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ToDoViewModel(viewContext: persistenceController.container.viewContext))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .background(Color(.systemGray6))
        }
    }
}
