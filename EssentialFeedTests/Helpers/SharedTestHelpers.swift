//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Andrij Parandij on 05.01.2024.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
