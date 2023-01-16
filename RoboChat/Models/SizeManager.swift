//
//  SizeManager.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/16/23.
//

import UIKit

enum DeviceGroup {
    case iPhone13cm
    case iPhone14cm
    case iPhone15cm
    case iPhone16cm
    case iPad20cm
    case iPad24cm
    case iPad25cm
    case iPad28cm
    case iPad30cm
}

final class SizeManager {
    
    static let shared = SizeManager()
    
    public func getDeviceGroup(deviceName: String = UIDevice.modelName) -> DeviceGroup {
        var returnGroup: DeviceGroup = DeviceGroup.iPhone14cm
        
        switch deviceName {
        case "iPhone 8", "iPhone 13 mini", "iPhone 12 mini", "iPhone SE", "iPhone SE (2nd generation)", "iPhone SE (3rd generation)", "iPhone SE (3rd generation)":
            returnGroup = DeviceGroup.iPhone13cm
        case "iPhone X", "iPhone XS", "iPhone 11 Pro", "iPhone 12", "iPhone 12 Pro", "iPhone 13", "iPhone 13 Pro", "iPhone 14", "iPhone 14 Pro" :
            returnGroup = DeviceGroup.iPhone14cm
        case "iPhone 8 Plus", "iPhone XR", "iPhone XS Max", "iPhone 11", "iPhone 11 Pro Max":
            returnGroup = DeviceGroup.iPhone15cm
        case "iPhone 12 Pro Max", "iPhone 13 Pro Max", "iPhone 14 Plus", "iPhone 14 Pro Max":
            returnGroup = DeviceGroup.iPhone16cm
        case "iPad mini (5th generation)", "iPad mini (6th generation)":
            returnGroup = DeviceGroup.iPad20cm
        case "iPad (5th generation)", "iPad (6th generation)", "iPad Air", "iPad Pro (9.7-inch)", "iPad Air 2" :
            returnGroup = DeviceGroup.iPad24cm
        case "iPad (7th generation)", "iPad (8th generation)", "iPad (9th generation)", "iPad (10th generation)", "iPad Air (3rd generation)", "iPad Air (4th generation)", "iPad Air (5th generation)", "iPad Pro (10.5-inch)", "iPad Pro (11-inch) (1st generation)", "iPad Pro (11-inch) (2nd generation)", "iPad Pro (11-inch) (3rd generation)", "iPad Pro (11-inch) (4th generation)":
            returnGroup = DeviceGroup.iPad25cm
        case "iPad Pro (12.9-inch) (1st generation)", "iPad Pro (12.9-inch) (2nd generation)", "iPad Pro (12.9-inch) (3rd generation)", "iPad Pro (12.9-inch) (4th generation)", "iPad Pro (12.9-inch) (5th generation)", "iPad Pro (12.9-inch) (6th generation)":
            returnGroup = DeviceGroup.iPad28cm
        default:
            if UIScreen.main.bounds.height < 2600 {
                print("jajjj")
            }
        }
        
        return returnGroup
    }
    
}
