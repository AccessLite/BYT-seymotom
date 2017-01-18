//
//  FoaasSettingsMenuView.swift
//  BoardingPass
//
//  Created by Tom Seymour on 1/16/16.
//  Copyright © 2017 C4Q-3.2. All rights reserved.
//
import UIKit

protocol FoaasSettingsMenuDelegate: class {
    func didTapTwitterButton()
    func didTapFacebookButton()
    func didTapShareMessageButton()
    func didTapSaveScreenShotButton()
    func profanitySwitchDidSwitchOn()
    func profanityswitchDidSwitchOff()
}

class FoaasSettingsMenuView: UIView {
    
    @IBOutlet weak var profanitySwitch: UISwitch!
    @IBOutlet weak var shareMessageButton: UIButton!
    @IBOutlet weak var saveScreenShotButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    weak var delegate: FoaasSettingsMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let view = Bundle.main.loadNibNamed("FoaasSettingsMenuView", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
    }
    
    @IBAction func settingsMenuButtonTapped(_ sender: UIButton) {
        switch sender {
        case twitterButton:
            self.delegate?.didTapTwitterButton()
        case saveScreenShotButton:
            self.delegate?.didTapSaveScreenShotButton()
        case facebookButton:
            self.delegate?.didTapFacebookButton()
        case shareMessageButton:
            self.delegate?.didTapShareMessageButton()
        default:
            break
        }
    }
    
    @IBAction func profanitySwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            self.delegate?.profanitySwitchDidSwitchOn()
        } else {
            self.delegate?.profanityswitchDidSwitchOff()
        }
    }
    
}


