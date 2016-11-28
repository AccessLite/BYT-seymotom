//
//  FoaasOperationsTableViewController.swift
//  BoardingPass
//
//  Created by Tom Seymour on 11/26/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class FoaasOperationsTableViewController: UITableViewController {
    
    var operations: [FoaasOperation]? = FoaasDataManager.shared.operations
    
    let operationPreviewSegueIdentifyer = "operationPreviewSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foaasOperationCell", for: indexPath)

        cell.textLabel?.text = operations?[indexPath.row].name
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
   
}
