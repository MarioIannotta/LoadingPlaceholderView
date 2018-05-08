//
//  TableViewExampleViewController.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 04/05/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

class TableViewExampleViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.coverableCellsIdentifiers = cellsIdentifiers
        }
    }
    
    private var numberOfSections = 0
    private var numberOfRows = 0
    private var loadingPlaceholderView = LoadingPlaceholderView()
    
    private var cellsIdentifiers = [
        "AvatarAndLabelCell",
        "TextViewAndSegmentControllCell",
        "TextViewAndSegmentControllCell",
        "AvatarAndLabelCell",
        "AvatarAndLabelCell",
        "TextViewAndSegmentControllCell",
        "TextViewAndSegmentControllCell"
    ]

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
        self.numberOfSections = 2
        self.numberOfRows = cellsIdentifiers.count
        self.tableView.reloadData()
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

extension TableViewExampleViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = cellsIdentifiers[indexPath.row]
        return tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    }
    
}

class AvatarAndLabelCell: UITableViewCell {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var simpleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2
    }
    
}

class TextViewAndSegmentControllCell: UITableViewCell {
    
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
}
