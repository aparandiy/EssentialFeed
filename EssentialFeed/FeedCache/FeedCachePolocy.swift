//
//  FeedCachePolocy.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 05.01.2024.
//

import Foundation

final class FeedCachePolocy {
    
    private init() {}//privat init prevents developer to create a new instanceof singletone
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        return date < maxCacheAge
    }
}

