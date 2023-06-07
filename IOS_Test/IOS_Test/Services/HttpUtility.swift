//
//  HttpUtility.swift
//  MvvmDemoApp
//
//  Created by Codecat15 on 3/14/2020.
//  Copyright © 2020 Codecat15. All rights reserved.
//

import Foundation
protocol JokeServiceDelegate {
    func fetchResponse<T: Decodable>(apiURL: URL, completion: @escaping (Result<T, Error>) -> Void)
}

struct HttpUtility:JokeServiceDelegate
{
    func fetchResponse<T: Decodable>(apiURL: URL, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                do {
                    let decodedResult = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResult))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NSError(domain: Constants.ErrorAlertMessage, code: 0, userInfo: nil)))
            }
        }.resume()
    }
}


    
