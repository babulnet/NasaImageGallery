//
//  APILayer.swift
//  Obvious-Project
//
//  Created by Babul Raj on 02/03/23.
//

import Foundation

protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}
extension URLSession:URLSessionProtocol {}

enum ApiError: Error, CustomStringConvertible {
    
    case badURL
    case badResponse(statusCode: Int)
    case url(URLError?)
    case parsing
    case unknown
    case noInternet
    
    var description: String {
        //info for debugging
        switch self {
        case .unknown: return "unknown error"
        case .badURL: return "invalid URL"
        case .url(let error):
            return error?.localizedDescription ?? "url session error"
        case .parsing:
            return "parsing error"
        case .badResponse(statusCode: let statusCode):
            return "bad response with status code \(statusCode)"
        case .noInternet:
            return "No Internet"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .badURL, .parsing, .unknown:
            return "Sorry, something went wrong."
        case .badResponse(_):
            return "Sorry, the connection to our server failed."
        case .url(let error):
            return error?.localizedDescription ?? "Something went wrong."
        case .noInternet:
            return "Please check your internet connection"
        }
    }
}

enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

protocol Request {
  var url: URL {get }
  var httpmethod:HTTPMethod {get }
}

protocol NetworkerProtocol {
    func fetch(request: Request) async throws -> Data
}

final class NetWorker:NetworkerProtocol {
    let urlSession:URLSessionProtocol
   
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    func fetch(request: Request) async throws -> Data  {
        var httpRequest = URLRequest(url: request.url)
      
        httpRequest.httpMethod = request.httpmethod.rawValue
        do {
            let (data,response) = try await urlSession.data(for: httpRequest, delegate: nil)
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)  {
                return data
            } else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                throw ApiError.badResponse(statusCode: statusCode)
            }
        }
        catch {
            throw error
        }
    }
}
