//
//  DevedorTableViewController.swift
//  DevendoCoca
//
//  Created by Felipe Treichel on 28/05/2018.
//  Copyright © 2018 Felipe Treichel. All rights reserved.
//

import UIKit
import CoreData

class DevedorTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext : NSManagedObjectContext!
    var devedorListDataSource : DevedorListDataSource!
    //var devedorListDataProvider : DevedorListDataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateDevedor()
    }
    
    func populateDevedor() {
        
        self.devedorListDataSource = DevedorListDataSource(cellIdentifier: "devedorCell", tableView: self.tableView, managedObjectContext: self.managedObjectContext)
        
        tableView.dataSource = self.devedorListDataSource
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        tableView.endEditing(true)
    }
    
}
