//
//  ImageListPresenter.swift
//  Obvious-Project
//
//  Created by Babul Raj on 02/03/23.
//

import Foundation
import SwiftUI

extension Error where Self == ApiError {
    var description: String {
        return self.description
    }
}

final class ImageListPresenter: ObservableObject {
    @Published var imageList:[ImageModel] = []
    @Published var error: ApiError?
    @Published var showError = false
    
    let interactor:GalleryInteractorProtocol
    
    init(interactor: GalleryInteractorProtocol) {
        self.interactor = interactor
    }
    
    func getImages() {
        Task.detached {
            do {
                let imageList =  try await self.interactor.getImages()
                await self.updateImageList(imageList: imageList)
            } catch {
                await self.updateError(error: error as? ApiError)
            }
        }
    }
    
    
    @MainActor
    func updateImageList(imageList:[ImageModel]) {
        self.imageList = imageList
        self.error = nil
        self.showError = false
    }
    
    @MainActor
    func updateError(error:ApiError?) {
        self.error = error
        self.showError = true
    }
}
