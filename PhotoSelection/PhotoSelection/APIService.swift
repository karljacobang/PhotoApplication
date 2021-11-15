//
//  APIService.swift
//  PhotoSelection
//
//  Created by ippmacmini04 on 11/15/21.
//

import Foundation

class APIService :  NSObject {
    
    private let sourcesURL = URL(string: "https://www.flickr.com/services/rest/?method=flickr.people.getPublicPhotos&api_key=dcaed924bb6a7b46f7508c7b293a4398&user_id=194370359@N05&extras=url_m%2Cowner_name&format=json&nojsoncallback=1")!
    
    func apiToGetEmployeeData(completion : @escaping (Photos) -> ()){
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let dataType = data {
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(Photos.self, from: dataType)
                completion(empData)
            }
        }.resume()
    }
}
