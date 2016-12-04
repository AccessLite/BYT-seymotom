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
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatedURI = operation.url
        loadOperation(url: operationEndpoint)
        registerForKeyboardNotifications()
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
    
    /*
     It seems you lean towards defensive coding practices, which is frankly a great instinct to have. Your app
     adverts crashing in several places by using conditional binding and avoiding force-unwraps. All other submissions
     I've seen have the same bugs your code has, but their app will crash - which is not Swift-y.
     
     Well done, and keep at this particular skill.
     
     
     However, this function doesn't keep track of all of the changes for all fields. Tabbing through fields results in the 
     URL resettign for the other fields. This is a violation of week 1 spec in that you are not returning a fully-formed and 
     valid URL back to your FoaasViewController. This is a critical bug in terms of MVP.
     */
    func updateTextFields(_ textField: UITextField) {
        // textField text can be non-nil, but still an empty string.
        // So you'll get an error if you tab through text fields
        // without filling them in with text. Making this extra guard check necessary
        guard let theText = textField.text, theText.characters.count > 0 else { return }
        switch textField {
        case nameTextField:
            let newUri = updatedURI.replacingOccurrences(of: ":\(self.operation.fields[0].name.lowercased())", with: theText)
            //I WANT TO SAVE THESE UPDATED URI'S IN THE VIEWCONTROLLER, NOT THE OBJECT.... BUT STRUGGLING
            self.updatedURI = newUri
            if let newURL = URL(string: "https://www.foaas.com\(self.updatedURI)") {
                loadOperation(url: newURL)
            }
        case fromTextField:
            let newUri = updatedURI.replacingOccurrences(of: ":\(self.operation.fields[1].name.lowercased())", with: theText)
            self.updatedURI = newUri
            if let newURL = URL(string: "https://www.foaas.com\(self.updatedURI)") {
                loadOperation(url: newURL)
            }
        case referenceTextField:
            let newUri = updatedURI.replacingOccurrences(of: ":\(self.operation.fields[2].name.lowercased())", with: theText)
            self.updatedURI = newUri
            if let newURL = URL(string: "https://www.foaas.com\(self.updatedURI)") {
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
        let newURL = URL(string: "https://www.foaas.com\(self.updatedURI)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)!
        let notification = NotificationCenter.default
        notification.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: ["url": newURL])
         self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK : KEYBOARD NOTIFICATION
    
    func registerForKeyboardNotifications() {
        // register the notifications here
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        scrollViewBottomConstraint.constant = keyboardHeight!        
        print("hello keyboard")
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollViewBottomConstraint.constant = 0
        print("goodbye keyboard")
    }
    
    
}
