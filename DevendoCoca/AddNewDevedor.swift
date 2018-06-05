//
//  AddNewDevedor.swift
//  DevendoCoca
//
//  Created by Felipe Treichel on 28/05/2018.
//  Copyright © 2018 Felipe Treichel. All rights reserved.
//

import UIKit

class AddNewDevedorView : UIView, UITextFieldDelegate {
    
    let placeholder: String
    var addNewDevedorViewClosure: (String) -> ()

    
    init(frame: CGRect, placeholder: String, addNewDevedorViewClosure: @escaping (String) -> ()) {
        self.placeholder = placeholder
        self.addNewDevedorViewClosure = addNewDevedorViewClosure
        
        super.init(frame: frame)
        
        setup()
    }
    
    private func setup() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))
        headerView.backgroundColor = UIColor.lightText
        
        let textField = UITextField(frame: headerView.frame)
        textField.placeholder = self.placeholder
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        headerView.addSubview(textField)
        
        self.addSubview(headerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text!
        
        self.addNewDevedorViewClosure(text)
        
        textField.text = ""
        return textField.resignFirstResponder()
    }
}
