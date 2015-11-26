//
//  NextHoursViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/20/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class NextHoursViewController: UIViewController, UITableViewDataSource {
    
    var data: NSDictionary!
    var totalRows: Int! = 27
    @IBOutlet weak var next24Table: UITableView!
    
    var unit:[String: [String: String]] = ["us": ["temperature": "F", "windspeed": "mph", "dewpoint": "F", "visibility": "mi", "pressure": "mb"],
        "si": ["temperature": "C", "windspeed": "m/s", "dewpoint": "C", "visibility": "km", "pressure": "hPa"]]
    
    var imagemap:[String: String] = ["clear-day": "clear.png", "clear-night": "clear_night.png", "rain": "rain.png", "snow": "snow.png", "sleet": "sleet.png", "wind": "wind.png", "fog": "fog.png", "cloudy": "cloudy.png", "partly-cloudy-day": "cloud_day.png", "partly-cloudy-night": "cloud_night.png"]
    
    var precipitation = ["label": ["Heavy", "Moderate", "Light", "Very Light", "None"], "values": [0.4, 0.1, 0.017, 0.002, 0], "length": 5]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.data = (self.tabBarController as! TabBarController).data
    }
    
    override func viewWillAppear(animated: Bool) {
        (self.tabBarController as! TabBarController).navigationItem.title = "Next 24 Hours"
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    func convertTime(timestamp: Double, timezoneStr: String) -> String! {
        let time: NSDate! = NSDate(timeIntervalSince1970: timestamp)
        let timezone: NSDateFormatter = NSDateFormatter()
        timezone.timeZone = NSTimeZone(name: timezoneStr)
        timezone.dateFormat = "h:mm a"
        return timezone.stringFromDate(time)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = ["next24title", "next24head", "next24cell", "next48expand"]
        var cell: NextHoursViewCell!
        if (indexPath.item == 0) {
            let titleCellView: NextHoursTitleViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! NextHoursTitleViewCell
            titleCellView.next24TitleLabel.text = "More Details for " + (self.data["city"] as? String)! + ", "  + (self.data["state"] as? String)!
            return titleCellView
        }
        else if (indexPath.item == 1) {
            let headerCellView: NextHoursHeaderViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! NextHoursHeaderViewCell
            headerCellView.next24TempHeaderLabel.text = "Temp (°" + (unit[self.data!["unit"] as! String]!["temperature"])! + ")"
            return headerCellView
        }
        else if (self.totalRows == 27 && indexPath.item == 26) {
            let expandCellView: NextHoursExpandView = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[3]) as! NextHoursExpandView
            return expandCellView
        }
        else if (indexPath.item > 1) {
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[2]) as! NextHoursViewCell
            cell.next24TimeLabel.text = convertTime(((self.data["hourly"]!["data"] as! NSArray)[indexPath.item - 1] as! NSDictionary)["time"] as! Double, timezoneStr: self.data["timezone"] as! String)
            cell.next24TempLabel.text = String(format: "%.2f", ((self.data["hourly"]!["data"] as! NSArray)[indexPath.item - 1] as! NSDictionary)["temperature"] as! Float)
            cell.next24ImageView.image = UIImage(named: imagemap[((self.data["hourly"]!["data"] as! NSArray)[indexPath.item - 1] as! NSDictionary)["icon"] as! String]!)
        }
        return cell
    }
    
    
    @IBAction func expandTouchUpInside(sender: AnyObject) {
        self.totalRows = 50
        next24Table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

