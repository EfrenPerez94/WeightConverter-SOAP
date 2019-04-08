//
//  ViewController.swift
//  WeightConverter
//
//  Created by Efrén Pérez Bernabe on 4/7/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import UIKit

class ConverterViewController: UIViewController, ConverterViewDelegate, NSURLConnectionDelegate, XMLParserDelegate {
    
    // Public properties
    let converterView = ConverterView()
    var elementName: String = ""
    
    // MARK: - Life View Cycle
    override func loadView() {
        converterView.delegate = self
        self.view = converterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - Converter View Delegate
extension ConverterViewController {
    
    func converterView(_ converterView: ConverterView, didTapConvert button: UIButton) {
        
        guard let request = URLRequest.weightConverter(inputData: converterView.inputText) else {
            return
        }
        
        let converter = ConverterRepository()
        
        converter.execute(request: request) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let data):
                let myparser = XMLParser(data: data)
                myparser.delegate = weakSelf
                myparser.parse()
                myparser.shouldResolveExternalEntities = true
            case .fail(let error):
                let alert = UIAlertController(title: "Something happened",
                                              message: "\(error)",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                DispatchQueue.main.async {
                    weakSelf.present(alert, animated: true)
                }
            }
        }
    }
}

// MARK: - Parser
extension ConverterViewController {
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if elementName == "Pound" {
            guard var pound = Double(string) else {
                return
            }
            pound = Double(round(1000 * pound) / 1000)
            DispatchQueue.main.async {
                self.converterView.outputText = "\(pound)"
            }
        }
    }
}
