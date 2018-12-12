//
//  CustomSplitViewController.swift
//  Yatodoa
//
//  Created by Alex Dobrynin on 11.12.18.
//  Copyright © 2018 Alexander Dobrynin. All rights reserved.
//

import UIKit

class CustomSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .allVisible
        delegate = self
    }

}

extension CustomSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
