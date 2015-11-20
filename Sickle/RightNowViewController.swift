//
//  ResultsViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/19/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class RightNowViewController: UIViewController {
    
    var data: NSDictionary!
    
    func design() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        design()
        self.data = (self.tabBarController as! TabBarController).data
        println("In Results: \(self.data)")
    }
    
    override func viewWillAppear(animated: Bool) {
        (self.tabBarController as! TabBarController).navigationItem.title = "Right Now"
    }
    
    override func viewWillDisappear(animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
