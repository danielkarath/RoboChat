//
//  RCSpeechManager.swift
//  RoboChat
//
//  Created by Daniel Karath on 2/9/23.
//

import UIKit
import Speech
import AVFAudio

final class RCSpeechManager {
    
    private let activeMicImageView = UIImageView(image: UIImage(named: "microphoneIcon"))
    private let inactiveMicImageView = UIImageView(image: UIImage(named: "microphoneIconInactive"))
    private let menuIcon = UIImageView(image: UIImage(named: "menuIcon"))
    private let clearIcon = UIImageView(image: UIImage(named: "clearIcon"))
    private let clearIconInactive = UIImageView(image: UIImage(named: "clearIconInactive"))
    
    public func say(synthesizer: AVSpeechSynthesizer, phrase: String, onlyIfVoiceOverOn: Bool = true, isPriority: Bool, language: SelectedLanguage, rate: Float = AVSpeechUtteranceDefaultSpeechRate, volume: Float = 1.0) {
        guard AVSpeechSynthesisVoice(language: language.rawValue) != nil else { return }
        let voice: AVSpeechSynthesisVoice = AVSpeechSynthesisVoice(language: language.rawValue) ?? AVSpeechSynthesisVoice(language: "en-US")!
        if onlyIfVoiceOverOn {
            guard UIAccessibility.isVoiceOverRunning else { return }
            if synthesizer.isSpeaking || UIAccessibility.isVoiceOverRunning {
                // Set up a timer to speak the utterance in 1 second
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                    let utterance = AVSpeechUtterance(string: phrase)
                    utterance.rate = rate
                    utterance.volume = volume
                    utterance.voice = voice
                    if isPriority {
                        UIAccessibility.post(notification: .layoutChanged, argument: nil)
                        //UIAccessibility.post(notification: .layoutChanged, argument: nil)
                        utterance.preUtteranceDelay = 0
                    }
                    synthesizer.speak(utterance)
                }
            } else {
                let utterance = AVSpeechUtterance(string: phrase)
                utterance.rate = rate
                utterance.volume = volume
                utterance.voice = voice
                if isPriority {
                    UIAccessibility.post(notification: .layoutChanged, argument: nil)
                    //UIAccessibility.post(notification: .layoutChanged, argument: nil)
                    utterance.preUtteranceDelay = 0
                }
                synthesizer.speak(utterance)
            }
        } else {
            if synthesizer.isSpeaking || UIAccessibility.isVoiceOverRunning {
                // Set up a timer to speak the utterance in 1 second
                Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                    let utterance = AVSpeechUtterance(string: phrase)
                    utterance.rate = rate
                    utterance.volume = volume
                    utterance.voice = voice
                    if isPriority {
                        UIAccessibility.post(notification: .layoutChanged, argument: nil)
                        utterance.preUtteranceDelay = 0
                    }
                    synthesizer.speak(utterance)
                }
            } else {
                let utterance = AVSpeechUtterance(string: phrase)
                utterance.rate = rate
                utterance.volume = volume
                utterance.voice = voice
                if isPriority {
                    UIAccessibility.post(notification: .layoutChanged, argument: nil)
                    //UIAccessibility.post(notification: .layoutChanged, argument: nil)
                    utterance.preUtteranceDelay = 0
                }
                synthesizer.speak(utterance)
            }
        }
    }
    
    public func checkAuthorizations(microphoneButton: UIButton, errorLabel: UILabel) -> SFSpeechRecognizerAuthorizationStatus {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .authorized:
            let imageView = activeMicImageView
            imageView.frame = CGRect(x: microphoneButton.layer.frame.minX, y: microphoneButton.layer.frame.minY, width: 70, height: 70)
            imageView.contentMode = .scaleAspectFit
            microphoneButton.addSubview(imageView)
            //startTimerDown()
            break
        case .denied:
            let imageView = inactiveMicImageView
            imageView.frame = CGRect(x: microphoneButton.layer.frame.minX, y: microphoneButton.layer.frame.minY, width: 70, height: 70)
            imageView.contentMode = .scaleAspectFit
            microphoneButton.addSubview(imageView)
            errorLabel.text = "Speech recognition is disabled. Reenable it in Settings."
            break
        case .restricted:
            let imageView = inactiveMicImageView
            imageView.frame = CGRect(x: microphoneButton.layer.frame.minX, y: microphoneButton.layer.frame.minY, width: 70, height: 70)
            imageView.contentMode = .scaleAspectFit
            microphoneButton.addSubview(imageView)
            errorLabel.text = "Speech recognition was not authorized. Reenable it in Settings."
            break
        case .notDetermined:
            let imageView = activeMicImageView
            imageView.frame = CGRect(x: microphoneButton.layer.frame.minX, y: microphoneButton.layer.frame.minY, width: 70, height: 70)
            imageView.contentMode = .scaleAspectFit
            microphoneButton.addSubview(imageView)
        }
        
        return SFSpeechRecognizer.authorizationStatus()
    }
    
    public func requestAuthorizationRecording(microphoneButton: UIButton, errorLabel: UILabel, performSegueFunc: @escaping () -> ()) {
        do {
            try SFSpeechRecognizer.requestAuthorization { [unowned self] (authStatus) in
                DispatchQueue.main.async {
                    switch authStatus {
                    case .authorized:
                        performSegueFunc()
                        // The user has granted authorization to the speech recognizer.
                        // You can now start using the speech recognizer.
                        break
                    case .denied:
                        microphoneButton.removeAllSubviews()
                        errorLabel.text = "Did not authorize speechrecognition"
                        let imageView = self.inactiveMicImageView
                        imageView.frame = CGRect(x: microphoneButton.layer.frame.minX, y: microphoneButton.layer.frame.minY, width: 70, height: 70)
                        imageView.contentMode = .scaleAspectFit
                        microphoneButton.addSubview(imageView)
                        // The user has denied authorization to the speech recognizer.
                        // Show an alert or take other appropriate action.
                        break
                    case .restricted:
                        microphoneButton.removeAllSubviews()
                        errorLabel.text = "Speech Recognition is restricted on this device"
                        let imageView = self.inactiveMicImageView
                        imageView.frame = CGRect(x: microphoneButton.layer.frame.minX, y: microphoneButton.layer.frame.minY, width: 70, height: 70)
                        imageView.contentMode = .scaleAspectFit
                        microphoneButton.addSubview(imageView)
                        // The user is not allowed to authorize the speech recognizer.
                        // Show an alert or take other appropriate action.
                        break
                    case .notDetermined:
                        break
                    @unknown default:
                        // This case should never be reached, as the SFSpeechRecognizer authorization status should always be known.
                        break
                    }
                }
            }
        } catch {
            errorLabel.text = "An error occured while requesting authorization"
        }
    }
}
