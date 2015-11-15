//
//  ViewController.swift
//  Sickle
//
//  Created by Tushar Tiwari on 4/14/15.
//  Copyright (c) 2015 Sickle Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        self.view.endEditing(true)
//    }
    
    @IBOutlet weak var bgWebView: UIWebView!
    
    func loadBackground() {
        let bgPath = NSBundle.mainBundle().pathForResource("gp9OspM", ofType: "gif")
        let gif = NSData(contentsOfFile: bgPath!)
        
        bgWebView.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
    }
    
    func tableLoad() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBackground()
        tableLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

