//
//  GalleryInteractor.swift
//  Obvious-Project
//
//  Created by Babul Raj on 02/03/23.
//

import Foundation

struct ImgageListNetworkmodel: Codable {
    let copyright, date, explanation: String?
    let hdurl: String?
    let mediaType, serviceVersion, title: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

struct GalleryImagelistRequest:Request, RawRepresentable {
    var rawValue: String
    
    typealias RawValue = String

    init?(rawValue:String) {
        guard let  url = URL(string: rawValue) else  {
            return nil
        }
        
        self.rawValue = rawValue
        self.url = url
    }
    
    var url: URL
    
    var httpmethod: HTTPMethod {
        .get
    }
}

final class GalleryInteractor: GalleryInteractorProtocol {
    let networker:NetworkerProtocol
   
    init(networker: NetworkerProtocol) {
        self.networker = networker
    }
   
    func getImages() async throws -> [ImageModel] {
        guard Reachability.isConnectedToNetwork() else {throw ApiError.noInternet}
        if let request = GalleryImagelistRequest(rawValue: "https://raw.githubusercontent.com/obvious/take-home-exercise-data/trunk/nasa-pictures.json") {
            do {
                let data = try await networker.fetch(request: request)
                do {
                    let networkModel = try JSONDecoder().decode([ImgageListNetworkmodel].self, from: data)
                    return transform(networkModel)
                } catch {
                    throw ApiError.parsing
                }

            } catch {
                throw error
            }
        } else {
            throw ApiError.badURL
        }
    }
    
    private func transform(_ networkmodel:[ImgageListNetworkmodel]) -> [ImageModel] {
        var imageArray:[ImageModel] = []
        
        for item in networkmodel {
            let imageModel = ImageModel(title: item.title ?? "", url: item.url ?? "", hdURL: item.hdurl, explanation: item.explanation ?? "")
            imageArray.append(imageModel)
        }
        
        return imageArray
    }
}
