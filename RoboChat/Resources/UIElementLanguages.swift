//
//  UIElementLanguages.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/19/23.
//

import UIKit

enum RCUIElement {
    case mainSettingsButton
    case mainTitleLabel
    case mainSubTitleLabel
    case mainclearButton
    case mainMicrophoneButton
    case mainTextField
    case mainSendButton
}

struct UIElementLanguages {
    var uiElement: RCUIElement
    var titleEnglish: String
    var titleSwedish: String
    var titleFrench: String
    var titleSpanish: String
    var accessibilityLabelEnglish: String
    var accessibilityLabelSwedish: String
    var accessibilityLabelFrench: String
    var accessibilityLabelSpanish: String
}

let uiElementList: [UIElementLanguages] = [
    UIElementLanguages(uiElement: .mainSettingsButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "Settings", accessibilityLabelSwedish: "Inställningar", accessibilityLabelFrench: "Paramètres", accessibilityLabelSpanish: "Ajustes"),
    UIElementLanguages(uiElement: .mainTitleLabel, titleEnglish: "Ask me something", titleSwedish: "Fråga mig något", titleFrench: "Demande-moi quelque chose", titleSpanish: "Pregúntame algo", accessibilityLabelEnglish: "Ask me something", accessibilityLabelSwedish: "Fråga mig något", accessibilityLabelFrench: "Demande-moi quelque chose", accessibilityLabelSpanish: "Pregúntame algo"),
    UIElementLanguages(uiElement: .mainSubTitleLabel, titleEnglish: "Powered by OpenAI", titleSwedish: "drivs av OpenAI", titleFrench: "Alimenté par OpenAI", titleSpanish: "Alimentado por OpenAI", accessibilityLabelEnglish: "Powered by OpenAI", accessibilityLabelSwedish: "drivs av OpenAI", accessibilityLabelFrench: "Alimenté par OpenAI", accessibilityLabelSpanish: "Alimentado por OpenAI"),
    UIElementLanguages(uiElement: .mainclearButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "Clear chat", accessibilityLabelSwedish: "Rensa konversationer", accessibilityLabelFrench: "supprimer l'historique des discussions", accessibilityLabelSpanish: "Commo eliminar el historial de conversaciones"),
    UIElementLanguages(uiElement: .mainMicrophoneButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "Start voice recording", accessibilityLabelSwedish: "starta röstinspelning", accessibilityLabelFrench: "Démarrer l'enregistrement vocal", accessibilityLabelSpanish: "Grabación de voz"),
    UIElementLanguages(uiElement: .mainTextField, titleEnglish: "Type your question here", titleSwedish: "typ här", titleFrench: "écrivez ici", titleSpanish: "Escriba aquí", accessibilityLabelEnglish: "Type your question here", accessibilityLabelSwedish: "typ här", accessibilityLabelFrench: "écrivez ici", accessibilityLabelSpanish: "Escriba aquí"),
    UIElementLanguages(uiElement: .mainSendButton, titleEnglish: "Send", titleSwedish: "Skicka", titleFrench: "Envoyer", titleSpanish: "Enviar", accessibilityLabelEnglish: "Send", accessibilityLabelSwedish: "Skicka", accessibilityLabelFrench: "Envoyer", accessibilityLabelSpanish: "Enviar"),
    
]
