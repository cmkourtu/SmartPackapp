//
//  tagView.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 3/30/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import Foundation
import UIKit


class tagViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    // Table View
    var smartpackTableView : UITableView!
    var titleLabel : UILabel!
    var allSensorLabels : [String] = []
    var allSensorValues : [String] = []
    var tempSensorLabels : AnyObject = []
    var tempSensorValues : AnyObject = []
    var button : UIButton!
    var myTag : Int!
    
    
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor=UIColor.whiteColor()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(tagViewController.updateScreen(_:)), name: "SCREENUPDATE", object: nil)
//            
//            let view=UIView(frame: CGRectMake(20, 80, 100, 100))
//            view.backgroundColor=UIColor.yellowColor()
//            view.layer.borderColor=UIColor.blackColor().CGColor
//            view.layer.cornerRadius=25
//            view.layer.borderWidth=6
//            self.view.addSubview(view)
//            
            titleLabel = UILabel()
            titleLabel.text = "SmartPack"
            titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: self.view.frame.midX, y: self.titleLabel.bounds.midY+28)
            self.view.addSubview(titleLabel)
            
            button=UIButton(frame: CGRectMake(20, 60, self.view.frame.width-40, 60))
            button.backgroundColor=UIColor.blueColor()
            button.setTitle("View Tags", forState: .Normal)
            button.setTitleColor(UIColor.yellowColor(), forState: .Normal)
            button.alpha=0.2
            button.layer.borderWidth=0.3
            button.layer.cornerRadius=2
            button.addTarget(self, action: "pressme", forControlEvents: .TouchUpInside)
            button.titleLabel!.textAlignment=NSTextAlignment.Center
            self.view.addSubview(button)
            
            
            //************ date picker programmatically***********//
            
           
//            let textview=UITextView(frame:CGRectMake(20, 330, self.view.frame.width-40, 60))
//            textview.scrollEnabled=true
//            textview.text = "Test"
//            textview.backgroundColor=UIColor.grayColor()
//            textview.textColor=UIColor.blueColor()
//            textview.textAlignment=NSTextAlignment.Center
//            self.view.addSubview(textview)
//            
            
            allSensorValues = getSensorValues()
            allSensorLabels = getSensorLabels()
            allSensorValues[0] = String(myTag)
            
            setupsmartpackTableView()
            
            

           
        }
    
    
    /********updateScreen***********/
    
    func updateScreen(notification:NSNotification) -> Void{
        tempSensorValues = notification.userInfo!["allSensorValues" as NSObject]!
        tempSensorLabels = notification.userInfo!["allSensorLabels" as NSObject]!
        //print(temp)
    }
 
 
    
    /******* UITableViewDataSource *******/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    /******* UITableViewDelegate *******/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisCell = tableView.dequeueReusableCellWithIdentifier("sensorTagCell") as! smartpackTableViewCell
        thisCell.sensorNameLabel.text  = allSensorLabels[indexPath.row]
        
        
        let valueString = NSString(format: "%@", allSensorValues[indexPath.row])
        thisCell.sensorValueLabel.text = valueString as String
        
        return thisCell
    }
    
    
    ///////
    
    
    func getSensorLabels () -> [String] {
        let sensorLabels : [String] = [
            "Tag Name",
            "Time Last Scanned",
            "Location Last Seen",
            "Status",
        ]
        return sensorLabels
    }
    
    func getSensorValues () -> [String] {
        let sensorValues : [String] = [
            "None",
            "None",
            "None",
            "None",
        ]
        return sensorValues
    }
    
    func setupsmartpackTableView () {
        
        self.smartpackTableView = UITableView()
        self.smartpackTableView.delegate = self
        self.smartpackTableView.dataSource = self
        
        
        self.smartpackTableView.frame = CGRect(x: self.view.bounds.origin.x, y: self.button.frame.maxY+20, width: self.view.bounds.width, height: self.view.bounds.height)
        
        self.smartpackTableView.registerClass(smartpackTableViewCell.self, forCellReuseIdentifier: "sensorTagCell")
        
        self.smartpackTableView.tableFooterView = UIView() // to hide empty lines after cells
        self.view.addSubview(self.smartpackTableView)
    }

    
    
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func pressme(){
//            let alertView=UIAlertView()
//            alertView.title="RK"
//            alertView.addButtonWithTitle("OK") 
//            alertView.message="going back to first vc" 
//            
//            alertView.show() 
            
            self.navigationController!.popToRootViewControllerAnimated(true) 
            
        }
    
   
 
    
    
    
}



