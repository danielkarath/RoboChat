//
//  HapticsManager.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/9/23.
//

import UIKit

///Object to manage haptics
final class HapticsManager {
    ///Singleton
    static let shared = HapticsManager()
    
    ///Private constructor
    private init() {}
    
    //MARK: - Public
    
    ///Vibrate slightly for selection
    public func vibrateForSelection() {
        
        ///Vibrates lightly for selection tap
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
    
    
    /// Play haptic for a given type
    /// - Parameter type: Type to vibrate for
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    
    //MARK: - Private
    
}
