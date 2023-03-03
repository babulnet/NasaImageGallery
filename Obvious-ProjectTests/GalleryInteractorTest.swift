//
//  GalleryInteractorTest.swift
//  Obvious-ProjectTests
//
//  Created by Babul Raj on 03/03/23.
//

import XCTest
@testable import Obvious_Project

final class GalleryInteractorTest: XCTestCase {

    var sut:GalleryInteractor!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchImageSucess() async throws {
        sut = GalleryInteractor(networker: MockNetWorkerSuccess())
        do {
            let imageList = try await sut.getImages()
            XCTAssertEqual(imageList.count, 1)
            XCTAssertEqual(imageList[0].title, "title1")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func testFetchImageParsingFailure() async throws {
        sut = GalleryInteractor(networker: MockNetWorkerParsingFailure())
        do {
            let imageList = try await sut.getImages()
            XCTAssertEqual(imageList.count, 0)
        } catch {
            if Reachability.isConnectedToNetwork() {
                XCTAssertEqual((error as? ApiError)?.description, "parsing error")
            } else {
                XCTAssertEqual((error as? ApiError)?.description, "No Internet")
            }
        }
    }
    
    func testFetchImageStatusCodeFailure() async throws {
        sut = GalleryInteractor(networker: MockNetWorkerStatusCodeFailure())
        do {
            let imageList = try await sut.getImages()
            XCTAssertEqual(imageList.count, 0)
        } catch {
            if Reachability.isConnectedToNetwork() {
                XCTAssertEqual((error as? ApiError)?.description, "bad response with status code 401")
            } else {
                XCTAssertEqual((error as? ApiError)?.description, "No Internet")
            }
        }
    }

}

class MockNetWorkerSuccess:NetworkerProtocol {
    func fetch(request: Obvious_Project.Request) async throws -> Data {
        try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
        
        let networkModel = ImgageListNetworkmodel(copyright: nil, date: nil, explanation: "explanation1", hdurl: nil, mediaType: nil, serviceVersion: nil, title: "title1", url: nil)
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode([networkModel])
            return jsonData
            
        } catch {
            throw error
        }
    }
}

class MockNetWorkerStatusCodeFailure:NetworkerProtocol {
    func fetch(request: Obvious_Project.Request) async throws -> Data {
        try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
        
        throw ApiError.badResponse(statusCode: 401)
    }
}

class MockNetWorkerParsingFailure:NetworkerProtocol {
    func fetch(request: Obvious_Project.Request) async throws -> Data {
        try await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC)
        
            let networkModel = ImgageListNetworkmodel(copyright: nil, date: nil, explanation: "explanation1", hdurl: nil, mediaType: nil, serviceVersion: nil, title: "title1", url: nil)
            let jsonEncoder = JSONEncoder()
            do {
                let jsonData = try jsonEncoder.encode(networkModel)
                return jsonData
                
            } catch {
                throw ApiError.badResponse(statusCode: 401)
            }
    }
}


