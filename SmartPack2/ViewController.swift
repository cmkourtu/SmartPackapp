//
//  ViewController.swift
//  SmartPack2
//
//  Created by Craig Kourtu on 3/24/16.
//  Copyright © 2016 ECE477Team1. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController,CBCentralManagerDelegate, CBPeripheralDelegate,UITableViewDataSource, UITableViewDelegate  {
    
    
    
    // Table View
    var smartpackTableView : UITableView!
    
    // BLE
    var centralManager : CBCentralManager!
    var smartpackPeripheral : CBPeripheral!
    let deviceName = "SMARTPACK2"
    
    // Title labels
    var titleLabel : UILabel!
    var statusLabel : UILabel!
    var allSensorLabels : [String] = []
    var allSensorValues : [String] = []

    
    
    
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
                self.smartpackPeripheral.setNotifyValue(true,forCharacteristic: thisCharacteristic)
                self.smartpackPeripheral.readValueForCharacteristic(thisCharacteristic)
                
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
        
        if characteristic.value != nil && characteristic.UUID == testConfigUUID2
        {
            print("Test for array")
            print(characteristic.value!)
            print(dataToUnsignedBytes8(characteristic.value!))
            let valueArray = dataToUnsignedBytes8(characteristic.value!)
            print(valueArray)
            
          if (valueArray.count > 10)
          {
            
            let sliceTagArray = valueArray[8..<20]
            let tagArray = Array(sliceTagArray)
            let returnedValues = convertTagPacket(tagArray)
            print(returnedValues)
            
                for(var i=0;i < 10; i++){
                
                    allSensorValues[i] = returnedValues[i]
                }
            
            
            allSensorValues[10] = convertGPS(valueArray)
            allSensorValues[11] = String(valueArray[0])
            
            
            }
          self.smartpackTableView.reloadData()
        }
        
        

        
        
    
}

    func convertGPS(valueArray: [UInt8]) -> String
    {
        let NSdigit = String(valueArray[1])
        let NSdecimal = String(Int(valueArray[2])*256 + Int(valueArray[3]))
        let WEdigit = String(valueArray[4])
        let WEdecimal = String(Int(valueArray[5])*256 + Int(valueArray[6]))
        
        
        let direction = Int(valueArray[7])
        var stringDirection = [" "," "]
        
        
        switch direction{
            
        case 1:
             stringDirection = ["ºN","ºW"]
        case 2:
             stringDirection = ["ºN","ºE"]
        case 3:
             stringDirection = ["ºS","ºW"]
        case 4:
             stringDirection = ["ºS","ºE"]
        default:
             stringDirection = ["X","X"]
            
        }
        
       
        
        let GPScoordinates = NSdigit + "." + NSdecimal + stringDirection[0] + " " + WEdigit + "." + WEdecimal + stringDirection[1]
        
        print(GPScoordinates)
    
        return GPScoordinates
    }
    
    
    func convertTagPacket(tagArray: [UInt8]) -> [String]
    {
        var tagValues : [String] = []
        
        for(var i=0; i<tagArray.count; i++)
        {
            for(var j=0; j<8;j++)
            {
            
                let k = tagArray[i] & 1 << UInt8(j)
                print(tagArray)
                print(k)
                
                if k != 0{
                    tagValues.append("Present")
                }
                else{
                    tagValues.append("Absent")
                }
                
            }
            
        }
    
    
        
        return tagValues
    }
    
    
    
    
    
    
    
    func dataToSignedBytes16(value : NSData) -> [Int16] {
        let count = value.length
        var array = [Int16](count: count, repeatedValue: 0)
        value.getBytes(&array, length:count * sizeof(Int16))
        return array
    }
    
     func dataToUnsignedBytes16(value : NSData) -> [UInt16] {
        let count = value.length
        var array = [UInt16](count: count, repeatedValue: 0)
        value.getBytes(&array, length:count * sizeof(UInt16))
        return array
    }
    
    
    
    func dataToUnsignedBytes8(value : NSData) -> [UInt8] {
        let count = value.length
        var array = [UInt8](count: count, repeatedValue: 0)
        value.getBytes(&array, length:count * sizeof(UInt8))
        return array
    }
    
    
    
    

    func setupsmartpackTableView () {
        
        self.smartpackTableView = UITableView()
        self.smartpackTableView.delegate = self
        self.smartpackTableView.dataSource = self
        
        
        self.smartpackTableView.frame = CGRect(x: self.view.bounds.origin.x, y: self.statusLabel.frame.maxY+20, width: self.view.bounds.width, height: self.view.bounds.height)
        
        self.smartpackTableView.registerClass(smartpackTableViewCell.self, forCellReuseIdentifier: "sensorTagCell")
        
        self.smartpackTableView.tableFooterView = UIView() // to hide empty lines after cells
        self.view.addSubview(self.smartpackTableView)
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
        
        
        
        // Start up Table View
        setupsmartpackTableView()
        
        allSensorLabels = getSensorLabels()
        allSensorValues = getSensorValues()
        
        
        self.smartpackTableView.reloadData()
        
        for (var i=0; i<allSensorLabels.count; i++) {
            print(i)
            print(allSensorValues)
            allSensorValues[i] = "Loading Values..."
            
        }
        
        
       
    }
    
     func getSensorLabels () -> [String] {
        let sensorLabels : [String] = [
            "Tag 1",
            "Tag 2",
            "Tag 3",
            "Tag 4",
            "Tag 5",
            "Tag 6",
            "Tag 7",
            "Tag 8",
            "Tag 9",
            "Tag 10",
            "GPS",
            "# of Tags Present"
        ]
        return sensorLabels
    }
    
    
    func getSensorValues () -> [String] {
        let sensorValues : [String] = [
            "None",
            "None",
            "None",
            "None",
            "None",
            "None",
            "None",
            "None",
            "None",
            "None",
            "404247 869115",
            "None"
        ]
        return sensorValues
    }
    
    
    /******* UITableViewDataSource *******/
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSensorLabels.count
    }
    
    
    /******* UITableViewDelegate *******/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let thisCell = tableView.dequeueReusableCellWithIdentifier("sensorTagCell") as! smartpackTableViewCell
        thisCell.sensorNameLabel.text  = allSensorLabels[indexPath.row]
        
        let valueString = NSString(format: "%@", allSensorValues[indexPath.row])
        thisCell.sensorValueLabel.text = valueString as String
        
        return thisCell
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

