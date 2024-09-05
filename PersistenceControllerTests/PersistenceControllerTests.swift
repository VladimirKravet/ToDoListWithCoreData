//
//  PersistenceControllerTests.swift
//  PersistenceControllerTests
//
//  Created by Vladimir Kravets on 05.09.2024.
//

import XCTest
import CoreData
@testable import ToDoList

final class PersistenceControllerTests: XCTestCase {
    
    var persistenceController: PersistenceController!
    
    override func setUpWithError() throws {
        persistenceController = PersistenceController(inMemory: true)
    }

    override func tearDownWithError() throws {
        persistenceController = nil
    }

    func testIsCoreDataEmpty() throws {
        XCTAssertTrue(persistenceController.isCoreDataEmpty())
    }

    func testFetchTodos() throws {
        persistenceController.fetchTodos()
        
        let expectation = XCTestExpectation(description: "Fetch Todos")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)

        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let items = try persistenceController.container.viewContext.fetch(fetchRequest)
        XCTAssertFalse(items.isEmpty, "Items should not be empty after fetching todos")
    }
}
