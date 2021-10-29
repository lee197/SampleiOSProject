//
//  LotteryRepository.swift
//  lottery
//
//  Created by Jason Lee on 29/10/2021.
//

import Foundation

enum APIError: Error {
    case clientError(description: String)
    case serverError
    case noData
    case httpError(description: String)
    case dataDecodingError
}

protocol LotteryInfoFetchable {
    func fetchLotteryList(complete completionHandler: @escaping (Result<LotteryListAPIModel, APIError>) -> Void)
    func fetchLotteryDetails(with ticketNumber: String, complete completionHandler: @escaping (Result<LotteryDetailAPIModel, APIError>) -> Void)
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
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let networkError = error {
                completionHandler(.failure(.clientError(description: networkError.localizedDescription)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completionHandler(.failure(.serverError))
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
    
    func fetchLotteryDetails(with ticketNumber: String, complete completionHandler: @escaping (Result<LotteryDetailAPIModel, APIError>) -> Void) {
        guard let url = makeLotteryDetailComponents(ticketNumber).url else {
            let error = APIError.httpError(description: "Couldn't create URL")
            completionHandler(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let networkError = error {
                completionHandler(.failure(.clientError(description: networkError.localizedDescription)))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completionHandler(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            do{
                let value = try decoder.decode(LotteryDetailAPIModel.self, from: data)
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
    
    func makeLotteryDetailComponents(_ ticketNumber: String) -> URLComponents {
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
