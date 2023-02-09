//
//  RCResponseManager.swift
//  RoboChat
//
//  Created by Daniel Karath on 2/9/23.
//

import Foundation
import UIKit
import AVFAudio

final class RCResponseManager {
    
    private let speechManager = RCSpeechManager()
    public var models = [String]()
    
    public func sendQuestion(tableView: UITableView, textField: UITextField, errorLabel: UILabel, synthesizer: AVSpeechSynthesizer, audioSession: AVAudioSession) {
        let language: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-US"
        let selectedLanguage = LanguageManager.shared.convertStringToLanguage(selectedLanguage: language)
        if let text = textField.text, !text.isEmpty, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            models.append(text)
            APIManager.shared.getResponse(input: text) { [weak self] result in
                switch result {
                case .success(let output):
                    let modifiedOutput = self?.modifyOutput(output: output) ?? output
                    self?.models.append(modifiedOutput.trimmingCharacters(in: .newlines))
                    DispatchQueue.main.async {
                        tableView.reloadData()
                        textField.text = nil
                        //self?.setupSendButton(isEnabled: self?.questionAllowed ?? false)
                        errorLabel.isHidden = true
                        do{
                            let _ = try audioSession.setCategory(AVAudioSession.Category.playback,
                                                                       options: .duckOthers)
                        }catch{
                            print(error)
                        }
                        self?.speechManager.say(synthesizer: synthesizer, phrase: modifiedOutput, onlyIfVoiceOverOn: true, isPriority: true, language: selectedLanguage)
                    }
                case .failure:
                    print("ERROR: Failed to get response from APIManager.")
                    DispatchQueue.main.async {
                        textField.text = nil
                        //self?.setupSendButton(isEnabled: self?.questionAllowed ?? false)
                        errorLabel.text = "ERROR: Failed to get response from OpenAI."
                        errorLabel.isHidden = false
                    }
                default:
                    print("Unknown result from APIManager get response in ViewController")
                    //self?.setupSendButton(isEnabled: self?.questionAllowed ?? false)
                    errorLabel.text = "ERROR: Failed due to unknow reason. Check your internet connection, restart the app."
                    errorLabel.isHidden = false
                }
            }
        }
    }
    
    private func modifyOutput(output: String) -> String {
        var modifiedOutput: String = output.trimmingCharacters(in: .newlines)
        var outputChars: [Character] = []
        print("original output: \(output)")
        if modifiedOutput.hasPrefix("\n") {
            modifiedOutput = String(modifiedOutput.dropFirst())
        }
        modifiedOutput = modifiedOutput.replacingOccurrences(of: "\n", with: " ", options: .literal)
        modifiedOutput = modifiedOutput.replacingOccurrences(of: "?", with: "", options: .literal)
        let modifiedOutputLength: Int = modifiedOutput.count
        var i: Int = 0
        var j: Int = 0
        while i < modifiedOutputLength-1 && i < 20 {
            let char = modifiedOutput[modifiedOutput.index(modifiedOutput.startIndex, offsetBy: i)]
            outputChars.append(char)
            i = i + 1
        }
        
        while (outputChars[0] == " " || outputChars[0] == "?" || outputChars[0] == "!") && j < 5 {
            outputChars.remove(at: 0)
            j = j + 1
        }
        
        print("return statement: \(modifiedOutput)")
        return modifiedOutput
    }
    
}



