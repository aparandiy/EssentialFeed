//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 14.12.2023.
//

import Foundation
///Simple feed model
struct FeedItem {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
