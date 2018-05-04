//
//  UIView+.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 04/05/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

extension UIView {
    
    func coverableSubviews() -> [CoverableView] {
        var foundedViews = [CoverableView]()
        subviews.forEach { view in
            if let coverableView = view as? CoverableView & UIView, coverableView.isCoverable {
                foundedViews.append(coverableView)
            } else {
                foundedViews += view.coverableSubviews()
            }
        }
        return foundedViews
    }
    
}
