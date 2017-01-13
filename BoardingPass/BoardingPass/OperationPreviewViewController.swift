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
    
    var originalPreviewText: String!
    
    var newFoaasMessageText: String!
    
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
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var textFieldView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = operation.name.filteredIfFilteringIsOn()
        self.pathBuilder = FoaasPathBuilder(operation: self.operation)
        registerForKeyboardNotifications()
        loadOperation(url: operationEndpoint)
        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: UIControlEvents.editingChanged)
        fromTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: UIControlEvents.editingChanged)
        referenceTextField.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: UIControlEvents.editingChanged)
        
        }

    func loadOperation(url: URL) {
        FoaasDataManager.getFoaas(url: url) { (foaas: Foaas?) in
            DispatchQueue.main.async {
                self.originalPreviewText = foaas?.description
                self.newFoaasMessageText = self.originalPreviewText
                self.previewTextView.text = self.originalPreviewText.filteredIfFilteringIsOn()
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
            originalPreviewText = newFoaasMessageText
        case fromTextField:
            self.pathBuilder?.update(key: fieldKeys[1], value: theText)
            originalPreviewText = newFoaasMessageText
        case referenceTextField:
            self.pathBuilder?.update(key: fieldKeys[2], value: theText)
            originalPreviewText = newFoaasMessageText
        default:
            break
        }
//        if let newURL = URL(string: self.foaasBaseUrl + self.pathBuilder!.build()) {
//            loadOperation(url: newURL)
//        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldWasEdited(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldWasEdited(textField)
        return true
    }
    
    func textFieldDidChange(sender: UITextField) {
        guard let fieldKeys: [String] = (self.pathBuilder?.allKeys()) else { return }
        guard let fieldDict = self.pathBuilder?.operationFields else { return }
        guard let theText = sender.text else { return }
        switch sender {
        case nameTextField:
            previewTextView.text = originalPreviewText.replacingOccurrences(of: fieldDict[fieldKeys[0]]!, with: theText).filteredIfFilteringIsOn()
            newFoaasMessageText = originalPreviewText.replacingOccurrences(of: fieldDict[fieldKeys[0]]!, with: theText)
        case fromTextField:
            previewTextView.text = originalPreviewText.replacingOccurrences(of: fieldDict[fieldKeys[1]]!, with: theText).filteredIfFilteringIsOn()
            newFoaasMessageText = originalPreviewText.replacingOccurrences(of: fieldDict[fieldKeys[1]]!, with: theText)
        case referenceTextField:
            previewTextView.text = originalPreviewText.replacingOccurrences(of: fieldDict[fieldKeys[2]]!, with: theText).filteredIfFilteringIsOn()
            newFoaasMessageText = originalPreviewText.replacingOccurrences(of: fieldDict[fieldKeys[2]]!, with: theText)
        default:
            break
        }
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if let navVc = navigationController {
            navVc.popViewController(animated: true)
        }
    }
    
    @IBAction func selectButtonPressed(_ sender: UIButton) {
//        let newURL = URL(string: "https://www.foaas.com\(self.pathBuilder!.build())".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)!
        let notification = NotificationCenter.default
//        notification.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: ["url": newURL])
        
        // send the message back too the foaas view controller as a string. Fix that shit.
        notification.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil, userInfo: ["message": newFoaasMessageText])

        self.dismiss(animated: true, completion: nil)
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
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        scrollView.scrollIndicatorInsets = scrollView.contentInset
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
