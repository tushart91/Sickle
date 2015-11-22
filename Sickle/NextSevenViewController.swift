//
//  NextSevenViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/20/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class NextSevenViewController: UIViewController, UITableViewDataSource {
    
    var data: NSDictionary!
    
    var unit:[NSString: [String: String]] = ["us": ["temperature": "F", "windspeed": "mph", "dewpoint": "F", "visibility": "mi", "pressure": "mb"],
        "si": ["temperature": "C", "windspeed": "m/s", "dewpoint": "C", "visibility": "km", "pressure": "hPa"]]
    
    var imagemap:[String: String] = ["clear-day": "clear.png", "clear-night": "clear_night.png", "rain": "rain.png", "snow": "snow.png", "sleet": "sleet.png", "wind": "wind.png", "fog": "fog.png", "cloudy": "cloudy.png", "partly-cloudy-day": "cloud_day.png", "partly-cloudy-night": "cloud_night.png"]
    
    var color: Array<Array<Float>> = [[0,0,0], [255,219,106], [160,231,255], [255,196,234], [196,255,165], [255,189,183], [239,255,181], [188,190,255]]
    
    func design() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        self.data = (self.tabBarController as! TabBarController).data
    }
    
    override func viewWillAppear(animated: Bool) {
        (self.tabBarController as! TabBarController).navigationItem.title = "Next 7 Days"
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func convertTime(timestamp: Double, timezoneStr: String) -> String! {
        var time: NSDate! = NSDate(timeIntervalSince1970: timestamp)
        let timezone: NSDateFormatter = NSDateFormatter()
        timezone.timeZone = NSTimeZone(name: timezoneStr)
        timezone.dateFormat = "EEEE, MMM dd"
        return timezone.stringFromDate(time)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = ["next7title", "next7cell"]
        var cell: NextSevenViewCell!
        if (indexPath.item == 0) {
            var titleCellView: NextSevenTitleViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[indexPath.item]) as! NextSevenTitleViewCell
            titleCellView.nextSevenTitle.text = "More Details for " + (self.data["city"] as? String)! + ", "  + (self.data["state"] as? String)!
            tableView.rowHeight = 44
            return titleCellView
        }
        if (indexPath.item > 0) {
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier[1]) as! NextSevenViewCell
            cell.layer.borderColor = UIColor.whiteColor().CGColor
            cell.layer.borderWidth = 2.0
            cell.nextSevenDate.text = convertTime(((self.data["daily"]!["data"] as! NSArray)[indexPath.item] as! NSDictionary)["time"] as! Double, timezoneStr: self.data["timezone"] as! String)
            cell.nextSevenMinMax.text = "Min: " + String(((self.data["daily"]!["data"] as! NSArray)[indexPath.item] as! NSDictionary)["temperatureMin"] as! Int) + "°" + (unit[self.data!["unit"] as! String]!["temperature"])! + " | Max: " + String(((self.data["daily"]!["data"] as! NSArray)[indexPath.item] as! NSDictionary)["temperatureMax"] as! Int) + "°" + (unit[self.data!["unit"] as! String]!["temperature"])!
            cell.nextSevenImageView.image = UIImage(named: imagemap[((self.data["daily"]!["data"] as! NSArray)[indexPath.item] as! NSDictionary)["icon"] as! String]!)
            cell.backgroundColor = UIColor(red: CGFloat(color[indexPath.item][0])/255.0, green: CGFloat(color[indexPath.item][1])/255.0, blue: CGFloat(color[indexPath.item][2])/255.0, alpha: 1)
            tableView.rowHeight = 68
        }
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

