//
//  smartpackTableViewCell.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 3/24/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import Foundation
import UIKit

class smartpackTableViewCell: UITableViewCell {
    
    var sensorNameLabel  = UILabel()
    var sensorValueLabel = UILabel()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // sensor name
        self.addSubview(sensorNameLabel)
        
        sensorNameLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        sensorNameLabel.frame = CGRect(x: self.bounds.origin.x+self.layoutMargins.left*2, y: self.bounds.origin.y, width: self.frame.width, height: self.frame.height)
        sensorNameLabel.textAlignment = NSTextAlignment.Left
        sensorNameLabel.text = "Sensor Name Label"
        
        // sensor value
        self.addSubview(sensorValueLabel)
      
        sensorValueLabel.font = UIFont(name: "HelveticaNeue", size: 18)
        sensorValueLabel.frame = CGRect(x: self.bounds.origin.x-self.layoutMargins.right*2, y: self.bounds.origin.y, width: self.frame.width, height: self.frame.height)
        sensorValueLabel.textAlignment = NSTextAlignment.Right
        sensorValueLabel.text = "Value"
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}