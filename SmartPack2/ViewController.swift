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
    let deviceName = "SMARTPACK2"
    
    // Title labels
    var titleLabel : UILabel!
    var statusLabel : UILabel!
    
    // UUID
    
    let testConfigUUID1 = CBUUID(string: "12345678-9012-3456-7890-1234567890FF") // UUID for private service
    let testConfigUUID2 = CBUUID(string: "12345678-9012-3456-7890-123456789AFF") // UUID for private charactersic
    
    
    
    
    /******* CBCentralManagerDelegate *******/
    
    
    // The code below controls calls made by the Central Manager
    
    
    
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
    
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        
        
          // print(advertisementData)
          // print(nameOfDeviceFound)
           print(peripheral.name)
        
        //   print(peripheral.name)
        
        if peripheral.name != nil {
            let daName = String(peripheral.name!)
            
            if daName == deviceName
            {
                statusLabel.text = "Found!"
                print("Got it 2")
                print(daName)
                
                
                self.smartpackPeripheral = peripheral
                
                
                central.connectPeripheral(peripheral, options: nil)
                central.stopScan()
                self.smartpackPeripheral.delegate = self
              
                print(peripheral)
            }
        }

        
    }
    
    
    // Discover services of the peripheral
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        self.statusLabel.text = "Discovering peripheral services"
        peripheral.discoverServices(nil)
    }
    
    
    // If disconnected, start searching again
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        self.statusLabel.text = "Disconnected"
        central.scanForPeripheralsWithServices(nil, options: nil)
    }

    
    /******* CBCentralPeripheralDelegate *******/
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        self.statusLabel.text = "Looking at peripheral services"
        for service in peripheral.services! {
            let thisService = service as CBService
            if 1 == 1 {        ///// CHANGE THIS LATER TO CHECK FOR VALID SERVICES!!!
                // Discover characteristics of all valid services
                peripheral.discoverCharacteristics(nil, forService: thisService)
            }
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        self.statusLabel.text = "Talking to Bluetooth "
        
        
        
        for charateristic in service.characteristics! {
            let thisCharacteristic = charateristic as CBCharacteristic
            
            print(thisCharacteristic)
            print(charateristic)
     
            
            if thisCharacteristic.UUID == testConfigUUID2 {  //// Check for valid characetersic  WARNING
                // Enable Sensor Notification
                print("Hello")
                self.smartpackPeripheral.setNotifyValue(true, forCharacteristic: thisCharacteristic)
                print(thisCharacteristic)
            }
            
            
            
//            if SensorTag.validConfigCharacteristic(thisCharacteristic) {
//                // Enable Sensor
//                self.sensorTagPeripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
//            }
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        self.statusLabel.text = "Connected"
        
        print("status")
        print(characteristic)
        // self.sensorTagTableView.reloadData()
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
        
        // Set up status label
        statusLabel = UILabel()
        statusLabel.textAlignment = NSTextAlignment.Center
        statusLabel.text = "Loading..."
        statusLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        statusLabel.sizeToFit()
        //statusLabel.center = CGPoint(x: self.view.frame.midX, y: (titleLabel.frame.maxY + statusLabel.bounds.height/2) )
        statusLabel.frame = CGRect(x: self.view.frame.origin.x, y: self.titleLabel.frame.maxY, width: self.view.frame.width, height: self.statusLabel.bounds.height)
        self.view.addSubview(statusLabel)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

