//
//  FoaasOperationsTableViewController.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/26/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

// Convetion can be: 
// Single line between functions
// Double line before a MARK

/*
 Top of the file:
 var floatingButton: UIButton = UIButton()
 
 In viewDidLoad:
 //Set Up Floating Button
 self.floatingButton = UIButton(type: .custom)
 self.floatingButton.addTarget(self, action: #selector(floatingButtonClicked), for: UIControlEvents.touchUpInside)
 self.view.addSubview(floatingButton)
 
 //Functions
 override func viewWillLayoutSubviews() {
 floatingButton.clipsToBounds = true
 floatingButton.setImage(#imageLiteral(resourceName: "Close Button"), for: .normal)
 
 floatingButton.translatesAutoresizingMaskIntoConstraints = false
 let _ = [
 floatingButton.trailingAnchor.constraint(equalTo: (tableView.superview?.trailingAnchor)!, constant: -30.0),
 floatingButton.bottomAnchor.constraint(equalTo: (tableView.superview?.bottomAnchor)!, constant: -30.0),
 floatingButton.widthAnchor.constraint(equalToConstant: 50.0),
 floatingButton.heightAnchor.constraint(equalToConstant: 54.0)
 ].map { $0.isActive = true }
 }
 
 func floatingButtonClicked() {
 dismiss(animated: true, completion: nil)
 }
 */

class FoaasOperationsTableViewController: UITableViewController {
    
    var operations: [FoaasOperation]? = FoaasDataManager.shared.operations
    let operationPreviewSegueIdentifyer = "operationPreviewSegue"
    
    var floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(floatingButtonClicked), for: UIControlEvents.touchUpInside)
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "Close Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(floatingButton)
    }
    
    override func viewWillLayoutSubviews() {
        let _ = [
            floatingButton.trailingAnchor.constraint(equalTo: (tableView.superview?.trailingAnchor)!, constant: -20.0),
            floatingButton.bottomAnchor.constraint(equalTo: (tableView.superview?.bottomAnchor)!, constant: -20.0),
            floatingButton.widthAnchor.constraint(equalToConstant: 60.0),
            floatingButton.heightAnchor.constraint(equalToConstant: 60.0)
            ].map { $0.isActive = true }
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations?.count ?? 0 // well done. the bigger mistake is causing your app to crash (from a UX perspective), but with a nil-coalescing op you effectively prevent it even with your loading/saving bug on first launch
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foaasOperationCell", for: indexPath)
        cell.textLabel?.text = operations?[indexPath.row].name.filteredIfFilteringIsOn()
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFontWeightBold)
        return cell
    }

    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == operationPreviewSegueIdentifyer {
            if let operationPreviewVC = segue.destination as? OperationPreviewViewController {
                if let selectedCell = sender as? UITableViewCell {
                    if let indexPath = tableView.indexPath(for: selectedCell) {
                        operationPreviewVC.operation = operations?[(indexPath.row)]
                        
                    }
                }
            }
        }
    }
    
    
    func floatingButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
   
}
