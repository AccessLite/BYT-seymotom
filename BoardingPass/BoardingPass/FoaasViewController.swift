//
//  FoaasViewController.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/26/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

// Clean, simple view controller. I like it. 
class FoaasViewController: UIViewController, FoaasSettingsMenuDelegate {
  
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var subtitileTextLabel: UILabel!
    
    @IBOutlet weak var foaasView: UIView!
    @IBOutlet weak var settingsView: FoaasSettingsMenuView!
    @IBOutlet weak var foaasViewCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var settingsViewBaselineConstraint: NSLayoutConstraint!
  
    private var foaasFullString: String!
    private var foaasMessage: String!
    private var foaasSubtitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        loadFoaas()
        FoaasDataManager.shared.requestOperations { (operations) in
            //not sure what to do here
        }
        settingsView.delegate = self        
    }
    
    func loadFoaas() {
        FoaasDataManager.getFoaas(url: FoaasDataManager.foaasEndpointURL) { (thisFoaas) in
            if thisFoaas != nil {
               self.foaasFullString = "\(thisFoaas!.message) \(thisFoaas!.subtitle)"
                print(">>>" + self.foaasFullString)
                DispatchQueue.main.async {
                    self.foaasMessage = thisFoaas!.message
                    self.foaasSubtitle = thisFoaas!.subtitle
                    self.reloadLabels()
                }
            }
        }
    }
    
    //MARK: - Update Text Labels
    
    func reloadLabels() {
        messageTextLabel.text = foaasMessage.filteredIfFilteringIsOn()
        subtitileTextLabel.text = foaasSubtitle.filteredIfFilteringIsOn()
    }
    
  
    // MARK: Notifications
    
    internal func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    internal func updateFoaas(sender: Notification) {
        if let notificationBundle = sender.userInfo {
            if let newMessageString = notificationBundle["message"] as? String {
                self.foaasFullString = newMessageString
                var splitMessage = newMessageString.components(separatedBy: "\n")
                if let subtitle = splitMessage.popLast() {
                    let message = splitMessage.reduce("", +)
                    self.foaasSubtitle = subtitle
                    self.foaasMessage = message
                    reloadLabels()
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
    
    
    
    // MARK: - Settings Menu Animations

    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        if self.foaasView.center.y == self.view.center.y {
            animateFoaasViewTo(centerYConstant: -(self.settingsView.frame.height))
            animateSettingsViewTo(baselineConstant: 0)
        } else if self.foaasView.center.y != self.view.center.y {
            animateFoaasViewTo(centerYConstant: 0)
            animateSettingsViewTo(baselineConstant: -100)
        }
    }

    @IBAction func didSwipeUp(_ sender: UISwipeGestureRecognizer) {
        if self.foaasView.center.y == self.view.center.y {
            animateFoaasViewTo(centerYConstant: -(self.settingsView.frame.height))
            animateSettingsViewTo(baselineConstant: 0)
        }
    }
    
    @IBAction func didSwipeDown(_ sender: UISwipeGestureRecognizer) {
        if self.foaasView.center.y != self.view.center.y {
            animateFoaasViewTo(centerYConstant: 0)
            animateSettingsViewTo(baselineConstant: -100)
        }
    }
    
    func animateFoaasViewTo(centerYConstant: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.foaasViewCenterYConstraint.constant = centerYConstant
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    
    func animateSettingsViewTo(baselineConstant: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0.1, usingSpringWithDamping: 0.9, initialSpringVelocity: 5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.settingsViewBaselineConstraint.constant = baselineConstant
            self.view.layoutIfNeeded()
        }) { _ in
        }
    }
    
    // MARK: - Settings Menu Delegate Methods
    
    func didTapTwitterButton() {
        print("twitter")
    }
    
    func didTapFacebookButton() {
        print("facebook")
    }
    
    func didTapShareMessageButton() {
        if let theMessage = self.foaasFullString {

            let activityViewController = UIActivityViewController(activityItems: [theMessage], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func didTapSaveScreenShotButton() {
         print("camera roll")
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
    
    func profanitySwitchDidSwitchOn() {
        FoaasDataManager.shared.filter = .isOn
        reloadLabels()
    }
    
    func profanityswitchDidSwitchOff() {
        FoaasDataManager.shared.filter = .isOff
        reloadLabels()
    }
    
    func colorSchemeDidUpdate(color: UIColor) {
        self.foaasView.backgroundColor = color
    }
    
    
}
