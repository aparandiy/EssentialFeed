//
//  FeedImageVM.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 13.02.2024.
//

public struct FeedImageVM<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool

    public var hasLocation: Bool {
        return location != nil
    }
}
