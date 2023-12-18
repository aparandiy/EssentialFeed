//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Andrij Parandij on 18.12.2023.
//

import Foundation
public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}
public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
