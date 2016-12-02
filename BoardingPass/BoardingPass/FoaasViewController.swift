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
        loadFoaas()
        registerForNotifications()
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


}
