//
//  tagView.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 3/30/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import Foundation
import UIKit


class tagViewController: UIViewController {
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor=UIColor.whiteColor()
//            
//            let view=UIView(frame: CGRectMake(20, 80, 100, 100))
//            view.backgroundColor=UIColor.yellowColor()
//            view.layer.borderColor=UIColor.blackColor().CGColor
//            view.layer.cornerRadius=25
//            view.layer.borderWidth=6
//            self.view.addSubview(view)
            
            let button=UIButton(frame: CGRectMake(20, 20, self.view.frame.width-40, 40))
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
            
            let datepick=UIDatePicker(frame:CGRectMake(20, 80, 280, 100))
            datepick.datePickerMode = UIDatePickerMode.Date
            self.view.addSubview(datepick)
            
            let textview=UITextView(frame:CGRectMake(20, 330, self.view.frame.width-40, 60))
            textview.scrollEnabled=true
            textview.text = "Test"
            textview.backgroundColor=UIColor.grayColor()
            textview.textColor=UIColor.blueColor()
            textview.textAlignment=NSTextAlignment.Center
            self.view.addSubview(textview)
            
           
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        func pressme(){
            let alertView=UIAlertView()
            alertView.title="RK"
            alertView.addButtonWithTitle("OK") 
            alertView.message="going back to first vc" 
            
            alertView.show() 
            
            self.navigationController!.popToRootViewControllerAnimated(true) 
            
        }
    
}



