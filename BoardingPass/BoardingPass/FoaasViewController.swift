//
//  FoaasViewController.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/26/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

// Clean, simple view controller. I like it. 
class FoaasViewController: UIViewController {
  
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var subtitileTextLabel: UILabel!
  
    private var foaasMessageString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        loadFoaas()
        FoaasDataManager.shared.requestOperations { (operations) in
            //not sure what to do here
        }
    }
    
    func loadFoaas() {
        FoaasDataManager.getFoaas(url: FoaasDataManager.foaasEndpointURL) { (thisFoaas) in
            if thisFoaas != nil {
               self.foaasMessageString = "\(thisFoaas!.message) \(thisFoaas!.subtitle)"
                print(">>>" + self.foaasMessageString)
                DispatchQueue.main.async {
                    self.messageTextLabel.text = thisFoaas!.message.filteredIfFilteringIsOn()
                    self.subtitileTextLabel.text = thisFoaas!.subtitle.filteredIfFilteringIsOn()
                }
            }
        }
    }
    
  
    // MARK: Notifications
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        // parse out sender.userInfo as needed
        
        
        if let notificationBundle = sender.userInfo {
//            if let newURL = notificationBundle["url"] as? URL {
//                FoaasDataManager.foaasEndpointURL = newURL
//                loadFoaas()
//            }
            if let newMessageString = notificationBundle["message"] as? String {
                var splitMessage = newMessageString.components(separatedBy: "-")
                if let subtitle = splitMessage.popLast() {
                    print("Subtitle:  -\(subtitle)")
                    let message = splitMessage.reduce("", { $0 == "" ? $1 : $0 + "-" + $1 })
                    print("Message:  \(message)")
                    
                    self.messageTextLabel.text = message.filteredIfFilteringIsOn()
                    self.subtitileTextLabel.text = "-" + subtitle.filteredIfFilteringIsOn()
                }
            }
        }
    }
    
    
    // MARK: Long Press Screenshot
    
    @IBAction func didPressLong(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            // Start the context
            UIGraphicsBeginImageContext(self.view.frame.size)
            // Draw the view into the context (this is the snapshot)
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            let snapshot = UIGraphicsGetImageFromCurrentImageContext()
            // End the context (this is required to not leak resources)
            UIGraphicsEndImageContext()
            // Save to photos
            if let unwrappedSnapshot = snapshot {
                UIImageWriteToSavedPhotosAlbum(unwrappedSnapshot, self, #selector(createScreenShotCompletion(image:didFinishSavingWithError:contextInfo:)), nil)
            }
            print("Screenshot")
        }
    }
    
    // command + option + /
    /// <#Description#>
    ///
    /// - Parameters:
    ///   - image: <#image description#>
    ///   - didFinishSavingWithError: <#didFinishSavingWithError description#>
    ///   - contextInfo: <#contextInfo description#>
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        if let _ = didFinishSavingWithError {
            showAlertView(message: "Screenshot failed to save")
        }
        else {
            showAlertView(message: "Screenshot saved sucessfully")
        }
    }
    
    func showAlertView(message: String) {
        let myAlert = UIAlertController(title: "ScreenShot", message: message, preferredStyle: .alert)
        let myAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        myAlert.addAction(myAlertAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
    // MARK: Tap Gesture Messaging
    
    @IBAction func didRecognizeTap(_ sender: UITapGestureRecognizer) {
        if let theMessage = self.foaasMessageString {
            
            let activityViewController = UIActivityViewController(activityItems: [theMessage], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    // MARK: Button Animation
    
    @IBAction func octoButtonTapped(_ sender: UIButton) {
        let newTransform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        let originalTransform = sender.imageView!.transform
        UIView.animate(withDuration: 0.1, animations: {
            // animate to newTransform
            sender.transform = newTransform
            }, completion: { (complete) in
                // return to original transform
                sender.transform = originalTransform
        })
    }


}
