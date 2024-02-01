//
//  FeedImageVM.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 01.02.2024.
//

struct FeedImageVM<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        return location != nil
    }
}
