//
//  DevedorListDataSource.swift
//  DevendoCoca
//
//  Created by Felipe Treichel on 28/05/2018.
//  Copyright © 2018 Felipe Treichel. All rights reserved.
//

import UIKit
import CoreData

class DevedorListDataSource : NSObject, UITableViewDataSource, UITableViewDelegate, DevedorListDataProviderDelegate {
    
    var cellIdentifier: String
    var tableView: UITableView
    var devedorListDataProvider: DevedorListDataProvider
    var managedObjectContext : NSManagedObjectContext
    
    init(cellIdentifier: String, tableView: UITableView, managedObjectContext: NSManagedObjectContext){
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
        self.managedObjectContext = managedObjectContext
        self.devedorListDataProvider = DevedorListDataProvider(self.managedObjectContext)
        
        super.init()
        
        self.devedorListDataProvider.delegate = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor.clear
    }

    func devedorListDataProviderDidInsert(indexPath: IndexPath) {
        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func devedorListDataProviderDidDelete(indexPath: IndexPath) {
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.devedorListDataProvider.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DevedorCell
        cell.setupCell()
        
        cell.delegate = self.devedorListDataProvider
        cell.devedor = self.devedorListDataProvider.object(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AddNewDevedorView(frame: tableView.frame, placeholder: "Adicionar vacilão") { (nome) in
            self.devedorListDataProvider.addDevedor(nome: nome)
        }
        return view
    }
    
}
