//
//  GalleryRouter.swift
//  Obvious-Project
//
//  Created by Babul Raj on 03/03/23.
//

import Foundation
import SwiftUI

class GalleryRouter {
    func initialiseGallery() -> some View {
        return ContentView(presenter: ImageListPresenter(interactor: GalleryInteractor(networker: NetWorker(urlSession: URLSession.shared))))
    }
}
