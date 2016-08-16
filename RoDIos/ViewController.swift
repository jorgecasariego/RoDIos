/*
 * Copyright © 2016 Jorge Casariego.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import Alamofire
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    // MARK: - Properties
    let hostname = "192.168.4.1"
    let port = "1234"
    var speed = 0
    let manager = CMMotionManager()
    
    // MARK: - Commands
    enum Commands: Int {
        case BLINK = 1
        case SENSE = 2
        case MOVE = 3
        case SING = 4
        case SEE = 5
        case PIXEL = 6
        case LIGHT = 7
        case LED = 8
        case IMU = 9
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager.startAccelerometerUpdates()
        
    }

    // MARK: - Actions
    @IBAction func moveForward(sender: AnyObject) {
        directionLabel.text = "Forward"
        speed = 100;
        sendCommand(Commands.MOVE, param1: speed, param2: speed);
    }
 
    @IBAction func stop(sender: AnyObject) {
        directionLabel.text = "Stop"
        speed = 0;
        sendCommand(Commands.MOVE, param1: speed, param2: speed);
    }

    @IBAction func moveLeft(sender: AnyObject) {
        directionLabel.text = "Left"
        sendCommand(Commands.MOVE, param1: speed == 0 ? -100 : 0, param2: speed == 0 ? 100 : speed);
    }
    
    @IBAction func moveReverse(sender: AnyObject) {
        directionLabel.text = "Reverse"
        speed = -100;
        sendCommand(Commands.MOVE, param1: speed, param2: speed);
    }
    
    @IBAction func moveRight(sender: AnyObject) {
        directionLabel.text = "Right"
        sendCommand(Commands.MOVE, param1: speed == 0 ? 100 : speed, param2: speed == 0 ? -100 : 0);
    }
    
    // MARK: - Communication
    func sendCommand(cmd: Commands, param1: Int, param2: Int){
        Alamofire.request(.GET, "http://\(hostname):\(port)/\(cmd.rawValue)/\(param1)/\(param2)") .responseJSON { response in // 1
            //print("request: \(response.request)")   // original URL request
            //print("response: \(response.response)") // URL response
            print("")
            self.getDistance()
        }
        
        
    }
    
    func getDistance() {
        Alamofire.request(.GET, "http://\(hostname):\(port)/5").responseJSON { response in // 1
            if let JSON = response.result.value {
                self.distanceLabel.text = "Distance to crash : \(JSON) !"
            }
        }
    }
    
    // MARK: - Accelerometer Actions
    @IBAction func startAccelerometer(sender: UIButton) {
        manager.accelerometerUpdateInterval = 1
        
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){
            [weak self] (data: CMAccelerometerData?, error: NSError?) in
            
            if let acceleration = data?.acceleration {
                if(abs(acceleration.x) > abs(acceleration.y)){
                    if (acceleration.x > 0) {
                        self!.directionLabel.text = "Right"
                        self!.speed = 100;
                        self!.sendCommand(Commands.MOVE, param1: self!.speed == 0 ? 100 : self!.speed, param2: self!.speed == 0 ? -100 : 0);
                    }
                    
                    if (acceleration.x < 0) {
                        self!.directionLabel.text = "Left"
                        self!.sendCommand(Commands.MOVE, param1: self!.speed == 0 ? -100 : 0, param2: self!.speed == 0 ? 100 : self!.speed);
                    }
                    
                } else {
                   
                    if (acceleration.y > 0) {
                        self!.directionLabel.text = "Forward"
                        self!.speed = 100;
                        self!.sendCommand(Commands.MOVE, param1: self!.speed, param2: self!.speed);
                    }
                    if (acceleration.y < 0) {
                        self!.directionLabel.text = "Reverse"
                        self!.speed = -100;
                        self!.sendCommand(Commands.MOVE, param1: self!.speed, param2: self!.speed);
                    }
                }
                
            }
        }
        
    }
    
    @IBAction func stopAccelerometer(sender: UIButton) {
        self.directionLabel.text = "Stop"
        speed = 0;
        sendCommand(Commands.MOVE, param1: speed, param2: speed);
        manager.stopAccelerometerUpdates()
    }
}


