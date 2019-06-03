//
//  CoreDataManager.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/15.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OCR")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getData() -> [Item] {
        let context = persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            return try context.fetch(fetchRequest)
        } catch {
            print("データ取得に失敗")
            return []
        }
    }
    
    func insertData(titleText: String, resultText: String) {
        let context = persistentContainer.viewContext
        let item = Item(context: context)
        item.title = titleText
        item.detail = resultText
        item.date = Date()
        item.uniqueDate = Date()
        saveContext()
    }
    
    func updateData(titleText: String, detailText: String, item: Item) {
        guard let uniqueDate = item.uniqueDate else { return }
        let context = persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uniqueDate = %@", uniqueDate as NSDate)
            let item = try context.fetch(fetchRequest)
            item.first?.title = titleText
            item.first?.detail = detailText
            item.first?.date = Date()
        } catch {
            print("データ取得に失敗")
        }
        saveContext()
    }
    
    func deleteData(item: Item) {
        let context = persistentContainer.viewContext
        context.delete(item)
        saveContext()
    }
    
}
