//
//  TableViewController.swift
//  DevendoCoca
//
//  Created by Felipe Treichel on 24/05/2018.
//  Copyright © 2018 Felipe Treichel. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate {

    var managedObjectContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController<Devedor>!
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSFetchRequest<Devedor>(entityName: "Devedor")
        request.sortDescriptors = [NSSortDescriptor(key: "nome", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController<Devedor>(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DevedorCell
        //cell.setupCell()
        
        
        let devedor = self.fetchedResultsController.object(at: indexPath)
        
        cell.nomeLabel.text = devedor.nome
        cell.quantidadeLabel.text = "\(devedor.quantidade)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 10, y: 0, width: self.view.frame.width-10, height: 44))
        
        let textField = UITextField(frame: view.frame)
        textField.placeholder = "Adicionar vacilão"
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        view.addSubview(textField)
        return view
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let devedor = NSEntityDescription.insertNewObject(forEntityName: "Devedor", into: self.managedObjectContext) as! Devedor
        devedor.nome = textField.text
        devedor.quantidade = 0
        
        try! self.managedObjectContext.save()
        
        textField.text = ""
        return textField.resignFirstResponder()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let devedor = self.fetchedResultsController.object(at: indexPath)
            self.managedObjectContext.delete(devedor)
            try! self.managedObjectContext.save()
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Diminuir") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        
        return [deleteButton]
    }
}
