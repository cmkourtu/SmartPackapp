//
//  helper.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 4/14/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import Foundation


func convertTagArraytoDictionary(array : [tag]) -> [NSObject:AnyObject]{
    var dict = [NSObject:AnyObject]()
    for(var i = 0 ; i < array.count; i += 1){
        dict[i] = array[i]
    }
    return(dict)
    
    
}
