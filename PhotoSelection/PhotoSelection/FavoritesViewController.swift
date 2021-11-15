//
//  FavoritesViewController.swift
//  PhotoSelection
//
//  Created by ippmacmini04 on 11/15/21.
//

import UIKit


class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    let updatedPoints = Notification.Name(rawValue: "updatePoints")
    private var photos: [PhotoData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotosTableViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let navigationController = navigationController else { return }
        navigationController.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        if let decodedData = UserDefaults.standard.object(forKey: "ListOfFavoritePhotos") as? Data {
            if let data = try? JSONDecoder().decode([FailableDecodable<PhotoData>].self, from: decodedData).compactMap({ $0.base }) {
                self.photos = data as [PhotoData]
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell") as! PhotosTableViewCell
        cell.isFromFavoritesPhoto = true
        cell.photo = photos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }

}
