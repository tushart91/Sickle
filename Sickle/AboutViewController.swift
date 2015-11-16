//
//  AboutController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 11/15/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var bgWebView: UIWebView!
    @IBOutlet weak var aboutImage: UIImageView!
    
    func loadBackground() {
        let bgPath = NSBundle.mainBundle().pathForResource("zyADLpF", ofType: "gif")
        let gif = NSData(contentsOfFile: bgPath!)
        
        bgWebView.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
    }
    
    func design() {
        aboutImage.layer.cornerRadius = 75.0
        aboutImage.layer.masksToBounds = true
        aboutImage.layer.borderColor = UIColor.grayColor().CGColor
        aboutImage.layer.borderWidth = 1
        aboutImage.clipsToBounds = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBackground()
        design()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}