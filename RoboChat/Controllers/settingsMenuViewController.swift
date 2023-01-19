//
//  settingsMenuViewController.swift
//  RoboChat
//
//  Created by Daniel Karath on 1/18/23.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func didChangeAppLanguage()
}

class settingsMenuViewController: UIViewController {

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
    
    private let settingsBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "simpleBackgroundColor") ?? UIColor(red: 28/255, green: 28/255, blue: 32/255, alpha: 0.0)
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.tintColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.textAlignment = .center
        label.contentMode = .top
        label.numberOfLines = 1
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
    
    private let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        let size: CGFloat = 80
        let centerValue: CGFloat = (UIScreen.main.bounds.width-size) / 2
        let yValue: CGFloat = 82
        imageView.image = UIImage(named: "AppIcon")//UIImage(named: "microphoneIcon")
        imageView.frame = CGRect(x: centerValue, y: yValue, width: size, height: size)
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isHidden = false
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Bundle.main.appName!)"
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.textColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.tintColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.textAlignment = .center
        label.contentMode = .top
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let appDetailsLabel: UILabel = {
        let label = UILabel()
        label.text = "Version: \(Bundle.main.appVersion!), Build: \(Bundle.main.buildNumber!)"
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.tintColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.textAlignment = .center
        label.contentMode = .top
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let developerLabel: UILabel = {
        let label = UILabel()
        label.text = "Developed by Daniel Karath"
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.tintColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.textAlignment = .center
        label.contentMode = .top
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language"
        label.font = UIFont(name: "Avenir Next", size: 15)
        label.textColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.tintColor = UIColor(red: 212/255, green: 212/244, blue: 216/255, alpha: 1.0)
        label.textAlignment = .left
        label.contentMode = .top
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let englishButton: UIButton = {
        let button = UIButton()
        let title: String = "English"
        let mainColor: UIColor = UIColor(named: "mainColor") ?? UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
        let fontColor: UIColor = UIColor(red: 247/255, green: 247/255, blue: 251/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        let range = (title as NSString).range(of: title)
        var buttonFont: UIFont?
        buttonFont = UIFont(name: "Avenir Next", size: 13)
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSMutableAttributedString.Key.font: buttonFont!])
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        attributedText.addAttribute(NSAttributedString.Key.kern, value: 1.2, range: range)
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = mainColor
        return button
    }()
    
    private let frenchButton: UIButton = {
        let button = UIButton()
        let title: String = "Français"
        let mainColor: UIColor = UIColor(named: "mainColor") ?? UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
        let fontColor: UIColor = UIColor(red: 247/255, green: 247/255, blue: 251/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        let range = (title as NSString).range(of: title)
        var buttonFont: UIFont?
        buttonFont = UIFont(name: "Avenir Next", size: 13)
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSMutableAttributedString.Key.font: buttonFont!])
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        attributedText.addAttribute(NSAttributedString.Key.kern, value: 1.2, range: range)
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = mainColor
        return button
    }()
    
    private let spanishButton: UIButton = {
        let button = UIButton()
        let title: String = "Español"
        let mainColor: UIColor = UIColor(named: "mainColor") ?? UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
        let fontColor: UIColor = UIColor(red: 247/255, green: 247/255, blue: 251/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        let range = (title as NSString).range(of: title)
        var buttonFont: UIFont?
        buttonFont = UIFont(name: "Avenir Next", size: 13)
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSMutableAttributedString.Key.font: buttonFont!])
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        attributedText.addAttribute(NSAttributedString.Key.kern, value: 1.2, range: range)
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = mainColor
        return button
    }()
    
    private let swedishButton: UIButton = {
        let button = UIButton()
        let title: String = "Svenska"
        let mainColor: UIColor = UIColor(named: "mainColor") ?? UIColor(red: 120/255, green: 120/244, blue: 220/255, alpha: 1.0)
        let fontColor: UIColor = UIColor(red: 247/255, green: 247/255, blue: 251/255, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        let range = (title as NSString).range(of: title)
        var buttonFont: UIFont?
        buttonFont = UIFont(name: "Avenir Next", size: 13)
        let attributedText = NSMutableAttributedString(string: title, attributes: [NSMutableAttributedString.Key.font: buttonFont!])
        attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: fontColor, range: range)
        attributedText.addAttribute(NSAttributedString.Key.kern, value: 1.2, range: range)
        button.setAttributedTitle(attributedText, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = mainColor
        return button
    }()
    
    private lazy var languageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        overrideUserInterfaceStyle = .dark
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        setupAccessibility()
    }

    private func setupView() {
        let views: [UIView] = [fullBlurView, upperLineView, settingsBackgroundView, appIconImageView, appNameLabel, appDetailsLabel, developerLabel]
        for subview in views {
            view.addSubview(subview)
        }
        upperLineView.addSubview(backButton)
        upperLineView.addSubview(viewTitleLabel)
        settingsBackgroundView.addSubview(languageLabel)
        settingsBackgroundView.addSubview(languageStackView)
        let languageButtons: [UIButton] = [englishButton, frenchButton, spanishButton, swedishButton]
        setupLanguageButton(buttons: languageButtons)
        for button in languageButtons {
            languageStackView.addArrangedSubview(button)
            button.addTarget(self, action: #selector(languageButtonTapped(_:)), for: .touchUpInside)
        }
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            settingsBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            settingsBackgroundView.topAnchor.constraint(equalTo: upperLineView.bottomAnchor, constant: 220),
            settingsBackgroundView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            settingsBackgroundView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            
            viewTitleLabel.centerXAnchor.constraint(equalTo: upperLineView.centerXAnchor, constant: 0),
            viewTitleLabel.centerYAnchor.constraint(equalTo: upperLineView.centerYAnchor),
            viewTitleLabel.heightAnchor.constraint(equalToConstant: 25),
            viewTitleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            appIconImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            appIconImageView.topAnchor.constraint(equalTo: upperLineView.bottomAnchor, constant: 32),
            appIconImageView.heightAnchor.constraint(equalToConstant: 80),
            appIconImageView.widthAnchor.constraint(equalToConstant: 80),
            
            appNameLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            appNameLabel.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 18),
            appNameLabel.heightAnchor.constraint(equalToConstant: 30),
            appNameLabel.widthAnchor.constraint(equalToConstant: 140),
            
            appDetailsLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            appDetailsLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 0),
            appDetailsLabel.heightAnchor.constraint(equalToConstant: 20),
            appDetailsLabel.widthAnchor.constraint(equalToConstant: 200),
            
            developerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            developerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 4),
            developerLabel.heightAnchor.constraint(equalToConstant: 20),
            developerLabel.widthAnchor.constraint(equalToConstant: 200),
            
            languageLabel.leadingAnchor.constraint(equalTo: settingsBackgroundView.leadingAnchor, constant: 40),
            languageLabel.topAnchor.constraint(equalTo: settingsBackgroundView.topAnchor, constant: 32),
            languageLabel.heightAnchor.constraint(equalToConstant: 30),
            languageLabel.widthAnchor.constraint(equalToConstant: 140),
            
            languageStackView.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 8),
            languageStackView.leadingAnchor.constraint(equalTo: settingsBackgroundView.leadingAnchor, constant: 32),
            languageStackView.trailingAnchor.constraint(equalTo: settingsBackgroundView.trailingAnchor, constant: -32),
            languageStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupLanguageButton(buttons: [UIButton]) {
        let language: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-US"
        let selectedLanguage = LanguageManager.shared.convertStringToLanguage(selectedLanguage: language)
        var selectedLanguageButton: Int = 0
        var backgroundColor: UIColor = simpleBackgroundColor
        var borderColor: UIColor = textColor
        var i: Int = 0
        switch selectedLanguage {
        case .English:
            selectedLanguageButton = 0
        case .French:
            selectedLanguageButton = 1
        case .Spanish:
            selectedLanguageButton = 2
        case .Swedish:
            selectedLanguageButton = 3
        default:
            selectedLanguageButton = 0
        }
        for button in buttons {
            if i == selectedLanguageButton {
                backgroundColor = mainColor
                borderColor = mainColor
            } else {
                backgroundColor = simpleBackgroundColor
                borderColor = textColor
            }
            button.layer.cornerRadius = 8
            button.backgroundColor = backgroundColor
            button.layer.borderWidth = 1.5
            button.layer.borderColor = borderColor.cgColor
            i = i + 1
        }
    }
    
    private func setupAccessibility() {
        viewTitleLabel.accessibilityLabel = LanguageManager.shared.setAccessibilityLabelFor(element: .settingsSettingsTitleLabel)
        languageLabel.accessibilityLabel = LanguageManager.shared.setAccessibilityLabelFor(element: .settingsLanguageLabel)
        developerLabel.accessibilityLabel = LanguageManager.shared.setAccessibilityLabelFor(element: .settingsDevelopedByLabel)
        backButton.accessibilityLabel = LanguageManager.shared.setAccessibilityLabelFor(element: .backButton)
        
        viewTitleLabel.text = LanguageManager.shared.setTitleLabelFor(element: .settingsSettingsTitleLabel)
        languageLabel.text = LanguageManager.shared.setTitleLabelFor(element: .settingsLanguageLabel)
        developerLabel.text = LanguageManager.shared.setTitleLabelFor(element: .settingsDevelopedByLabel)
    }
    
    @objc private func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func languageButtonTapped(_ sender: UIButton) {
        print("Did tap on language button")
        let languageButtons: [UIButton] = [englishButton, frenchButton, spanishButton, swedishButton]
        var selectedLanguage: SelectedLanguage = .English
        switch sender {
        case englishButton:
            selectedLanguage = .English
        case frenchButton:
            selectedLanguage = .French
        case spanishButton:
            selectedLanguage = .Spanish
        case swedishButton:
            selectedLanguage = .Swedish
        default:
            selectedLanguage = .English
        }
        LanguageManager.shared.setLanguage(selectedLanguage: selectedLanguage)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.15) {
            let language: String = UserDefaults.standard.object(forKey: "language") as? String ?? "en-US"
            print("language: \(language)")
            self.setupLanguageButton(buttons: languageButtons)
            self.setupAccessibility()
            self.delegate?.didChangeAppLanguage()
        }
    }
    
}
