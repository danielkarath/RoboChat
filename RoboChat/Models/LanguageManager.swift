//
//  LanguageManager.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/19/23.
//

import UIKit

class LanguageManager {
    
    //MARK: Public
    
    static let shared = LanguageManager()
    
    public func readSelectedLanguage() -> SelectedLanguage {
        let RCUserDefaults = RCUserDefaults()
        let currentLanguage: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-US"
        
        var returnLanguage: SelectedLanguage?
        switch currentLanguage {
        case "en-US":
            returnLanguage = .English
        case "sv-SE":
            returnLanguage = .Swedish
        case "fr-FR":
            returnLanguage = .French
        case "es-ES":
            returnLanguage = .Spanish
        default:
            returnLanguage = .English
        }
        return returnLanguage ?? .English
    }
    
    public func setLanguage(selectedLanguage: SelectedLanguage) {
        guard selectedLanguage != nil else { return }
        
        //If this is true, then the language selection will go through
        if checkLanguageSelection(selectedLanguage: selectedLanguage) {
            let newLanguage: String = convertLanguageToString(selectedLanguage: selectedLanguage)
            RCUserDefaults.shared.language(selection: newLanguage)
        }
    }
    
    public func setAccessibilityLabelFor(element: RCUIElement) -> String {
        var returnValue: String?
        let currentLanguage: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-US"
        let convertedLanguage = convertStringToLanguage(selectedLanguage: currentLanguage) ?? .English
        let uiLanguageElement = returnUIElementLanguages(element: element)
        guard uiLanguageElement != nil else {
            return ""
        }
        switch convertedLanguage {
        case .English:
            returnValue = uiLanguageElement?.accessibilityLabelEnglish
        case .Swedish:
            returnValue = uiLanguageElement?.accessibilityLabelSwedish
        case .French:
            returnValue = uiLanguageElement?.accessibilityLabelFrench
        case .Spanish:
            returnValue = uiLanguageElement?.accessibilityLabelSpanish
        default:
            returnValue = uiLanguageElement?.accessibilityLabelEnglish
        }
        return returnValue ?? "Unknown"
    }
    
    public func setTitleLabelFor(element: RCUIElement) -> String {
        var returnValue: String?
        let currentLanguage: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-US"
        let convertedLanguage = convertStringToLanguage(selectedLanguage: currentLanguage) ?? .English
        let uiLanguageElement = returnUIElementLanguages(element: element)
        guard uiLanguageElement != nil else {
            return ""
        }
        switch convertedLanguage {
        case .English:
            returnValue = uiLanguageElement?.titleEnglish
        case .Swedish:
            returnValue = uiLanguageElement?.titleSwedish
        case .French:
            returnValue = uiLanguageElement?.titleFrench
        case .Spanish:
            returnValue = uiLanguageElement?.titleSpanish
        default:
            returnValue = uiLanguageElement?.titleEnglish
        }
        return returnValue ?? "Unknown"
    }
    
    //MARK: Private
    
    /// Converts the SelectedLanguage Type to a String
    /// - Parameter selectedLanguage: SelectedLanguage Type
    /// - Returns: The converted SelectedLanguage into a String
    public func convertLanguageToString(selectedLanguage: SelectedLanguage) -> String {
        var languageToString: String?
        switch selectedLanguage {
        case .English:
            languageToString = "en-US"
        case .Swedish:
            languageToString = "sv-SE"
        case .French:
            languageToString = "fr-FR"
        case .Spanish:
            languageToString = "es-ES"
        default:
            print("ERROR: Unknown Language selection. Error at LanguageManager convertLanguageToString!\nNow returning default value en-US")
            languageToString = "en-US"
        }
        return languageToString ?? "en-US"
    }
    
    /// Converts the String from UserDefaults to a SelectedLanguage Type
    /// - Parameter selectedLanguage: The current language selection as String
    /// - Returns: The returned selectedLanguage type
    public func convertStringToLanguage(selectedLanguage: String) -> SelectedLanguage {
        var languageToString: SelectedLanguage?
        switch selectedLanguage {
        case "en-US":
            languageToString = .English
        case "sv-SE":
            languageToString = .Swedish
        case "fr-FR":
            languageToString = .French
        case "es-ES":
            languageToString = .Spanish
        default:
            print("ERROR: Unknown Language selection found in UserDefaults. Error at LanguageManager convertStringToLanguage!\nNow returning default value .English")
            languageToString = .English
        }
        return languageToString ?? .English
    }
    
    
    /// Checks if the user's new language selection is the same as the current one
    /// - Parameter selectedLanguage: The language selected by the user
    /// - Returns: If the return value is true, then the selection is not the same as the vurrent language
    private func checkLanguageSelection(selectedLanguage: SelectedLanguage) -> Bool {
        let previousLanguage: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-US"
        var newLanguage: String = convertLanguageToString(selectedLanguage: selectedLanguage)
        if newLanguage != previousLanguage {
            return true
        } else {
            return false
        }
    }
    
    /// Returns the proper naming in different languages for the given RCUIElement
    /// - Parameter element: RCUIElement
    /// - Returns: The return value with namings for different languages
    private func returnUIElementLanguages(element: RCUIElement) -> UIElementLanguages?{
        var returnValue: UIElementLanguages?
        for uiElement in uiElementList {
            if element == uiElement.uiElement {
                print("YAAAyy")
                returnValue = uiElement
            }
        }
        return returnValue
    }
    
}
