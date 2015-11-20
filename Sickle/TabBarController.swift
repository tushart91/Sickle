//
//  TabBarController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/19/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var url: String!
    var data: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: self.url)
        request.HTTPMethod = "GET"
        
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
//                self.data = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: error) as? NSDictionary
//                if (self.data == nil) {
//                    println("Couldn't Load")
//                }
//        })
        
        var url: NSURL = NSURL(string: self.url)!
//        var request: NSURLRequest = NSURLRequest(URL: url)
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)!
        var err: NSError?
        self.data = (NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
