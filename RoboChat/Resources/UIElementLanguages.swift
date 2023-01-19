//
//  UIElementLanguages.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/19/23.
//

import UIKit

enum RCUIElement {
    case backButton
    case mainSettingsButton
    case mainTitleLabel
    case mainSubTitleLabel
    case mainclearButton
    case mainMicrophoneButton
    case mainTextField
    case mainSendButton
    case settingsSettingsTitleLabel
    case settingsLanguageLabel
    case settingsDevelopedByLabel
    case micTileLabel
    case micInstructionsLabel
    case micInstructionLabelWhileRecording
    case micInstructionsLabelAfterRecording
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
   // UIElementLanguages(uiElement: .mainSettingsButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "", accessibilityLabelSwedish: "", accessibilityLabelFrench: "", accessibilityLabelSpanish: ""),
    UIElementLanguages(uiElement: .backButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "Back", accessibilityLabelSwedish: "Gå tillbaka", accessibilityLabelFrench: "Retour", accessibilityLabelSpanish: "Volver"),
    UIElementLanguages(uiElement: .mainSettingsButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "Settings", accessibilityLabelSwedish: "Inställningar", accessibilityLabelFrench: "Paramètres", accessibilityLabelSpanish: "Ajustes"),
    UIElementLanguages(uiElement: .mainTitleLabel, titleEnglish: "Ask me something", titleSwedish: "Fråga mig något", titleFrench: "Demande-moi quelque chose", titleSpanish: "Pregúntame algo", accessibilityLabelEnglish: "Ask me something", accessibilityLabelSwedish: "Fråga mig något", accessibilityLabelFrench: "Demande-moi quelque chose", accessibilityLabelSpanish: "Pregúntame algo"),
    UIElementLanguages(uiElement: .mainSubTitleLabel, titleEnglish: "Powered by OpenAI", titleSwedish: "drivs av OpenAI", titleFrench: "Alimenté par OpenAI", titleSpanish: "Alimentado por OpenAI", accessibilityLabelEnglish: "Powered by OpenAI", accessibilityLabelSwedish: "drivs av OpenAI", accessibilityLabelFrench: "Alimenté par OpenAI", accessibilityLabelSpanish: "Alimentado por OpenAI"),
    UIElementLanguages(uiElement: .mainclearButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "Clear chat", accessibilityLabelSwedish: "Rensa konversationer", accessibilityLabelFrench: "supprimer l'historique des discussions", accessibilityLabelSpanish: "Commo eliminar el historial de conversaciones"),
    UIElementLanguages(uiElement: .mainMicrophoneButton, titleEnglish: "", titleSwedish: "", titleFrench: "", titleSpanish: "", accessibilityLabelEnglish: "Start voice recording", accessibilityLabelSwedish: "starta röstinspelning", accessibilityLabelFrench: "Démarrer l'enregistrement vocal", accessibilityLabelSpanish: "Grabación de voz"),
    UIElementLanguages(uiElement: .mainTextField, titleEnglish: "Type your question here", titleSwedish: "typ här", titleFrench: "écrivez ici", titleSpanish: "Escriba aquí", accessibilityLabelEnglish: "Type your question here", accessibilityLabelSwedish: "typ här", accessibilityLabelFrench: "écrivez ici", accessibilityLabelSpanish: "Escriba aquí"),
    UIElementLanguages(uiElement: .mainSendButton, titleEnglish: "Send", titleSwedish: "Skicka", titleFrench: "Envoyer", titleSpanish: "Enviar", accessibilityLabelEnglish: "Send", accessibilityLabelSwedish: "Skicka", accessibilityLabelFrench: "Envoyer", accessibilityLabelSpanish: "Enviar"),
    UIElementLanguages(uiElement: .settingsSettingsTitleLabel, titleEnglish: "Settings", titleSwedish: "Inställningar", titleFrench: "Paramètres", titleSpanish: "Ajustes", accessibilityLabelEnglish: "Settings", accessibilityLabelSwedish: "Inställningar", accessibilityLabelFrench: "Paramètres", accessibilityLabelSpanish: "Ajustes"),
    UIElementLanguages(uiElement: .settingsLanguageLabel, titleEnglish: "Language", titleSwedish: "Språk", titleFrench: "Langue", titleSpanish: "Idioma", accessibilityLabelEnglish: "Language", accessibilityLabelSwedish: "Språk", accessibilityLabelFrench: "Langue", accessibilityLabelSpanish: "Idioma"),
    UIElementLanguages(uiElement: .settingsDevelopedByLabel, titleEnglish: "Developed by Daniel Karath", titleSwedish: "Utvecklad av Daniel Karath", titleFrench: "Développé par Daniel", titleSpanish: "Desarrollado por Daniel", accessibilityLabelEnglish: "Developed by Daniel Karath", accessibilityLabelSwedish: "Utvecklad av Daniel Karath", accessibilityLabelFrench: "Développé par Daniel", accessibilityLabelSpanish: "Desarrollado por Daniel"),
    UIElementLanguages(uiElement: .micTileLabel, titleEnglish: "Voice recording", titleSwedish: "Röstinspelning", titleFrench: "Enregistrement vocal", titleSpanish: "Grabación", accessibilityLabelEnglish: "Voice recording", accessibilityLabelSwedish: "Röstinspelning", accessibilityLabelFrench: "enregistrement vocal", accessibilityLabelSpanish: "grabación"),
    UIElementLanguages(uiElement: .micInstructionsLabel, titleEnglish: "Recording starting...", titleSwedish: "Inspelningen startar", titleFrench: "Début de l'enregistrement", titleSpanish: "Inicio de la grabación", accessibilityLabelEnglish: "Recording starting soon", accessibilityLabelSwedish: "Inspelningen startar snart", accessibilityLabelFrench: "Début de l'enregistrement bientôt", accessibilityLabelSpanish: "Inicio de la grabación"),
    UIElementLanguages(uiElement: .micInstructionLabelWhileRecording, titleEnglish: "Ask me something", titleSwedish: "Fråga mig något", titleFrench: "Demande-moi quelque chose", titleSpanish: "Pregúntame algo", accessibilityLabelEnglish: "Ask me something", accessibilityLabelSwedish: "Fråga mig något", accessibilityLabelFrench: "Demande-moi quelque chose", accessibilityLabelSpanish: "Pregúntame algo"),
    UIElementLanguages(uiElement: .micInstructionsLabelAfterRecording, titleEnglish: "Sending question", titleSwedish: "Skicka meddelande", titleFrench: "Envoi du message", titleSpanish: "Enviando mensaje", accessibilityLabelEnglish: "Sending question", accessibilityLabelSwedish: "Skicka meddelande", accessibilityLabelFrench: "Envoi du message", accessibilityLabelSpanish: "Enviando mensaje")
]

