//
//  UINavigationController+SwipeBack.swift
//  resetmusic-ios-local
//
//  Created by Naushad Ali Khan on 20/03/26.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
