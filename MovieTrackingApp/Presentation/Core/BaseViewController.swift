//
//  BaseViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 19.12.24.
//

import UIKit

open class BaseViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureView()
        configureConstraint()
        configureTargets()
    }
    
    open func configureView() {}
    open func configureConstraint() {}
    open func configureTargets() {}
}
