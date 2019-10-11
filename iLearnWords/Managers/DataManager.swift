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
            completion(nil, .invalidLanguateWay)
            return
             }
        guard let escapedString = word.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let str = String(format: API.baseURL, APIKey, escapedString ,translateWay)
        guard let url = URL(string: str) else { return }
        
        // Create Data Task
        URLSession.shared.dataTask(with: url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success( _, let data):
                    do {
                        // Decode JSON
                        let translationData: TranslationData = try JSONDecoder.decode(data: data)
                        // Invoke Completion Handler
                        completion(translationData.text.first, nil)
                    }
                    catch {
                        // Invoke Completion Handler
                        completion(nil, .invalidResponse)
                    }
                    break
                case .failure(_):
                    do {
                        let reachability = try Reachability.init(hostname: "www.google.com")
                        if reachability.connection != .unavailable {
                            completion(nil, .failedNoInternetConnection)
                        }
                    }
                    catch {
                        completion(nil, .failedRequest)
                    }
                    break
                }
            }
        }.resume()
    }
}

// MARK: - URLSession extension
extension URLSession {
    func dataTask(with url: URL, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
    }
}

// MARK: - Error Handler Localized descriptions
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
