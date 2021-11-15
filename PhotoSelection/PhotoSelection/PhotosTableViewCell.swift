//
//  PhotosTableViewCell.swift
//  PhotoSelection
//
//  Created by ippmacmini04 on 11/15/21.
//

import UIKit
import CoreData

class PhotosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPhotos: UIImageView!
    @IBOutlet weak var imgFavorite: UIImageView! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            imgFavorite.isUserInteractionEnabled = true
            imgFavorite.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    var isFavoritePhoto: Bool = false
    
    var isFromFavoritesPhoto: Bool = false {
        didSet {
            imgFavorite.isHidden = isFromFavoritesPhoto ? true : false
        }
    }
    
    var delegate: SelectedFavPhoto?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoritePhotos")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var photo : PhotoData? {
        didSet {
            lblTitle.text = photo?.title
            lblName.text = photo?.ownername
            if let image = URL(string: photo?.url_m ?? "") {
                imgPhotos.loadImageWithUrl(image)
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if isFavoritePhoto {
            isFavoritePhoto = false
            imgFavorite.image = UIImage(systemName: "star.circle")
            if let decodedData = UserDefaults.standard.object(forKey: "ListOfFavoritePhotos") as? Data {
                if let data = try? JSONDecoder().decode([FailableDecodable<PhotoData>].self, from: decodedData).compactMap({ $0.base }) {
                    let list = data.filter {
                        $0.title != photo?.title
                    }
                    if let encodedUserDetails = try? JSONEncoder().encode(list) {
                        UserDefaults.standard.set(encodedUserDetails, forKey: "ListOfFavoritePhotos")
                    }
                }
            }
        } else {
            imgFavorite.image = UIImage(systemName: "star.circle.fill")
            isFavoritePhoto = true
            if let decodedData = UserDefaults.standard.object(forKey: "ListOfFavoritePhotos") as? Data {
                if let data = try? JSONDecoder().decode([FailableDecodable<PhotoData>].self, from: decodedData).compactMap({ $0.base }) {
                    var favPhotoList = data as [PhotoData]
                    favPhotoList.append(self.photo!)
                    if let encodedUserDetails = try? JSONEncoder().encode(favPhotoList) {
                        UserDefaults.standard.set(encodedUserDetails, forKey: "ListOfFavoritePhotos")
                    }
                }
            } else {
                var favPhotoList: [PhotoData] = []
                favPhotoList.append(self.photo!)
                if let encodedUserDetails = try? JSONEncoder().encode(favPhotoList) {
                    UserDefaults.standard.set(encodedUserDetails, forKey: "ListOfFavoritePhotos")
                }
            }
        }
        
        
    }
    
}

protocol SelectedFavPhoto {
    func allPhotos()
}
