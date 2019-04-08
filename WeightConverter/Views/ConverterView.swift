//
//  ConverterView.swift
//  WeightConverter
//
//  Created by Efrén Pérez Bernabe on 4/7/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation
import UIKit

/// `ConvertView` delegate
protocol ConverterViewDelegate: class {
    func converterView(_ converterView: ConverterView, didTapConvert button: UIButton)
}

final class ConverterView: UIView {
    
    // MARK: Internal properties
    weak var delegate: ConverterViewDelegate?
    
    // MARK: - Public properties
    var inputText: String {
        get {
            return inputTextField.text ?? ""
        }
        set {
            inputTextField.text = newValue
        }
    }
    
    var outputText: String {
        get {
            return outputTextField.text ?? ""
        }
        set {
            outputTextField.text = newValue
        }
    }
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Initializes UI elements
    private func setup() {
        backgroundColor = Color.mainColor
        addSubview(title)
        addSubview(inputTextField)
        addSubview(convertButton)
        addSubview(outputTextField)
        
        // Actions
        let convertSelector = #selector(convertButtonTouchUpInside(_:))
        
        convertButton.addTarget(self, action: convertSelector, for: .touchUpInside)
    }
    
    // MARK: ConverterView delegates
    @objc func convertButtonTouchUpInside(_ sender: UIButton) {
        delegate?.converterView(self, didTapConvert: sender)
    }
    
    // MARK: - Private properties
    private var isViewConstrained = false
    
    lazy private var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = Color.title
        label.backgroundColor = Color.titleBackground
        label.textAlignment = .left
        label.text = " \t Kilograms to Pounds"
        return label
    }()
    
    lazy private var convertButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.setTitle("CONVERT", for: .normal)
        button.setTitleColor(Color.title, for: .normal)
        button.backgroundColor = Color.buttonBackground
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textColor = Color.text
        textField.layer.borderColor = Color.text.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.placeholder = "Kilograms"
        textField.keyboardType = UIKeyboardType.decimalPad
        return textField
    }()
    
    lazy private var outputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.textColor = Color.text
        textField.layer.borderColor = Color.text.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.textAlignment = .center
        textField.placeholder = "Pounds"
        textField.isEnabled = false
        return textField
    }()
    
    override public class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
    override func updateConstraints() {
        setupConstraints()
        super.updateConstraints()
    }
    
    private func setupConstraints() {
        if !isViewConstrained {
            let contraints = [
                // Title
                title.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
                title.heightAnchor.constraint(equalToConstant: 60),
                title.widthAnchor.constraint(equalTo: widthAnchor),
                // Input Text Field
                inputTextField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 80),
                inputTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                inputTextField.heightAnchor.constraint(equalToConstant: 40),
                inputTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -100),
                // Convert Button View
                convertButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 50),
                convertButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                convertButton.widthAnchor.constraint(equalToConstant: frame.width / 4),
                convertButton.heightAnchor.constraint(equalToConstant: frame.height / 20),
                // Output Text Field
                outputTextField.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 50),
                outputTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
                outputTextField.heightAnchor.constraint(equalToConstant: 40),
                outputTextField.widthAnchor.constraint(equalTo: widthAnchor, constant: -100)
            ]
            NSLayoutConstraint.activate(contraints)
            isViewConstrained = true
        }
    }
}
