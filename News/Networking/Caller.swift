//
//  Caller.swift
//  News
//
//  Created by Gökhan KOCA on 8.10.2021.
//

import Foundation
import Combine

enum APIError: Error, LocalizedError {
  case unknown, apiError(reason: String)
  
  var errorDescription: String? {
    switch self {
    case .unknown:
      return "Unknown error"
    case .apiError(let reason):
      return reason
    }
  }
}

enum HTTPMethod: String {
  case get = "GET"
}

protocol Caller {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
}

extension Caller {
  
  public func call<T: Decodable>(_:T.Type, shoudShowLoading: Bool = true) -> AnyPublisher<T, APIError> {
    call(createRequest(), shoudShowLoading: shoudShowLoading)
  }
  
  private func createRequest() -> URLRequest {
    var request = URLRequest(url: baseURL.appendingPathComponent(path))
    request.httpMethod = method.rawValue
    request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    return request
  }
  
  private func call<T: Decodable>(_ urlRequest: URLRequest, shoudShowLoading: Bool) -> AnyPublisher<T, APIError> {
    
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    if shoudShowLoading {
      Loading.show()
    }
    return URLSession.DataTaskPublisher(request: urlRequest, session: .shared)
      .tryMap { data, response in
        Loading.hide()
        print(data)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
          throw APIError.unknown
        }
        return data
      }
      .decode(type: T.self, decoder: decoder)
      .mapError { error in
        print(error)
        Loading.hide()
        if let error = error as? APIError {
          return error
        } else {
          return APIError.apiError(reason: error.localizedDescription)
        }
      }
      .eraseToAnyPublisher()
  }
}
