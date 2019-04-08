//
//  ConverterRepository.swift
//  WeightConverter
//
//  Created by Efrén Pérez Bernabe on 4/7/19.
//  Copyright © 2019 Efrén Pérez Bernabe. All rights reserved.
//

import Foundation

/// Use `Result` for provided response.
enum Result {
    case success(Data)
    case fail(Error)
}

/// Common errors.
enum RepositoryError: Error {
    case dataIsNil
}

class ConverterRepository {
    
    /// Perform a SOAP request
    func execute(request: URLRequest, completion: @escaping (_ outputData: Result) -> Void) {
            
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(Result.fail(error))
                return
            }
            guard let data = data else {
                completion(Result.fail(RepositoryError.dataIsNil))
                return
            }
            
            completion(Result.success(data))
        }.resume()
    }
}
