//
//  CoreDataManager.swift
//  MyGrocery
//
//  Created by Felipe Treichel on 16/05/2018.
//  Copyright © 2018 Felipe Treichel. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    var managedObjectContext : NSManagedObjectContext!
    
    init() {
        guard let modelURL = Bundle.main.url(forResource: "DevendoCocaDataModel", withExtension: "momd") else {
            fatalError("DevendoCocaDataModel not found")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to initialize ManagedObjectModel")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let fileManager = FileManager()
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Unable to get documents URL")
        }
        
        let storeURL = documentsURL.appendingPathComponent("DevendoCoca.sqlite")
        
        print(storeURL)
        
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        
        let type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
        
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: type)
        self.managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
    }
    
}
