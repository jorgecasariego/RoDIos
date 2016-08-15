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

import Foundation
import Alamofire

public struct Transport  {
    static let hostname = "192.168.4.1"
    static let port = "1234"
    
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


}
