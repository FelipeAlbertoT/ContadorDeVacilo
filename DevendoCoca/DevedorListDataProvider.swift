//
//  DevedorListDataProvider.swift
//  DevendoCoca
//
//  Created by Felipe Treichel on 28/05/2018.
//  Copyright © 2018 Felipe Treichel. All rights reserved.
//

import Foundation
import CoreData

protocol DevedorListDataProviderDelegate : class {
    func devedorListDataProviderDidInsert(indexPath: IndexPath)
    func devedorListDataProviderDidDelete(indexPath: IndexPath)
}

class DevedorListDataProvider: NSObject, NSFetchedResultsControllerDelegate, DevedorCellDelegate {
    
    weak var delegate: DevedorListDataProviderDelegate!
    var managedObjectContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController<Devedor>!
    
    var sections  : [NSFetchedResultsSectionInfo]? {
        get {
            return self.fetchedResultsController.sections
        }
    }
    
    init(_ managedObjectContext : NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        
        let request = NSFetchRequest<Devedor>(entityName: "Devedor")
        request.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController<Devedor>(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            self.delegate.devedorListDataProviderDidInsert(indexPath: newIndexPath!)
        } else if type == .delete {
            self.delegate.devedorListDataProviderDidDelete(indexPath: indexPath!)
        }
    }
    
    func addDevedor(nome: String) {
        let devedor = NSEntityDescription.insertNewObject(forEntityName: "Devedor", into: self.managedObjectContext) as! Devedor
        
        devedor.nome = nome
        devedor.quantidade = 0
        
        try! self.managedObjectContext.save()
    }
    
    func object(at indexPath: IndexPath) -> Devedor {
        return self.fetchedResultsController.object(at: indexPath)
    }
    
    func devedorCellDidIncrease(_ devedor: Devedor) {
        devedor.quantidade += 1
        
        try! self.managedObjectContext.save()
    }
    
    func devedorCellDidDecrease(_ devedor: Devedor) {
        devedor.quantidade -= 1
        
        if devedor.quantidade < 0 {
            self.managedObjectContext.delete(devedor)
        }
        
        try! self.managedObjectContext.save()
    }
    
}
