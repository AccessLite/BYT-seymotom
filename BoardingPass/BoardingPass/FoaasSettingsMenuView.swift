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
    func colorSchemeDidUpdate(color: UIColor)
}

class FoaasSettingsMenuView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var profanitySwitch: UISwitch!
    @IBOutlet weak var shareMessageButton: UIButton!
    @IBOutlet weak var saveScreenShotButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    weak var delegate: FoaasSettingsMenuDelegate?
    
    private let colors: [UIColor] = [.red, .blue, .green, .yellow, .purple, .orange]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let view = Bundle.main.loadNibNamed("FoaasSettingsMenuView", owner: self, options: nil)?.first as? UIView {
            self.addSubview(view)
            view.frame = self.bounds
        }
        let nib = UINib(nibName: "ColorCollectionViewCell", bundle: nil)
        colorCollectionView.register(nib, forCellWithReuseIdentifier: "colorCellIdentifier")
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
    }
    
    
    
    // MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCellIdentifier", for: indexPath) as! ColorCollectionViewCell
        cell.colorView.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.colorSchemeDidUpdate(color: colors[indexPath.row])
    }
    
    
    
    // MARK: - Collection View Flow Layout
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableHeight = collectionView.frame.height
        
        return CGSize(width: availableHeight * 1.8, height: availableHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
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


