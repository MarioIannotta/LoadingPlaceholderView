//
//  CollectionViewExampleViewController.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 10/05/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit
import LoadingPlaceholderView

class CollectionViewExampleViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var numberOfSections = 2
    private var numberOfRows = 20
    private var loadingPlaceholderView = LoadingPlaceholderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingPlaceholderView()
        performFakeNetworkRequest()
    }
    
    private func performFakeNetworkRequest() {
        // simulate network request
        loadingPlaceholderView.cover(view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.finishFakeRequest()
        }
    }
    
    private func finishFakeRequest() {
        self.loadingPlaceholderView.uncover()
    }
    
    private func setupLoadingPlaceholderView() {
        loadingPlaceholderView.gradientColor = .white
        loadingPlaceholderView.backgroundColor = .white
    }
    
    @IBAction private func showLoaderButtonTapped() {
        performFakeNetworkRequest()
    }
    
    @IBAction private func hideLoaderButtonTapped() {
        finishFakeRequest()
    }
    
}

extension CollectionViewExampleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

class UserCell: UICollectionViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width/2
    }
    
}
