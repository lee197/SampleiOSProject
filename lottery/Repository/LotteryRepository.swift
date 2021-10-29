//
//  LotteryRepository.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

enum APIError: Error {
    case networkError
    case noData
    case httpError(description: String)
    case dataDecodingError
}

protocol LotteryInfoFetchable {
    func fetchLotteryList(complete completionHandler: @escaping (Result<LotteryListAPIModel, APIError>) -> Void)
    func fetchLotteryResults(with ticketNumber: String, complete completionHandler: @escaping (Result<LotteryResultAPIModel, APIError>) -> Void)
}

class LotteryRepository {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension LotteryRepository: LotteryInfoFetchable {
    
    func fetchLotteryList(complete completionHandler: @escaping (Result<LotteryListAPIModel, APIError>) -> Void) {
        guard let url = makeLotteryListComponents().url else {
            let error = APIError.httpError(description: "Couldn't create URL")
            completionHandler(.failure(error))
            return
        }
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let value = try decoder.decode(LotteryListAPIModel.self, from: data)
                completionHandler(.success(value))
            }catch{
                completionHandler(.failure(.dataDecodingError))
            }
        }.resume()
    }
    
    func fetchLotteryResults(with ticketNumber: String, complete completionHandler: @escaping (Result<LotteryResultAPIModel, APIError>) -> Void) {
        guard let url = makeLotteryResultComponents(ticketNumber).url else {
            let error = APIError.httpError(description: "Couldn't create URL")
            completionHandler(.failure(error))
            return
        }
        
        session.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completionHandler(.failure(.networkError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let value = try decoder.decode(LotteryResultAPIModel.self, from: data)
                completionHandler(.success(value))
            }catch{
                completionHandler(.failure(.dataDecodingError))
            }
        }.resume()
    }
}

private extension LotteryRepository {
    
    struct LotteryApi {
        static let scheme = "https"
        static let host = "by82fsbdwk.execute-api.eu-west-1.amazonaws.com"
        static let path = "/prod/ticket"
    }
    
    
    func makeLotteryListComponents() -> URLComponents {
        return creatComponent()
    }
    
    func makeLotteryResultComponents(_ ticketNumber: String) -> URLComponents {
        var components = creatComponent()
        components.path = "/prod/ticket/\(ticketNumber)"
        return components
    }
    
    private func creatComponent() -> URLComponents {
        var components = URLComponents()
        components.scheme = LotteryApi.scheme
        components.host = LotteryApi.host
        components.path = LotteryApi.path
        
        return components
    }
}
