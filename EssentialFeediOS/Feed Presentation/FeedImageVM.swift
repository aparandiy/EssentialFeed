//
//  FeedImageVM.swift
//  EssentialFeediOS
//
//  Created by Andrij Parandij on 24.01.2024.
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
