//
//  ImageListPresenterTest.swift
//  Obvious-ProjectTests
//
//  Created by Babul Raj on 03/03/23.
//

import XCTest
@testable import Obvious_Project
final class ImageListPresenterTest: XCTestCase {

    var sut: ImageListPresenter!
    override func setUpWithError() throws {
       
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetImagesSuccess() async throws {
        sut = ImageListPresenter(interactor: MockGalleryInteractorSuccess())
        Task.detached {
            self.sut.getImages()
            await MainActor.run(body: {
                XCTAssertEqual(self.sut.imageList.count, 2)
                XCTAssertNil(self.sut.error)
            })
        }
    }
    
    func testGetImagesFailure() async throws {
        sut = ImageListPresenter(interactor: MockGalleryInteractorFailure())
        Task.detached {
            self.sut.getImages()
            await MainActor.run(body: {
                XCTAssertEqual(self.sut.imageList.count, 0)
                XCTAssertNotNil(self.sut.error)
                XCTAssertTrue(self.sut.showError)
            })
        }

    }
}

class MockGalleryInteractorSuccess:GalleryInteractorProtocol {
    func getImages() async throws -> [ImageModel] {
        
        return [ImageModel(title: "title1", url: "", explanation: "this is explanation1"),ImageModel(title: "title2", url: "", explanation: "this is explanation2")]
    }
}

class MockGalleryInteractorFailure:GalleryInteractorProtocol {
    func getImages() async throws -> [ImageModel] {
        
        throw ApiError.badResponse(statusCode: 401)
    }
}
