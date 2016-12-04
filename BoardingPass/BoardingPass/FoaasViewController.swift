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
  
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForNotifications()
        loadFoaas()
    }
    
    func loadFoaas() {
        FoaasAPIManager.getFoaas(url: FoaasAPIManager.foaasEndpointURL) { (thisFoaas) in
            if thisFoaas != nil {
                DispatchQueue.main.async {
                    self.messageTextLabel.text = thisFoaas!.message
                    self.subtitileTextLabel.text = thisFoaas!.subtitle
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
            if let newURL = notificationBundle["url"] as? URL {
                FoaasAPIManager.foaasEndpointURL = newURL
                loadFoaas()
            }
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
