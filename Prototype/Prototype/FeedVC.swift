//
//  FeedVC.swift
//  Prototype
//
//  Created by Andrij Parandij on 18.01.2024.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

final class FeedVC: UITableViewController {
    
    private let feed = FeedImageViewModel.prototypeFeed

    //MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath) as! FeedImageCell
        let model = feed[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}

extension FeedImageCell {
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil

        descriptionLabel.text = model.description
        descriptionLabel.isHidden = model.description == nil
        
        fadeIn(UIImage(named: model.imageName))
    }
}
