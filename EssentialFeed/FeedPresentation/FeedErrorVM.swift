//
//  FeedErrorVM.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 12.02.2024.
//

public struct FeedErrorVM {
    public let message: String?
    
    static var noError: FeedErrorVM {
        return FeedErrorVM(message: nil)
    }
    
    static func error(message: String) -> FeedErrorVM {
        return FeedErrorVM(message: message)
    }
}
