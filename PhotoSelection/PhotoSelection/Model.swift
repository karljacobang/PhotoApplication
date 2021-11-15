//
//  Model.swift
//  PhotoSelection
//
//  Created by ippmacmini04 on 11/15/21.
//

import Foundation

struct Photos: Codable {
    let photos: PhotosData
}

struct PhotosData: Codable {
    let photo: [PhotoData]
}

struct PhotoData: Codable {
    let title, ownername, url_m : String

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case ownername = "ownername"
        case url_m = "url_m"
    }
}

struct FailableDecodable<Base : Decodable> : Decodable {
    var base: Base?
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
