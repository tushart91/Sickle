//
//  ViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 4/14/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    let pickerData = [[
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
        ],[
            "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"
        ]
    ]
    
    let temperature = ["us", "si"]
    
    var url: NSString!
    var stateIndex: Int! = -1
    
    @IBOutlet weak var bgWebView: UIWebView!
    @IBOutlet weak var poweredByButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func aboutButton(sender: UIButton) {
        self.performSegueWithIdentifier("aboutSegue", sender: nil)
    }
    func loadBackground() {
        let bgPath = NSBundle.mainBundle().pathForResource("gp9OspM", ofType: "gif")
        let gif = NSData(contentsOfFile: bgPath!)
        
        bgWebView.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
    }
    
    func design() {
        poweredByButton.layer.cornerRadius = 4.0
        poweredByButton.layer.borderColor = UIColor.grayColor().CGColor
        poweredByButton.layer.borderWidth = 0.3
        poweredByButton.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBackground()
        design()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "rightNowSegue") {
            let detailVC = segue.destinationViewController as! RightNowViewController
            detailVC.url = self.url as String
        }
        else if (segue.identifier == "stateSegue") {
            let stateTVC = segue.destinationViewController as! SelectStateTableViewController
            stateTVC.states = self.pickerData[0]
            stateTVC.selectedIndex = self.stateIndex
        }
    }

    @IBAction func forecastURL(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.forecast.io")!)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = ["formAddress", "formAddress", "formState", "formDegree", "formButtons"]
        let cell: UITableViewCell! = UITableViewCell()
        
        if (indexPath.item == 0) {
            let formCell: FormAddressTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! FormAddressTableViewCell
            formCell.formAddressLabel.text = "Street"
            formCell.formAddressTextField.placeholder = "Enter Street Address"
            return formCell
        }
        else if (indexPath.item == 1) {
            let formCell: FormAddressTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! FormAddressTableViewCell
            formCell.formAddressLabel.text = "City"
            formCell.formAddressTextField.placeholder = "Enter City"
            return formCell
        }
        else if (indexPath.item == 2) {
            let formCell: FormStateTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! FormStateTableViewCell
            formCell.formStateLabel.text = "State"
            formCell.formStateChosenLabel.text = "Select"
            return formCell
        }
        else if (indexPath.item == 3) {
            let formCell: FormDegreeTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! FormDegreeTableViewCell
            formCell.formDegreeLabel.text = "Degree"
            return formCell
        }
        else if (indexPath.item == 4) {
            let formCell: FormButtonsTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! FormButtonsTableViewCell
            formCell.formSearchButton.layer.cornerRadius = 4.0
            formCell.formSearchButton.layer.borderColor = UIColor.grayColor().CGColor
            formCell.formSearchButton.layer.borderWidth = 0.3
            formCell.formSearchButton.clipsToBounds = true

            formCell.formClearButton.layer.cornerRadius = 4.0
            formCell.formClearButton.layer.borderColor = UIColor.grayColor().CGColor
            formCell.formClearButton.layer.borderWidth = 0.3
            formCell.formClearButton.clipsToBounds = true
            
            return formCell
        }
        
        return cell
    }
    
    @IBAction func formSearchTouchUpInside(sender: AnyObject) {
        
        let addressIndexPath: NSIndexPath! = NSIndexPath(forItem: 0, inSection: 0)
        var cell: FormAddressTableViewCell! = self.tableView.cellForRowAtIndexPath(addressIndexPath) as! FormAddressTableViewCell
        cell.formAddressTextField.resignFirstResponder()
        let address: String! = cell.formAddressTextField.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        if (address == "") {
            errorLabel.text = "Please Enter Street Address"
            return
        }
        
        let cityIndexPath: NSIndexPath! = NSIndexPath(forItem: 1, inSection: 0)
        cell = self.tableView.cellForRowAtIndexPath(cityIndexPath) as! FormAddressTableViewCell
        cell.formAddressTextField.resignFirstResponder()
        let city: String! = cell.formAddressTextField.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        if (city == "") {
            errorLabel.text = "Please Enter City"
            return
        }

        if (self.stateIndex == -1) {
            errorLabel.text = "Please Choose a State"
            return
        }
        let state: String! = pickerData[1][self.stateIndex]
        errorLabel.text = ""
        
        let degreeIndexPath: NSIndexPath! = NSIndexPath(forItem: 3, inSection: 0)
        let degreeCell: FormDegreeTableViewCell! = self.tableView.cellForRowAtIndexPath(degreeIndexPath) as! FormDegreeTableViewCell
        let unit: String! = temperature[degreeCell.formDegreeSegmentedControl.selectedSegmentIndex]
        
        self.url = "http://sickle-env.elasticbeanstalk.com/index.php?" +
            "address=" + address + "&city=" + city + "&state=" + state + "&unit=" + unit
        print(self.url)
//        self.url = "http://sickle-env.elasticbeanstalk.com/index.php?address=1282%20W%2029th%20St&city=Los%20Angeles&state=CA&unit=us"
        self.performSegueWithIdentifier("rightNowSegue", sender: nil)
        
    }
    
    @IBAction func formClearTouchUpInside(sender: AnyObject) {
        let addressIndexPath: NSIndexPath! = NSIndexPath(forItem: 0, inSection: 0)
        var cell: FormAddressTableViewCell! = self.tableView.cellForRowAtIndexPath(addressIndexPath) as! FormAddressTableViewCell
        cell.formAddressTextField.text = ""
        
        let cityIndexPath: NSIndexPath! = NSIndexPath(forItem: 1, inSection: 0)
        cell = self.tableView.cellForRowAtIndexPath(cityIndexPath) as! FormAddressTableViewCell
        cell.formAddressTextField.text = ""
        
        self.stateIndex = -1
        let stateIndexPath: NSIndexPath! = NSIndexPath(forItem: 2, inSection: 0)
        let stateCell: FormStateTableViewCell! = self.tableView.cellForRowAtIndexPath(stateIndexPath) as! FormStateTableViewCell
        stateCell.detailTextLabel?.text = "Select"
        
        let degreeIndexPath: NSIndexPath! = NSIndexPath(forItem: 3, inSection: 0)
        let degreeCell: FormDegreeTableViewCell! = self.tableView.cellForRowAtIndexPath(degreeIndexPath) as! FormDegreeTableViewCell
        degreeCell.formDegreeSegmentedControl.selectedSegmentIndex = 0
        
        errorLabel.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

