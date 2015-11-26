//
//  SelectStateTableView.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/26/15.
//  Copyright © 2015 Sickle Inc. All rights reserved.
//

import UIKit

class SelectStateTableViewController: UITableViewController {
    
    var states: Array<String>!
    var selectedIndex: Int! = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(animated: Bool) {
        let rootVC: ViewController = self.navigationController?.topViewController as! ViewController
        if (self.selectedIndex != -1) {
            rootVC.stateIndex = self.selectedIndex
            let stateIndexPath: NSIndexPath! = NSIndexPath(forItem: 2, inSection: 0)
            let stateCell: FormStateTableViewCell! = rootVC.tableView.cellForRowAtIndexPath(stateIndexPath) as! FormStateTableViewCell
            stateCell.detailTextLabel?.text = self.states[self.selectedIndex]
        }
        else {
            rootVC.stateIndex = -1
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.states.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        if (indexPath.item == selectedIndex) {
            cell = tableView.dequeueReusableCellWithIdentifier("stateSelectedCell")!
        }
        else {
            cell = tableView.dequeueReusableCellWithIdentifier("stateCell")!
        }
        cell.textLabel!.text = self.states[indexPath.item]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if (cell?.reuseIdentifier != "stateSelectedCell") {
            self.selectedIndex = indexPath.item
            tableView.reloadData()
        }
    }
    
}
