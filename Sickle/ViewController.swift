//
//  ViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 4/14/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    let pickerData = [[
            "Select State", "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "District of Columbia", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"
        ],[
            "", "AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA", "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME", "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM", "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VA", "VT", "WA", "WI", "WV", "WY"
        ]
    ]
    
    let temperature = ["us", "si"]
    
    @IBOutlet weak var bgWebView: UIWebView!
    @IBOutlet weak var statePicker: UIPickerView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var poweredByButton: UIButton!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var temperatureSelector: UISegmentedControl!
    
    var url: NSString!
    
    @IBAction func aboutButton(sender: UIButton) {
        self.performSegueWithIdentifier("aboutSegue", sender: nil)
    }
    func loadBackground() {
        let bgPath = NSBundle.mainBundle().pathForResource("gp9OspM", ofType: "gif")
        let gif = NSData(contentsOfFile: bgPath!)
        
        bgWebView.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
    }
    
    func design() {
        statePicker.dataSource = self
        statePicker.delegate = self
        statePicker.layer.cornerRadius = 6.0
        statePicker.layer.borderColor = UIColor.grayColor().CGColor
        statePicker.layer.borderWidth = 0.5
        statePicker.clipsToBounds = true
        statePicker.alpha = 0.8
        
        searchButton.layer.cornerRadius = 4.0
        searchButton.layer.borderColor = UIColor.grayColor().CGColor
        searchButton.layer.borderWidth = 0.3
        searchButton.clipsToBounds = true
        
        clearButton.layer.cornerRadius = 4.0
        clearButton.layer.borderColor = UIColor.grayColor().CGColor
        clearButton.layer.borderWidth = 0.3
        clearButton.clipsToBounds = true
        
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
    
    @IBAction func searchButton(sender: AnyObject) {
        var address: String! = addressTextField.text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        var city: String! = cityTextField.text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        var state: String! = pickerData[1][statePicker.selectedRowInComponent(0)]
        var unit: String! = temperature[temperatureSelector.selectedSegmentIndex]
        self.url = "http://sickle-env.elasticbeanstalk.com/index.php?" +
            "address=" + address + "&city=" + city + "&state=" + state + "&unit=" + unit
        self.url = "http://sickle-env.elasticbeanstalk.com/index.php?address=1282%20W%2029th%20St&city=Los%20Angeles&state=CA&unit=us"
        self.performSegueWithIdentifier("resultSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "resultSegue") {
            var detailVC = segue.destinationViewController as! TabBarController
            detailVC.url = self.url as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func forecastURL(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.forecast.io")!)
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[0].count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[0][row]
    }
}

