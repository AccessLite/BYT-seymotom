//
//  OperationPreviewViewController.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/27/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

/*
 ▿ Optional(BoardingPass.FoaasOperation)
 ▿ some: BoardingPass.FoaasOperation #0
 - name: "Can I Use"
 - url: "/caniuse/:tool/:from"
 ▿ fields: 2 elements
 ▿ Name: Tool
 Field: tool #1
 - name: "Tool"
 - field: "tool"
 ▿ Name: From
 Field: from #2
 - name: "From"
 - field: "from"

 */

import UIKit

class OperationPreviewViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Properties
    var operation: FoaasOperation!
    
    var uri: String {
        return operation.url
    }
    
    var operationEndpoint: URL {
        return URL(string: "https://www.foaas.com\(uri)")!
    }
    
    private var updatedURI = ""
    
    //MARK: Outlets
    
    @IBOutlet weak var previewTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var referenceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadOperation(url: operationEndpoint)
    }

    func loadOperation(url: URL) {
        previewTextView.text = operation.name
        FoaasAPIManager.getFoaas(url: url) { (foaas: Foaas?) in
            DispatchQueue.main.async {
                self.previewTextView.text = foaas?.description
                switch self.operation.fields.count {
                case 1:
                    self.nameLabel.text = "<\(self.operation.fields[0].name.lowercased())>"
                    self.nameTextField.placeholder = "\(self.operation.fields[0].name.lowercased())"
                    self.fromLabel.isHidden = true
                    self.fromTextField.isHidden = true
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 2:
                    self.nameLabel.text = "<\(self.operation.fields[0].name.lowercased())>"
                    self.nameTextField.placeholder = "\(self.operation.fields[0].name.lowercased())"
                    self.fromLabel.text = "<\(self.operation.fields[1].name.lowercased())>"
                    self.fromTextField.placeholder = "\(self.operation.fields[1].name.lowercased())"
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 3:
                    self.nameLabel.text = "<\(self.operation.fields[0].name.lowercased())>"
                    self.nameTextField.placeholder = "\(self.operation.fields[0].name.lowercased())"
                    self.fromLabel.text = "<\(self.operation.fields[1].name.lowercased())>"
                    self.fromTextField.placeholder = "\(self.operation.fields[1].name.lowercased())"
                    self.referenceLabel.text = "<\(self.operation.fields[2].name.lowercased())>"
                    self.referenceTextField.placeholder = "\(self.operation.fields[2].name.lowercased())"
                default:
                    print("fields array out of range")
                    break
                }
            }
        }
    }
    
    func updateTextFields(_ textField: UITextField) {
        guard let theText = textField.text else { return }
        switch textField {
        case nameTextField:
            let newUri = operation.url.replacingOccurrences(of: ":\(self.operation.fields[0].name.lowercased())", with: theText)
            //I WANT TO SAVE THESE UPDATED URI'S IN THE VIEWCONTROLLER, NOT THE OBJECT.... BUT STRUGGLING
            self.updatedURI = newUri
            if let newURL = URL(string: "https://www.foaas.com\(newUri)") {
                loadOperation(url: newURL)
            }
        case fromTextField:
            let newUri = operation.url.replacingOccurrences(of: ":\(self.operation.fields[1].name.lowercased())", with: theText)
            self.updatedURI = newUri
            if let newURL = URL(string: "https://www.foaas.com\(newUri)") {
                loadOperation(url: newURL)
            }
        case referenceTextField:
            let newUri = operation.url.replacingOccurrences(of: ":\(self.operation.fields[2].name.lowercased())", with: theText)
            self.updatedURI = newUri
            if let newURL = URL(string: "https://www.foaas.com\(newUri)") {
                loadOperation(url: newURL)
            }
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFields(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        updateTextFields(textField)
        return true
    }
    
    
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        //pass value foaas back to FoaasVC
        let newURL = URL(string: "https://www.foaas.com\(self.updatedURI)")
        let notification = NotificationCenter.default
        notification.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: ["url": newURL])
         self.dismiss(animated: true, completion: nil)
    }
    
    
}
