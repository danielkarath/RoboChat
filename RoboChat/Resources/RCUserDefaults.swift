//
//  RCUserDefaults.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/19/23.
//

import Foundation

class RCUserDefaults {
    
    static let shared = RCUserDefaults()
    
    private let userDefaults = UserDefaults.standard
    
    ///Selected Language
    func language(selection: String) {
        DispatchQueue.main.async {
            self.userDefaults.set(selection, forKey: "language")
        }
    }
    
}
