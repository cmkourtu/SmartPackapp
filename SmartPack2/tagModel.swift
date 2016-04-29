//
//  tagModel.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 4/13/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import Foundation
import CoreLocation




class tagModel: NSObject{
    
    var tagArray: [tag] = []
    let blankTag : tag = tag()
    var lastLocation : Dictionary<String,NSObject>!
    
    
    override init() {
        
        for(var i = 0; i < 10; i++)
        {
            tagArray.append(blankTag)
        }
        
 
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(tagModel.locationAvailable(_:)), name: "LOCATION_AVAILABLE", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(tagModel.tagUpdatedAvailable(_:)), name: "TAGUPDATE", object: nil)
        
    }
    
    func locationAvailable(notification:NSNotification) -> Void {
        
        if notification.userInfo != nil
        {
            lastLocation = notification.userInfo as! Dictionary<String,NSObject>
        
            //print("WeatherService:  Location available \(lastLocation)")
        }
        else{"Nothing to see here"}
        
    }
    
    func tagUpdatedAvailable(notification:NSNotification) -> Void{
        if notification.userInfo != nil
        {
            for(var i = 0; i>notification.userInfo?.count ;i += 1)
        {
            tagArray[i].status = (notification.userInfo?[i]) as! String
            tagArray[i].name = "Tag \(i)"
            tagArray[i].timeLastScanned = NSDate()
            tagArray[i].lastLocation = self.lastLocation["placemark"] as? CLPlacemark
            
           let convertedTagArray = convertTagArraytoDictionary(tagArray)
            
            NSNotificationCenter.defaultCenter().postNotificationName("SCREENCHANGE", object: nil, userInfo: convertedTagArray)
        }
        
    func printTimestamp() {
                let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
                print(timestamp)
        }
        
        
    }
    
    
    }
    
}


class tag{
    var name: String!
    var timeLastScanned: NSDate!
    var lastLocation: CLPlacemark!
    var status: String!
    
}

