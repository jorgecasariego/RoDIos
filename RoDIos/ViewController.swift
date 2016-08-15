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

class ViewController: UIViewController {
    
    let hostname = "192.168.4.1"
    let port = "1234"
    
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
    
    var speed = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func moveForward(sender: AnyObject) {
        speed = 100;
        sendCommand(Commands.MOVE, param1: speed, param2: speed);
    }
    
    @IBAction func stop(sender: AnyObject) {
        speed = 0;
        sendCommand(Commands.MOVE, param1: speed, param2: speed);
    }

    @IBAction func moveLeft(sender: AnyObject) {
        sendCommand(Commands.MOVE, param1: speed == 0 ? -100 : 0, param2: speed == 0 ? 100 : speed);
    }
    
    @IBAction func moveReverse(sender: AnyObject) {
        speed = -100;
        sendCommand(Commands.MOVE, param1: speed, param2: speed);
    }
    
    @IBAction func moveRight(sender: AnyObject) {
        sendCommand(Commands.MOVE, param1: speed == 0 ? 100 : speed, param2: speed == 0 ? -100 : 0);
    }
    
    func sendCommand(cmd: Commands, param1: Int, param2: Int){
        print("comamdno: \(cmd.rawValue)")
        
        Alamofire.request(.GET, "http://\(hostname):\(port)/\(cmd.rawValue)/\(param1)/\(param2)") .responseJSON { response in // 1
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
        }
    }
}


