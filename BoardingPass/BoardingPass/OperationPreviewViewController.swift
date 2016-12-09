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
    private let foaasBaseUrl = "https://www.foaas.com"
    var operation: FoaasOperation!
    private var pathBuilder: FoaasPathBuilder?
    
    private var uri: String {
        return operation.url
    }
    
    var operationEndpoint: URL {
        return URL(string: foaasBaseUrl + uri)!
    }
    
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
        navigationItem.title = operation.name.filteredIfFilteringIsOn()
        self.pathBuilder = FoaasPathBuilder(operation: self.operation)
        registerForKeyboardNotifications()
        loadOperation(url: operationEndpoint)
    }

    func loadOperation(url: URL) {
        FoaasDataManager.getFoaas(url: url) { (foaas: Foaas?) in
            DispatchQueue.main.async {
                self.previewTextView.text = foaas?.description.filteredIfFilteringIsOn()
                guard let fieldKeys: [String] = (self.pathBuilder?.allKeys()) else { return }
                switch self.operation.fields.count {
                case 1:
                    self.nameLabel.text = "<\(fieldKeys[0])>"
                    self.nameTextField.placeholder = fieldKeys[0]
                    self.fromLabel.isHidden = true
                    self.fromTextField.isHidden = true
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 2:
                    self.nameLabel.text = "<\(fieldKeys[0])>"
                    self.nameTextField.placeholder = fieldKeys[0]
                    self.fromLabel.text = "<\(fieldKeys[1])>"
                    self.fromTextField.placeholder = "\(fieldKeys[1])"
                    self.referenceLabel.isHidden = true
                    self.referenceTextField.isHidden = true
                case 3:
                    self.nameLabel.text = "<\(fieldKeys[0])>"
                    self.nameTextField.placeholder = fieldKeys[0]
                    self.fromLabel.text = "<\(fieldKeys[1])>"
                    self.fromTextField.placeholder = "\(fieldKeys[1])"
                    self.referenceLabel.text = "<\(fieldKeys[2])>"
                    self.referenceTextField.placeholder = "\(fieldKeys[2])"
                default:
                    print("fields array out of range")
                    break
                }
            }
        }
    }
    
    func textFieldWasEdited(_ textField: UITextField) {
        guard let fieldKeys: [String] = (self.pathBuilder?.allKeys()) else { return }
        guard let theText = textField.text, theText.characters.count > 0 else { return }
        switch textField {
        case nameTextField:
            self.pathBuilder?.update(key: fieldKeys[0], value: theText)
        case fromTextField:
            self.pathBuilder?.update(key: fieldKeys[1], value: theText)
        case referenceTextField:
            self.pathBuilder?.update(key: fieldKeys[2], value: theText)
        default:
            break
        }
        if let newURL = URL(string: self.foaasBaseUrl + self.pathBuilder!.build()) {
            loadOperation(url: newURL)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldWasEdited(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldWasEdited(textField)
        return true
    }
    
    
    //passes foaas back to FoaasVC
    @IBAction func selectButtonTapped(_ sender: UIBarButtonItem) {
        let newURL = URL(string: "https://www.foaas.com\(self.pathBuilder!.build())".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)!
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
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollViewBottomConstraint.constant = 0
    }
    
    @IBAction func didRecognizeTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
}
