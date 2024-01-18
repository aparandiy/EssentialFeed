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
    
    //MARK: - Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell", for: indexPath)

        return cell
    }

}
