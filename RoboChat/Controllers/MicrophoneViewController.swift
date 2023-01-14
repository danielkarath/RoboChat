//
//  MicrophoneViewController.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/14/23.
//

import UIKit
import Speech
import AVFoundation

protocol MicrophoneViewControllerDelegate {
    func didAddSpeechToText(_ text: String)
}

class MicrophoneViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    private let synthesizer = AVSpeechSynthesizer()
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var speechRecognitionAuth: SFSpeechRecognizerAuthorizationStatus?
    private let audioSession = AVAudioSession.sharedInstance()
    private var audioEngine = AVAudioEngine()
    
    private var animationTimer: Timer?
    private var countdownTimer: Timer?
    private var countDown = 1
    
    private let textColor: UIColor = UIColor(named: "textColor") ?? UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
    private let lowerViewBackgroundColor: UIColor = UIColor(named: "lowerBackgroundColor") ?? UIColor(red: 58/255, green: 58/244, blue: 59/255, alpha: 1.0)
    private let simpleBackgroundColor: UIColor = UIColor(named: "simpleBackgroundColor") ?? UIColor(red: 28/255, green: 28/255, blue: 32/255, alpha: 1.0)
    private let highlightedBackgroundColor: UIColor = UIColor(named: "highlightedBackgroundColor") ?? UIColor(red: 247/255, green: 247/255, blue: 251/255, alpha: 1.0)
    private let mainColor: UIColor = UIColor(named: "mainColor") ?? UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
    private let errorColor: UIColor = UIColor(named: "errorColor") ?? UIColor(red: 245/255, green: 61/244, blue: 73/255, alpha: 1.0)
    private let activeMicImageView = UIImage(named: "microphoneIcon")
    private let inactiveMicImageView = UIImage(named: "microphoneIconInactive")
    private let unfilledMicrophoneIcon = UIImage(named: "unfilledMicrophoneIcon")
    private let clearIcon = UIImage(named: "clearIcon")
    private let clearIconInactive = UIImage(named: "clearIconInactive")
    
    
    private let fullBlurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.clipsToBounds = true
        return view
    }()
    
    private let upperLineView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height:50)
        view.backgroundColor = UIColor(named: "simpleBackgroundColor") ?? UIColor(red: 28/255, green: 28/255, blue: 32/255, alpha: 1.0)
        view.layer.cornerRadius = 0
        view.layer.zPosition = 0
        return view
    }()
    
    private let lowerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "simpleBackgroundColor") ?? UIColor(red: 28/255, green: 28/255, blue: 32/255, alpha: 1.0)
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let speechTextLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Avenir Next", size: 18)
        label.textAlignment = .center
        label.contentMode = .top
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        let width: CGFloat = 24
        let height: CGFloat = width * 1.33
        let imageView = UIImageView(image: UIImage(systemName: "chevron.backward"))
        imageView.tintColor = UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
        imageView.frame = CGRect(x: 0, y: 10, width: width, height: height)
        button.frame = CGRect(x:  16, y: 0, width: width * 2, height: height * 2) //.size = CGSize(width: width, height: height)
        button.addSubview(imageView)
        return button
    }()
    
    private let circleView1: UIView = {
        let view = UIView()
        let size: CGFloat = 120
        let centerValue: CGFloat = (UIScreen.main.bounds.width-size) / 2
        view.frame = CGRect(x: centerValue, y: centerValue, width: size, height: size)
        view.layer.cornerRadius = view.layer.frame.size.width / 2
        view.backgroundColor = UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 0.50)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let circleView2: UIView = {
        let view = UIView()
        let size: CGFloat = 120
        let centerValue: CGFloat = (UIScreen.main.bounds.width-size) / 2
        view.frame = CGRect(x: centerValue, y: centerValue, width: size, height: size)
        view.layer.cornerRadius = view.layer.frame.size.width / 2
        view.backgroundColor = UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 0.50)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let circleView3: UIView = {
        let view = UIView()
        let size: CGFloat = 120
        let centerValue: CGFloat = (UIScreen.main.bounds.width-size) / 2
        view.frame = CGRect(x: centerValue, y: centerValue, width: size, height: size)
        view.layer.cornerRadius = view.layer.frame.size.width / 2
        view.backgroundColor = UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 0.50)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        let size: CGFloat = 140
        let centerValue: CGFloat = (UIScreen.main.bounds.width-size) / 2
        imageView.image = UIImage(named: "unfilledMicrophoneIcon")//UIImage(named: "microphoneIcon")
        imageView.frame = CGRect(x: centerValue, y: centerValue, width: size, height: size)
        imageView.layer.cornerRadius = size/2
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = false
        return imageView
    }()
    
    private let microphoneFakeButton: UIButton = {
        let button = UIButton()
        let size: CGFloat = 140
        let centerValue: CGFloat = (UIScreen.main.bounds.width-size) / 2
        button.frame = CGRect(x: centerValue, y: centerValue, width: size, height: size)
        button.isHidden = false
        button.setTitle("", for: .normal)
        button.setTitle("", for: .highlighted)
        return button
    }()
    
    private var isAudioEngineRunning: Bool = false
    private var audioInputBusCounter: Int = 0
    var delegate: MicrophoneViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        microphoneFakeButton.addTarget(self, action: #selector(imageViewTapped(_:)), for: .touchUpInside)
        view.backgroundColor = simpleBackgroundColor.withAlphaComponent(0.20)
        setupConstraints()
        startSoundWaveAnimation()
        setupDoubleTapRecognizer(view: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.microphoneImageView.circleAnimation(image: self.microphoneImageView, borderColor: self.mainColor, cornerRadious: 70, animationTime: 1.0)
        }
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("view is to be dismissed")
        if audioEngine.isRunning {
            stopRecording()
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            speechTextLabel.heightAnchor.constraint(equalToConstant: 120),
            speechTextLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 16),
            speechTextLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40),
            speechTextLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            lowerView.heightAnchor.constraint(equalToConstant: 160),
            lowerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            lowerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            lowerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            
            microphoneImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            microphoneImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            microphoneImageView.widthAnchor.constraint(equalToConstant: 140),
            microphoneImageView.heightAnchor.constraint(equalToConstant: 140),
            
            microphoneFakeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            microphoneFakeButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            microphoneFakeButton.widthAnchor.constraint(equalToConstant: 140),
            microphoneFakeButton.heightAnchor.constraint(equalToConstant: 140),
            
            circleView1.centerXAnchor.constraint(equalTo: microphoneImageView.centerXAnchor),
            circleView1.centerYAnchor.constraint(equalTo: microphoneImageView.centerYAnchor),
            circleView1.widthAnchor.constraint(equalToConstant: 120),
            circleView1.heightAnchor.constraint(equalToConstant: 120),
            circleView2.centerXAnchor.constraint(equalTo: microphoneImageView.centerXAnchor),
            circleView2.centerYAnchor.constraint(equalTo: microphoneImageView.centerYAnchor),
            circleView2.widthAnchor.constraint(equalToConstant: 120),
            circleView2.heightAnchor.constraint(equalToConstant: 120),
            circleView3.centerXAnchor.constraint(equalTo: microphoneImageView.centerXAnchor),
            circleView3.centerYAnchor.constraint(equalTo: microphoneImageView.centerYAnchor),
            circleView3.widthAnchor.constraint(equalToConstant: 120),
            circleView3.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupView() {
        let views: [UIView] = [fullBlurView, upperLineView, lowerView, circleView1, circleView2, circleView3, microphoneImageView]
        for subview in views {
            view.addSubview(subview)
        }
        view.addSubview(microphoneFakeButton)
        lowerView.addSubview(speechTextLabel)
        upperLineView.addSubview(backButton)
        speechRecognizer = addVoiceRecognier(language: .English)
    }
    
    private func setupDoubleTapRecognizer(view: UIView) {
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.numberOfTouchesRequired = 2
        view.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
    
    private func addVoiceRecognier(language: VoiceLanguage) -> SFSpeechRecognizer {
        let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: language.rawValue))
        speechRecognizer?.delegate = self
        return speechRecognizer!
    }
    
    private func startRecording() throws {
        // Cancel the previous recognition task.
        //startSoundWaveAnimation()
        HapticsManager.shared.vibrateForSelection()
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Audio session, to get information from the microphone.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // The AudioBuffer
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest!.shouldReportPartialResults = true
        
        // Force speech recognition to be on-device
        if #available(iOS 13, *) {
            recognitionRequest!.requiresOnDeviceRecognition = true
        }
        
        // Actually create the recognition task. We need to keep a pointer to it so we can stop it.
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                print("Text: \(result.bestTranscription.formattedString)")
                self.speechTextLabel.text = result.bestTranscription.formattedString
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        // Configure the microphone.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        // The buffer size tells us how much data should the microphone record before dumping it into the recognition request.
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
        self.microphoneImageView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
     
    private func startTimerDown() {
        startSoundWaveAnimation()
        animationTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(startSoundWaveAnimation), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        print("starting timer counts: \(countDown)")
        startTimerDown()
        countdownTimer?.invalidate()
        do {
            try startRecording()
        } catch {
            print("Could not start the recording")
        }
    }
    
    @objc private func startSoundWaveAnimation() {
        let xValueOrigin: CGFloat = self.microphoneImageView.frame.origin.x+10
        let yValueOrigin: CGFloat = self.microphoneImageView.frame.origin.y+10
        let originalSize: CGFloat = 120
        let targetSize: CGFloat = originalSize * 2
        let targetX: CGFloat = xValueOrigin-60
        let targetY: CGFloat = yValueOrigin-60

        
        DispatchQueue.main.async {
            if self.audioEngine.isRunning {
                for view in [self.circleView1, self.circleView2, self.circleView3] {
                    view.isHidden = false
                }
                UIView.animate(withDuration: 1.0, delay: 0) {
                    self.circleView1.layer.cornerRadius = targetSize/2
                    self.circleView1.frame = CGRect(x: targetX, y: targetY, width: targetSize, height: targetSize)
                    
                    UIView.animate(withDuration: 1.0, delay: 1.00) {
                        self.circleView1.layer.cornerRadius = originalSize/2
                        self.circleView1.frame = CGRect(x: xValueOrigin, y: yValueOrigin, width: originalSize, height: originalSize)
                    }
                }
                
                UIView.animate(withDuration: 1.0, delay: 0.50) {
                    self.circleView2.layer.cornerRadius = targetSize/2
                    self.circleView2.frame = CGRect(x: targetX, y: targetY, width: targetSize, height: targetSize)
                    
                    UIView.animate(withDuration: 1.0, delay: 1.50) {
                        self.circleView2.layer.cornerRadius = originalSize/2
                        self.circleView2.frame = CGRect(x: xValueOrigin, y: yValueOrigin, width: originalSize, height: originalSize)
                    }
                }
                
                UIView.animate(withDuration: 1.0, delay: 1.0) {
                    self.circleView3.layer.cornerRadius = targetSize/2
                    self.circleView3.frame = CGRect(x: targetX, y: targetY, width: targetSize, height: targetSize)
                    
                    UIView.animate(withDuration: 1.0, delay: 2.0) {
                        self.circleView3.layer.cornerRadius = originalSize/2
                        self.circleView3.frame = CGRect(x: xValueOrigin, y: yValueOrigin, width: originalSize, height: originalSize)
                    }
                }
            }
        }
    }
    
    private func stopRecording() {
        for view in [self.circleView1, self.circleView2, self.circleView3] {
            view.layer.cornerRadius = 60
            view.isHidden = true
        }
        audioEngine.stop()
        self.audioEngine.reset()
        self.recognitionRequest = nil
        self.recognitionTask = nil
        isAudioEngineRunning = false
        audioInputBusCounter = audioInputBusCounter + 1
        animationTimer?.invalidate()
        microphoneImageView.circleAnimation(image: microphoneImageView, borderColor: mainColor, cornerRadious: 70, animationTime: 2.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.sendSpokenQuestion()
        }
    }
    
    @objc private func handleDoubleTap() {
        if audioEngine.isRunning {
            stopRecording()
        }
    }
    
    @objc func imageViewTapped(_ sender: UIButton) {
        if audioEngine.isRunning {
            stopRecording()
        }
    }
    
    private func sendSpokenQuestion() {
        guard speechTextLabel.text != nil else {
            print("going back")
            dismiss(animated: true, completion: nil)
            return
        }
        delegate?.didAddSpeechToText(speechTextLabel.text ?? "Failled to record question")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        print("going back")
        if audioEngine.isRunning {
            stopRecording()
        } else {
            sendSpokenQuestion()
        }
        //dismiss(animated: true, completion: nil)
    }
}

extension MicrophoneViewController: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            "STARTED VOICE ROCOGNITION"
        } else {
            print("fuck you")
        }
    }
}
