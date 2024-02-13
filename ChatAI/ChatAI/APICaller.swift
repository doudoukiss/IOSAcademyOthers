//
//  APICaller.swift
//  ChatAI
//
//  Created by Seattle on 2024/2/13.
//

import Foundation
import OpenAISwift

final class APICaller {
    static let shared = APICaller()
    
    @frozen enum Constants {
        static let key = "sk-23"
    }
    
    private var client: OpenAISwift?
    
    private init() {}
    
    public func setup() {
        let config = OpenAISwift.Config(apiKey: Constants.key)
        self.client = OpenAISwift(config: config)
        //self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getResponse(input: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, model: .codex(.davinci), completionHandler: { result in
            switch result {
            case .success(let model):
                print(String(describing: model.choices))
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
