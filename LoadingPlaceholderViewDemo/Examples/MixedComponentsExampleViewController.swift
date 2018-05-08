//
//  MixedComponentsExampleViewController.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 28/04/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

class MixedComponentsExampleViewController: UIViewController {
    
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
        }
    }
    
    private var loadingPlaceholderView = LoadingPlaceholderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingPlaceholderView()
        loadingPlaceholderView.cover(view, animated: false)
    }
    
    private func setupLoadingPlaceholderView() {
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
    }
    
    @IBAction private func showLoaderButtonTapped() {
        loadingPlaceholderView.cover(view)
    }
    
    @IBAction private func hideLoaderButtonTapped() {
        loadingPlaceholderView.uncover()
    }
    
    @IBAction private func aButtonTapped() {
        print("a button has been tapped")
    }
    
}

