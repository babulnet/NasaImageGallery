//
//  ModelsAndProtocols.swift
//  Obvious-Project
//
//  Created by Babul Raj on 02/03/23.
//

import Foundation

struct ImageModel {
    var title:String
    var url: String
    var hdURL:String?
    var explanation:String
}

protocol GalleryInteractorProtocol {
    func getImages() async throws -> [ImageModel] 
}
