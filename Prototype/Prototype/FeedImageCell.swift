//
//  FeedImageCell.swift
//  Prototype
//
//  Created by Andrij Parandij on 18.01.2024.
//

import UIKit

class FeedImageCell: UITableViewCell {
    
    //MARK: - Properties
    @IBOutlet private(set) var locationContainer: UIView!
    @IBOutlet private(set) var locationLabel: UILabel!
    @IBOutlet private(set) var feedImageView: UIImageView!
    @IBOutlet private(set) var descriptionLabel: UILabel!

    //MARK: - default methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
