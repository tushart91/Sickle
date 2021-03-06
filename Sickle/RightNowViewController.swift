//
//  ResultsViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/19/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit
import Darwin
import FBSDKShareKit

class RightNowViewController: UIViewController, UITableViewDataSource, FBSDKSharingDelegate {
    
    var url: String!
    var data: NSDictionary!
    var content : FBSDKShareLinkContent!
    
    var rightnow_celldata = [
        ["Precipitation", "Chance of Rain", "Wind Speed", "Dew Point", "Humidity", "Visibility", "Sunrise", "Sunset"],
        ["None", "0%", "1.23mph", "31°F", "25%", "10.00mi", "6:23AM", "6:23PM"]
    ]
    
    var unit:[String: [String: String]] = ["us": ["temperature": "F", "windspeed": "mph", "dewpoint": "F", "visibility": "mi", "pressure": "mb"],
        "si": ["temperature": "C", "windspeed": "m/s", "dewpoint": "C", "visibility": "km", "pressure": "hPa"]]
    
    var imagemap:[String: String] = ["clear-day": "clear.png", "clear-night": "clear_night.png", "rain": "rain.png", "snow": "snow.png", "sleet": "sleet.png", "wind": "wind.png", "fog": "fog.png", "cloudy": "cloudy.png", "partly-cloudy-day": "cloud_day.png", "partly-cloudy-night": "cloud_night.png"]
    
    var precipitation = ["label": ["Heavy", "Moderate", "Light", "Very Light", "None"], "values": [0.4, 0.1, 0.017, 0.002, 0], "length": 5]

    func design() {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: self.url)
        request.HTTPMethod = "GET"
        
        //        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
        //                var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
        //                self.data = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
        //                if (self.data == nil) {
        //                    println("Couldn't Load")
        //                }
        //        })
        
//        var url: NSURL = NSURL(string: self.url)!
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        let dataVal: NSData =  try! NSURLConnection.sendSynchronousRequest(request, returningResponse: response)
//        var err: NSError?
        do {
            self.data = try (NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
        } catch _ { }

        for (i, elem) in (self.precipitation["values"] as! NSArray).enumerate() {
            if ((elem as! Float) <= (self.data["currently"]!["precipIntensity"] as! Float)) {
                rightnow_celldata[1][0] = (self.precipitation["label"] as! NSArray)[i] as! String
                break
            }
        }
        
        rightnow_celldata[1][1] = Int(self.data["currently"]!["precipProbability"] as! Float * 100).description + " %"
        
        rightnow_celldata[1][2] = (self.data["currently"]!["windSpeed"] as! Float).description + " " + (unit[self.data!["unit"] as! String]!["windspeed"])!
        
        rightnow_celldata[1][3] = (self.data["currently"]!["dewPoint"] as! Float).description + " °" + (unit[self.data!["unit"] as! String]!["temperature"])!
        
        rightnow_celldata[1][4] = String(Int(round(self.data["currently"]!["humidity"] as! Float))) + " %"
        
        rightnow_celldata[1][5] = (self.data["currently"]!["visibility"] as! Float).description + " " + (unit[self.data!["unit"] as! String]!["visibility"])!
        
        rightnow_celldata[1][6] = convertTime(((self.data["daily"]!["data"] as! NSArray)[0] as! NSDictionary)["sunriseTime"] as! Double, timezoneStr: self.data["timezone"] as! String)
        
        rightnow_celldata[1][7] = convertTime(((self.data["daily"]!["data"] as! NSArray)[0] as! NSDictionary)["sunsetTime"] as! Double, timezoneStr: self.data["timezone"] as! String)
        
        self.content = FBSDKShareLinkContent()
        self.content.contentURL = NSURL(string: "http://forecast.io")
        self.content.contentTitle = "Current Weather in " + (self.data!["city"] as? String)! + ", " + (self.data!["state"] as? String)!
        self.content.contentDescription = (self.data!["currently"]!["summary"] as? String)! + ", " + String((self.data!["currently"]!["temperature"] as? Int)!) + "°" + (unit[self.data!["unit"] as! String]!["temperature"])!
        self.content.imageURL = NSURL(string: "http://sickle-env.elasticbeanstalk.com/images/" + imagemap[self.data!["currently"]!["icon"] as! String]!)
        
    }
    
    func convertTime(timestamp: Double, timezoneStr: String) -> String! {
        let time: NSDate! = NSDate(timeIntervalSince1970: timestamp)
        let timezone: NSDateFormatter = NSDateFormatter()
        timezone.timeZone = NSTimeZone(name: timezoneStr)
        timezone.dateFormat = "h:mm a"
        return timezone.stringFromDate(time)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Right Now"
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rightnow_celldata[0].count + 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = ["rightnow_nav", "rightnow_image", "rightnow_summary", "rightnow_temp", "rightnow_minmax", "rightnow_cell"]
        var cell: UITableViewCell!
        if (indexPath.item == 0) {
            let navCellView: RightNowNavViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! RightNowNavViewCell
            tableView.rowHeight = 44
            return navCellView
        }
        else if (indexPath.item == 1) {
            let imageCellView: RightNowImageViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! RightNowImageViewCell
            imageCellView.rightNowImageView.image = UIImage(named: imagemap[self.data!["currently"]!["icon"] as! String]!)
            tableView.rowHeight = 100
            return imageCellView
        }
        else if (indexPath.item == 2) {
            let summaryCell: RightNowSummaryViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! RightNowSummaryViewCell
            summaryCell.rightNowSummaryLabel.text = (self.data!["currently"]!["summary"] as? String)!  + " in " + (self.data!["city"] as? String)! + ", " + (self.data!["state"] as? String)!
            tableView.rowHeight = 44
            return summaryCell
        }
        else if (indexPath.item == 3) {
            let tempCell: RightNowTempViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! RightNowTempViewCell
            tempCell.rightNowTempLabel.text = String((self.data!["currently"]!["temperature"] as? Int)!)
            tempCell.rightNowUnitLabel.text = "°" + (unit[self.data!["unit"] as! String]!["temperature"])!
            tableView.rowHeight = 56
            return tempCell
        }
        else if (indexPath.item == 4) {
            let minmaxCell: RightNowMinMaxViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! RightNowMinMaxViewCell
            minmaxCell.rightNowMinMaxLabel.text = "L: " + String(((self.data["daily"]!["data"] as! NSArray)[0] as! NSDictionary)["temperatureMin"] as! Int) + "° | H: " + String(((self.data["daily"]!["data"] as! NSArray)[0] as! NSDictionary)["temperatureMax"] as! Int) + "°"
            tableView.rowHeight = 44
            return minmaxCell
        }
        else if (indexPath.item > 4) {
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[5])!
            cell.textLabel?.text = rightnow_celldata[0][indexPath.item - 5]
            cell.detailTextLabel?.text = rightnow_celldata[1][indexPath.item - 5]
            tableView.rowHeight = 44
        }
        return cell
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        var message: String! = "Post Successful"
        if (results.isEmpty) {
            message = "Post Cancelled"
        }
        let toastMessage: UIAlertView! = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "Dismiss")
        toastMessage.show()
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
    }
    
    @IBAction func shareButtonTouchUpInside(sender: AnyObject) {
        FBSDKShareDialog.showFromViewController(self, withContent: self.content, delegate: self)
    }
    
    @IBAction func mapButtonTouchUpInside(sender: AnyObject) {
        self.performSegueWithIdentifier("mapSegue", sender: nil)
    }
    
    @IBAction func moreDetailsAction(sender: UIButton) {
        self.performSegueWithIdentifier("detailsSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "detailsSegue") {
            let detailsVC = segue.destinationViewController as! TabBarController
            detailsVC.data = self.data as NSDictionary
        }
        if (segue.identifier == "mapSegue") {
            let mapVC = segue.destinationViewController as! MapViewController
            mapVC.data = self.data as NSDictionary!
            
        }
    }
    
}
