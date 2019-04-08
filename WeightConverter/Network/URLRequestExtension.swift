//
//  URLRequestExtension.swift
//  WeightConverter
//
//  Created by Efrén Pérez Bernabe on 4/7/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation

extension URLRequest {
    
    static func weightConverter(inputData: String) -> URLRequest? {
        
        let endpoint = Network.converterURL
        
        let soapMessage = """
        <?xml version="1.0" encoding="utf-8"?> <soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Body><ConvertWeight xmlns="http://q88.com/webservices/"><property>Kilogram</property><val>\(inputData)</val></ConvertWeight></soap:Body></soap:Envelope>
        """
        
        guard let url = URL(string: endpoint) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        let msgLength = String(soapMessage.count)
        
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        request.httpMethod = "POST"
        request.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        return request
    }
}
