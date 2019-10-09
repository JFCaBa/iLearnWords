//
//  DataManager.swift
//  iLearnWords
//
//  Created by Jose Catala on 30/09/2019.
//  Copyright © 2019 Armentechnology. All rights reserved.
//

import Foundation

enum DataManagerError: Error {
    case unknown
    case failedRequest
    case invalidResponse
    case invalidLanguateWay
    case failedEscapingString
    case failedNoInternetConnection
    case failedURL
}

final class DataManager {

    typealias TranslationDataCompletion = (String?, DataManagerError?) -> ()

    // MARK: - Properties

    private let APIKey: String

    // MARK: - Initialization

    init(APIKey: String) {
        
        self.APIKey = APIKey
    }

    // MARK: - Requesting Data

    func tranlationFor(word: String, completion: @escaping TranslationDataCompletion) {
        guard let translateWay = UserDefaults.standard.object(forKey: UserDefaults.keys.TranslateWay) as? String else {
            fatalError("TranslateWay not Set")
             }
        guard let escapedString = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let str = String(format: API.baseURL, APIKey, escapedString ,translateWay)
        guard let url = URL(string: str) else { return }
        
        // Create Data Task
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                self.didFetchTranslationData(data: data, response: response, error: error, completion: completion)
            }
        }.resume()
    }

    // MARK: - Helper Methods

    private func didFetchTranslationData(data: Data?, response: URLResponse?, error: Error?, completion: TranslationDataCompletion) {
        if let _ = error {
            do {
                let reachability = try Reachability.init(hostname: "www.google.com")
                if reachability.connection != .unavailable {
                    completion(nil, .failedNoInternetConnection)
                }
            }
            catch {
                completion(nil, .failedRequest)
            }

        } else if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                do {
                    // Decode JSON
                    let translationData: TranslationData = try JSONDecoder.decode(data: data)

                    // Invoke Completion Handler
                    completion(translationData.text.first, nil)

                } catch {
                    // Invoke Completion Handler
                    completion(nil, .invalidResponse)
                }

            } else {
                completion(nil, .failedRequest)
            }

        } else {
            completion(nil, .unknown)
        }
    }
}

extension DataManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .failedRequest:
            return "The request did Fail"
        case .invalidResponse:
            return "Invalid server response"
        case .invalidLanguateWay:
            return "Invalid passed Language"
        case .failedEscapingString:
            return "Error escaping the string"
        case .failedNoInternetConnection:
            return "Check your internet connection"
        case .failedURL:
            return "Failed creating URL"
        }
    }
}
