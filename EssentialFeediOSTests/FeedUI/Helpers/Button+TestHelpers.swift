//
//  Button+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Andrij Parandij on 22.01.2024.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
