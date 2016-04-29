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
    var writer : CBCharacteristic!
    var valuesRead : Bool!
    var currentTag: Int!
    var master: CBCharacteristic!
    

    
    
    
    // UUID
    
    let testConfigUUID1 = CBUUID(string: "12345678-9012-3456-7890-1234567890FF") // UUID for private service
    let testConfigUUID2 = CBUUID(string: "12345678-9012-3456-7890-123456789AFF") // UUID for private charactersic
    let testConfigUUID3 = CBUUID(string: "12345678-9012-3456-7890-123456789AF1") // UUID for private charactersic
    
    
    
    
    
    /******* CBCentralManagerDelegate *******/
    
    
    // The code below controls calls made by the Central Manager
    
    
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        
        if central.state == CBCentralManagerState.PoweredOn {
            // Scan for peripherals if BLE is turned on
            
            let alertView=UIAlertView()
            alertView.title="SmartPack"
            alertView.addButtonWithTitle("OK")
            alertView.message="You left your Calculator"
            alertView.show()
            
            
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
    
    
    ///////////////// FUNCTION THAT FUNS WHEN A PERIPHERAL IS DETECTED
    
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
        print("Disconnected")
    }

    
    /******* CBCentralPeripheralDelegate *******/
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        self.statusLabel.text = "Looking at peripheral services"
        for service in peripheral.services! {
            let thisService = service as CBService
            if thisService.UUID == testConfigUUID1 {        ///// CHANGE THIS LATER TO CHECK FOR VALID SERVICES!!!
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
     
            print("Next Level")
            if thisCharacteristic.UUID == testConfigUUID2 {  //// Check for valid characetersic  WARNING
                // Enable Sensor Notification
                print("Hello")
                print(thisCharacteristic)
                self.master = thisCharacteristic
                self.smartpackPeripheral.setNotifyValue(true,forCharacteristic: thisCharacteristic)
                self.smartpackPeripheral.readValueForCharacteristic(thisCharacteristic)
                self.statusLabel.text = "Connected"
                
                

                
            }
            
            if(thisCharacteristic.UUID == testConfigUUID3)
            {
                self.writer = thisCharacteristic
            }
            
//            if SensorTag.validConfigCharacteristic(thisCharacteristic) {
//                // Enable Sensor
//                self.sensorTagPeripheral.writeValue(enablyBytes, forCharacteristic: thisCharacteristic, type: CBCharacteristicWriteType.WithResponse)
//            }
        }
        
    }
    
    
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?){
        
        if(error == nil)
        {
            print("The man in the middle")
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        // self.statusLabel.text = "Value Updated"
        
        print("*******status********")
        print(characteristic)
        
       

        
        
        
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
            
            
        //    allSensorValues[10] = convertGPS(valueArray)
            var prevNumerous = allSensorValues[11]
            allSensorValues[11] = String(valueArray[0])
            
            if ( Int(allSensorValues[11]) != nil && Int(prevNumerous) != nil)
            {
            
            if(Int(prevNumerous)! - Int(allSensorValues[11])! > 0)
            {
                let alertView=UIAlertView()
                alertView.title="SmartPack"
                alertView.addButtonWithTitle("OK")
                alertView.message="\(Int(prevNumerous)! - Int(allSensorValues[11])!) of your items left your backpack"
                alertView.show()
                
            }
            else if(Int(prevNumerous)! - Int(allSensorValues[11])! != 0)
            {
                let alertView=UIAlertView()
                alertView.title="SmartPack"
                alertView.addButtonWithTitle("OK")
                alertView.message="\( Int(allSensorValues[11])! - Int(prevNumerous)!) of your items entered your backpack"
                alertView.show()
            
            }
                
            }
            
            }
            
      
          let temp = convertArraytoDictionary(allSensorValues)
          let temp2 = [
            "allSensorValues": allSensorValues,
            "allSensorLabels": allSensorLabels,
              //  "country":  placemark.country!,
              //  "placemark": placemark
            ]
          
          NSNotificationCenter.defaultCenter().postNotificationName("TAG_UPDATE", object: nil, userInfo: temp)
          self.smartpackTableView.reloadData()
        }
        
        
print("The Outer Loop")
print(characteristic)
        
// If disconnected, start searching again
func centralManager(central: CBCentralManager, didDisconnectPeripheral char: CBPeripheral, error: NSError?) {
            self.statusLabel.text = "Disconnected"
            central.scanForPeripheralsWithServices(nil, options: nil)
            print("Disconnected")
}
        
        
        
        
        
    
}

    //Method: convertGPS
    
    //Function: This method recieves and array of UINT values, and uses the agreed upon method of converting said values in readable GPS location values.
    
    
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
    
    /// Method : convertTagPacket
    
    /// Function : Recieves an array of UInts, ands uses that data to create an array of values that represent the state of 
    /// tag, tags marked "Present" are in the battery backpack, tags marked absent are not.
    
    
    
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
    
    //// Methods: Dataconversion
    
    //// Function: These methods take in a paramater values type NSData that will probably be recieved by a charactersic, and return a Int of the respective values, this allows us to decode our bluetooth values
    
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateGPS(_:)), name: "LOCATION_AVAILABLE", object: nil)
        
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
    
    // Method Name: getSensorLabels
    
    // Function: Returns the default tags names to the calling function in the form of an array of strings.
    
    
     func getSensorLabels () -> [String] {
        let sensorLabels : [String] = [
            "Laptop",
            "Calculator",
            "Notebook",
            "Calc Textbook",
            "iClicker",
            "Keys",
            "Binder 1",
            "Binder 2",
            "Pens",
            "Lunch Bag",
            "GPS",
            "# of Tags Present"
        ]
        return sensorLabels
    }
    
    
    
    // Method Name: getSensorValues
    
    // Function: Returns the default sensor status values to the calling function in the form of an array of strings.
    
    
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
    /*********ConvertArraytoDictionary************/
    func convertArraytoDictionary(array : [String]) -> [NSObject:AnyObject]{
        var dict = [NSObject:AnyObject]()
        for(var i = 0 ; i < array.count; i += 1){
            dict[i] = array[i]
        }
    return(dict)
    
    
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
    
    
    // Method Name: didSelectRowAtIndex
    
    // This code runs whenever the users selects a row from the column, it begins by checking to see 
    // if the user actually has loaded information into the cell, and then send the cell IndexRow variables
    // which is equal to Row - 1.
    
    func tableView(_ tableView: UITableView,
                              didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
    
    
        var testint = indexPath.row
        let data = NSData(bytes: &testint, length: 5)
        
        pressme(testint)
        
        if( allSensorValues[testint] != "Loading Values...")  // Check label tag for connectivty for checking the called SensorTag Value for non default values
        {
            
            print(testint)     // Diagnostic print statments
            print(data)
            print(self.writer)
    
           // self.smartpackPeripheral.writeValue(data, forCharacteristic: self.writer,  type: CBCharacteristicWriteType.WithResponse) // Writing values to bluetooth charactersic selected. If the write is success the delegate for didWriteValueForCharacteristic
            
            
            self.currentTag = testint
            
            print("after")
            print(self.writer.value)
        }
        else{print("Sorry, no dice")}
        
    //   let tagViewController = storyboard!.instantiateViewControllerWithIdentifier("tagView")
    //    showViewController(tagViewController,sender: self)
    }
    
    
    func pressme(tag: Int){
        
        //******** navigation from one view controller to another *******//
        let tagView = tagViewController()
        tagView.myTag = tag
        
        self.navigationController!.pushViewController(tagView, animated: false)
        
        //******** creating UIalertview programmatically*******//
        

    }
    
    func updateGPS(notification: NSNotification){
        print("Printing that LOOCAAFSJFNKJDSFBL")
        
        
        
        
        var God = notification.userInfo!["location"]!
        let str = String(God)
        var index1 = str.startIndex.advancedBy(10)
        var index2 = str.startIndex.advancedBy(14)
        var substring1 = str.substringToIndex(index1)
        var substring2 = str.substringFromIndex(index2)
        var index3 = substring1.startIndex.advancedBy(2)
        var index4 = substring2.startIndex.advancedBy(8)
        var substring3 = substring1.substringFromIndex(index3)
        var substring4 = substring2.substringToIndex(index4)
        
        
        
        allSensorValues[10] = substring3 + "," + substring4
        print(substring1)
        print(substring2)
        print(substring3)
        print(substring4)
        
        if((self.master) != nil){
        self.smartpackPeripheral.readValueForCharacteristic(self.master)
        }
        
    }
    
    
    

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

