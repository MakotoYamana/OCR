//
//  CoreDataManager.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/15.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import CoreData

enum recognitionResultStatus {
    case success([RecognitionInfo])
    case failuer(Error)
    case empty
}

protocol CoreDataManagerDelegate: class {
    func recognitionResult(result: recognitionResultStatus)
}

class CoreDataManager {
    
    static let shared = CoreDataManager()
    var delegate: CoreDataManagerDelegate?
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OCR")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assert(false, "Unresolved error \(error), \(error.userInfo)")
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
                assert(false, "Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getInfo() {
        let context = persistentContainer.viewContext
        do {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            let items = try context.fetch(fetchRequest)
            if items.isEmpty {
                self.delegate?.recognitionResult(result: .empty)
            }
            self.delegate?.recognitionResult(result: .success(items.compactMap { $0.toRecognitionInfo() }))
        } catch let error {
            self.delegate?.recognitionResult(result: .failuer(error))
        }
    }
    
    func insertData(with info: RecognitionInfo) {
        info.createItem()
        saveContext()
    }
    
    func updateData(with info: RecognitionInfo) {
        
        let context = persistentContainer.viewContext
        do {
            let fetchRequest = generateFetchRequest(info: info)
            let item = try context.fetch(fetchRequest)
            item.first?.title = info.title
            item.first?.detail = info.detail
            item.first?.date = info.date
        } catch let error {
            self.delegate?.recognitionResult(result: .failuer(error))
        }
        saveContext()
    }
    
    func deleteData(with info: RecognitionInfo) {
        let context = persistentContainer.viewContext
        do {
            let fetchRequest = generateFetchRequest(info: info)
            if let item = try context.fetch(fetchRequest).first {
                context.delete(item)
            }
        } catch let error {
            self.delegate?.recognitionResult(result: .failuer(error))
        }
        saveContext()
    }
    
    private func generateFetchRequest(info: RecognitionInfo) -> NSFetchRequest<Item> {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uniqueDate = %@", info.uniqueDate as NSDate)
        return fetchRequest
    }
    
}

extension RecognitionInfo {
    
    func createItem() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let item = Item(context: context)
        item.title = self.title
        item.detail = self.detail
        item.date = self.date
        item.uniqueDate = self.uniqueDate
    }
    
}

extension Item {
    
    func toRecognitionInfo() -> RecognitionInfo? {
        guard let uniqueDate = uniqueDate else { return nil }
        return RecognitionInfo.init(title: title, detail: detail, date: date, uniqueDate: uniqueDate)
    }
    
}
