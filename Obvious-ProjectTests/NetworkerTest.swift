//
//  Networker.swift
//  Obvious-ProjectTests
//
//  Created by Babul Raj on 03/03/23.
//

import XCTest
@testable import Obvious_Project

final class NetworkerTest: XCTestCase {

    var sut: NetWorker!
    override func setUpWithError() throws {
        sut = NetWorker(urlSession: MockURLSessionForSuccess())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testfetchDataSuccess() async {
        sut = NetWorker(urlSession: MockURLSessionForSuccess())
        let request = MockRequestSuccess()
        do {
           let data = try await sut.fetch(request: request)
            XCTAssertNotNil(data)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func testfetchDataFailure() async {
        sut = NetWorker(urlSession: MockURLSessionForFailure())
        let request = MockRequestSuccess()
        do {
           let data = try await sut.fetch(request: request)
            XCTAssertNotNil(data)
        } catch {
            XCTAssertEqual((error as? ApiError)?.description, "bad response with status code 401")
        }
    }
}

class MockURLSessionForSuccess:URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
        
        let networkModel = ImgageListNetworkmodel(copyright: nil, date: nil, explanation: "explanation1", hdurl: nil, mediaType: nil, serviceVersion: nil, title: "title1", url: nil)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode([networkModel])
            let urlResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (jsonData,urlResponse)
            
        } catch {
            throw error
        }
    }
}

class MockURLSessionForFailure:URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
        
        let networkModel = ImgageListNetworkmodel(copyright: nil, date: nil, explanation: "explanation1", hdurl: nil, mediaType: nil, serviceVersion: nil, title: "title1", url: nil)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode([networkModel])
            let urlResponse = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (jsonData,urlResponse)
            
        } catch {
            throw error
        }
    }
}


struct MockRequestSuccess:Request {
    var url: URL {
        URL(string: "https://raw.githubusercontent.com/obvious/take-home-exercise-data/trunk/nasa-pictures.json")!
    }
    
    var httpmethod: Obvious_Project.HTTPMethod {
        .get
    }
}
