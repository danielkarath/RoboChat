//
//  ViewController.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/9/23.
//

import UIKit
import AVFoundation
import Speech

enum VoiceLanguage: String {
    case English = "en-US"
    case Swedish = "sv-SE"
    case French = "fr-FR"
    case Spanish = "es-ES"
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, AVSpeechSynthesizerDelegate, SFSpeechRecognizerDelegate, MicrophoneViewControllerDelegate {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognitionAuth: SFSpeechRecognizerAuthorizationStatus?
    private let audioSession = AVAudioSession.sharedInstance()
    private var audioEngine = AVAudioEngine()
    
    private var animationTimer: Timer?
    private var errorExitTimer: Timer?
    
    private var models = [String]()
    private var questionAllowed: Bool = true
    private var audioInputBusCounter: Int = 0
    private var isAudioEngineRunning: Bool = false
    
    // MARK: - Color constants
    private let textColor: UIColor = UIColor(named: "textColor") ?? UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
    private let lowerViewBackgroundColor: UIColor = UIColor(named: "lowerBackgroundColor") ?? UIColor(red: 58/255, green: 58/244, blue: 59/255, alpha: 1.0)
    private let simpleBackgroundColor: UIColor = UIColor(named: "simpleBackgroundColor") ?? UIColor(red: 28/255, green: 28/255, blue: 32/255, alpha: 1.0)
    private let highlightedBackgroundColor: UIColor = UIColor(named: "highlightedBackgroundColor") ?? UIColor(red: 247/255, green: 247/255, blue: 251/255, alpha: 1.0)
    private let mainColor: UIColor = UIColor(named: "mainColor") ?? UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
    private let errorColor: UIColor = UIColor(named: "errorColor") ?? UIColor(red: 245/255, green: 61/244, blue: 73/255, alpha: 1.0)
    private let activeMicImageView = UIImageView(image: UIImage(named: "microphoneIcon"))
    private let inactiveMicImageView = UIImageView(image: UIImage(named: "microphoneIconInactive"))
    private let menuIcon = UIImageView(image: UIImage(named: "menuIcon"))
    private let clearIcon = UIImageView(image: UIImage(named: "clearIcon"))
    private let clearIconInactive = UIImageView(image: UIImage(named: "clearIconInactive"))
    
    // MARK: - Private View Components
    private let lowerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.frame.size.height = 128
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 32, height: 32)
        button.clipsToBounds = true
        button.setTitle("", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(menuButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ask me something"
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Powered by OpenAI"
        label.font = UIFont(name: "Avenir Next Demi Bold", size: 10)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir Next", size: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.placeholder = "Type here..."
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .default
        textField.returnKeyType = .send
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //tableView.separatorColor = UIColor(red: 212/255, green: 212/255, blue: 216/255, alpha: 0.1)
        tableView.allowsSelection = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let microphoneButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 70, height: 70)
        button.layer.cornerRadius = button.frame.size.width/2
        button.clipsToBounds = true
        button.setTitle("", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(microphoneButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let clearTextButton: UIButton = {
        let button = UIButton()
        button.frame.size = CGSize(width: 32, height: 32)
        button.clipsToBounds = true
        button.setTitle("", for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let sendQuestionButton: UIButton = {
        let button = UIButton()
        let title: String = "send"
        let mainColor: UIColor = UIColor(named: "mainColor") ?? UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
        let fontColor: UIColor = UIColor(red: 247/255, green: 247/255, blue: 251/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        let range = (title as NSString).range(of: title)
        var buttonFont: UIFont?
        buttonFont = UIFont(name: "Avenir Next", size: 15)
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSMutableAttributedString.Key.font: buttonFont!])
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        attributedText.addAttribute(NSAttributedString.Key.kern, value: 1.2, range: range)
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = mainColor
        button.addTarget(self, action: #selector(sendButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        chatTableView.separatorStyle = .none
        setupConstraints()
        setupDoubleTapRecognizer(view: view)
        overrideUserInterfaceStyle = .dark
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        view.addSubview(lowerView)
        view.addSubview(chatTableView)
        view.addSubview(menuButton)
        view.addSubview(clearTextButton)
        view.addSubview(microphoneButton)
        view.addSubview(titleLabel)
        view.addSubview(errorLabel)
        view.addSubview(subTitleLabel)
        lowerView.addSubview(textField)
        lowerView.addSubview(sendQuestionButton)
        
        textField.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
        synthesizer.delegate = self
        
        view.backgroundColor = simpleBackgroundColor
        lowerView.backgroundColor = lowerViewBackgroundColor
        textField.backgroundColor = highlightedBackgroundColor
        textField.textColor = textColor
        errorLabel.textColor = errorColor
        chatTableView.backgroundColor = simpleBackgroundColor
        clearTextButton.backgroundColor = simpleBackgroundColor
        
        speechRecognitionAuth = checkAuthorizations()
        
        textField.becomeFirstResponder()
        setupButtons()
    }
    
    private func setupConstraints() {
        var lowerViewHeightModifier: CGFloat = 40
        switch SizeManager.shared.getDeviceGroup() {
        case .iPhone13cm:
            lowerViewHeightModifier = 80
        case .iPhone14cm, .iPhone15cm:
            lowerViewHeightModifier = 60
        default:
            lowerViewHeightModifier = 50
        }
        NSLayoutConstraint.activate([
            lowerView.heightAnchor.constraint(equalTo: view.keyboardLayoutGuide.heightAnchor, constant: lowerViewHeightModifier),
            lowerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            lowerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            lowerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 40),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -118),
            textField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            
            sendQuestionButton.heightAnchor.constraint(equalToConstant: 40),
            sendQuestionButton.widthAnchor.constraint(equalToConstant: 86),
            sendQuestionButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 16),
            sendQuestionButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 56),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            titleLabel.widthAnchor.constraint(equalToConstant: 220),
            
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -10),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 56),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            subTitleLabel.widthAnchor.constraint(equalToConstant: 220),
            
            errorLabel.bottomAnchor.constraint(equalTo: lowerView.topAnchor, constant: -16),
            errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            errorLabel.heightAnchor.constraint(equalToConstant: 70),
            errorLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width-116),
            
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            menuButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            menuButton.heightAnchor.constraint(equalToConstant: 32),
            menuButton.widthAnchor.constraint(equalToConstant: 32),
            
            clearTextButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            clearTextButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            clearTextButton.heightAnchor.constraint(equalToConstant: 32),
            clearTextButton.widthAnchor.constraint(equalToConstant: 32),
            
            microphoneButton.bottomAnchor.constraint(equalTo: lowerView.topAnchor, constant: -16),
            microphoneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            microphoneButton.heightAnchor.constraint(equalToConstant: 70),
            microphoneButton.widthAnchor.constraint(equalToConstant: 70),
            
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            chatTableView.bottomAnchor.constraint(equalTo: lowerView.topAnchor),
            chatTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            chatTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
        
    }
    
    private func setupButtons() {
        let buttons: [UIButton] = [menuButton, clearTextButton]
        let buttonImageViews: [UIImageView] = [menuIcon, clearIcon]
        var i: Int = 0
        for button in buttons {
            let imageView = buttonImageViews[i]
            imageView.frame = CGRect(x: button.layer.frame.minX, y: button.layer.frame.minY, width: 32, height: 32)
            imageView.contentMode = .scaleAspectFit
            button.addSubview(imageView)
            i = i + 1
        }
    }
    
    private func setupSendButton(isEnabled: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.10) {
            if isEnabled {
                self.sendQuestionButton.backgroundColor = self.simpleBackgroundColor
                self.sendQuestionButton.isUserInteractionEnabled = !isEnabled
                self.sendQuestionButton.isEnabled = !isEnabled
                
                self.microphoneButton.isUserInteractionEnabled = !isEnabled
                self.microphoneButton.isEnabled = !isEnabled
                self.microphoneButton.isHidden = true
            } else {
                self.sendQuestionButton.backgroundColor = self.mainColor
                self.sendQuestionButton.isUserInteractionEnabled = !isEnabled
                self.sendQuestionButton.isEnabled = !isEnabled
                
                self.microphoneButton.isUserInteractionEnabled = !isEnabled
                self.microphoneButton.isEnabled = !isEnabled
                self.microphoneButton.isHidden = false
            }
            self.questionAllowed = !isEnabled
        }
    }
    
    private func setupDoubleTapRecognizer(view: UIView) {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    private func sendQuestion(textField: UITextField) {
        if questionAllowed {
            setupSendButton(isEnabled: questionAllowed)
            if let text = textField.text, !text.isEmpty, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                models.append(text)
                APIManager.shared.getResponse(input: text) { [weak self] result in
                    switch result {
                    case .success(let output):
                        let modifiedOutput = self?.modifyOutput(output: output) ?? output
                        self?.models.append(modifiedOutput.trimmingCharacters(in: .newlines))
                        DispatchQueue.main.async {
                            self?.chatTableView.reloadData()
                            self?.textField.text = nil
                            self?.setupSendButton(isEnabled: self?.questionAllowed ?? false)
                            self?.errorLabel.isHidden = true
                            do{
                                let _ = try self?.audioSession.setCategory(AVAudioSession.Category.playback,
                                                                           options: .duckOthers)
                            }catch{
                                print(error)
                            }
                            self?.say(synthesizer: self!.synthesizer, phrase: modifiedOutput, onlyIfVoiceOverOn: false, isPriority: true)
                        }
                    case .failure:
                        print("ERROR: Failed to get response from APIManager.")
                        DispatchQueue.main.async {
                            self?.textField.text = nil
                            self?.setupSendButton(isEnabled: self?.questionAllowed ?? false)
                            self?.errorLabel.text = "ERROR: Failed to get response from OpenAI."
                            self?.errorLabel.isHidden = false
                        }
                    default:
                        print("Unknown result from APIManager get response in ViewController")
                        self?.setupSendButton(isEnabled: self?.questionAllowed ?? false)
                        self?.errorLabel.text = "ERROR: Failed due to unknow reason. Check your internet connection, restart the app."
                        self?.errorLabel.isHidden = false
                    }
                }
            }
        }
    }
    
    private func modifyOutput(output: String) -> String {
        var modifiedOutput: String = output.trimmingCharacters(in: .newlines)
        var outputChars: [Character] = []
        print("original output: \(output)")
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
        
        //modifiedOutput = String(outputChars)
        print("return statement: \(modifiedOutput)")
        return modifiedOutput
    }
    
    private func checkAuthorizations() -> SFSpeechRecognizerAuthorizationStatus {
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
    
    private func requestAuthorizationRecording() {
        do {
            try SFSpeechRecognizer.requestAuthorization { [unowned self] (authStatus) in
                DispatchQueue.main.async {
                    switch authStatus {
                    case .authorized:
                        performSegueToMicrophoneVC()
                        // The user has granted authorization to the speech recognizer.
                        // You can now start using the speech recognizer.
                        break
                    case .denied:
                        microphoneButton.removeAllSubviews()
                        self.errorLabel.text = "Did not authorize speechrecognition"
                        let imageView = self.inactiveMicImageView
                        imageView.frame = CGRect(x: self.microphoneButton.layer.frame.minX, y: self.microphoneButton.layer.frame.minY, width: 70, height: 70)
                        imageView.contentMode = .scaleAspectFit
                        self.microphoneButton.addSubview(imageView)
                        // The user has denied authorization to the speech recognizer.
                        // Show an alert or take other appropriate action.
                        break
                    case .restricted:
                        microphoneButton.removeAllSubviews()
                        self.errorLabel.text = "Speech Recognition is restricted on this device"
                        let imageView = self.inactiveMicImageView
                        imageView.frame = CGRect(x: self.microphoneButton.layer.frame.minX, y: self.microphoneButton.layer.frame.minY, width: 70, height: 70)
                        imageView.contentMode = .scaleAspectFit
                        self.microphoneButton.addSubview(imageView)
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
            
    func performSegueToMicrophoneVC() {
        let secondViewController = MicrophoneViewController()
        secondViewController.delegate = self
        secondViewController.modalPresentationStyle = .popover
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func performSegueToMenu() {
        let secondViewController = settingsMenuViewController()
        secondViewController.delegate = self
        secondViewController.modalPresentationStyle = .popover
        self.present(secondViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  models.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.layer.frame.size = CGSize(width: UIScreen.main.bounds.size.width, height: 60)
        let counter: Int = indexPath.row
        var imageView = UIImageView(image: UIImage(named: "aiIcon"))
        var label = UILabel()
        
        cell.backgroundColor = simpleBackgroundColor //.red
        
        label.frame = CGRect(x: 46, y: 20, width: (UIScreen.main.bounds.size.width-80), height: 30)
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir Next", size: 15)
        label.textColor = textColor
        label.numberOfLines = 0
        label.text = models[indexPath.row]
        
        if counter % 2 == 0 {
            imageView = UIImageView(image: UIImage(named: "userIcon"))
        } else {
            imageView = UIImageView(image: UIImage(named: "aiIcon"))
        }
        imageView.frame = CGRect(x: 8, y: cell.layer.frame.height/2.5, width: 24, height: 24)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        cell.addSubview(imageView)
        cell.addSubview(label)
        return cell
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendQuestion(textField: textField)
        return true
    }
    
    @objc private func sendButtonTapped(_ sender: UIButton) {
        sendQuestion(textField: textField)
    }
    
    @objc private func clearButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.models.removeAll()
            self.chatTableView.reloadData()
        }
    }
    
    @objc private func menuButtonTapped(_ sender: UIButton) {
        performSegueToMenu()
    }
    
    @objc private func handleDoubleTap() {
        if questionAllowed {
            if speechRecognitionAuth == .notDetermined {
                requestAuthorizationRecording()
            } else if speechRecognitionAuth != .authorized {
                if let aString = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(aString, options: [:], completionHandler: { success in
                        
                    })
                }
            } else {
                performSegueToMicrophoneVC()
            }
        }
    }
    
    @objc private func microphoneButtonTapped(_ sender: UIButton) {
        if speechRecognitionAuth == .notDetermined {
            requestAuthorizationRecording()
        } else if speechRecognitionAuth != .authorized {
            if let aString = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(aString, options: [:], completionHandler: { success in
                    
                })
            }
        } else {
            performSegueToMicrophoneVC()
        }
    }
    
    func didAddSpeechToText(_ text: String) {
        textField.text = text
        sendQuestion(textField: textField)
    }
    
    public func say(synthesizer: AVSpeechSynthesizer, phrase: String, onlyIfVoiceOverOn: Bool = true, isPriority: Bool, language: VoiceLanguage = .English, rate: Float = AVSpeechUtteranceDefaultSpeechRate, volume: Float = 1.0) {
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
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
}
