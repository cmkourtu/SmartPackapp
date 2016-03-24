//
//  ViewController.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 3/24/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    // BLE
    var centralManager : CBCentralManager!
    var smartpackPeripheral : CBPeripheral!
    
    // Title labels
    var titleLabel : UILabel!
    var statusLabel : UILabel!
    
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        
        if central.state == CBCentralManagerState.PoweredOn {
            // Scan for peripherals if BLE is turned on
            
            print("Test")
            central.scanForPeripheralsWithServices(nil, options: nil)
            
            print("Searching..")
            //          self.Status.text = "Searching for BLE Devices"
        }
        else {
            // Can have different conditions for all states if needed - show generic alert for now
            //          self.Status.text = "Bluetooth not turned on"
        }
    }
    

    override func viewDidLoad() {
        print("ViewLoaded")
        
        // Initialize central manager on load
        centralManager = CBCentralManager(delegate: self, queue: nil)

        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up title label
        titleLabel = UILabel()
        titleLabel.text = "SmartPack"
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: self.view.frame.midX, y: self.titleLabel.bounds.midY+28)
        self.view.addSubview(titleLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

