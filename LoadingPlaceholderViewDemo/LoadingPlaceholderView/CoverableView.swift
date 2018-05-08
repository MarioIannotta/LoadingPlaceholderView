//
//  CoverableView.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 28/04/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

@objc protocol CoverableView {
    
    var coverablePath: UIBezierPath { get }
    
}

extension CoverableView {
    
    func makeCoverablePath(superview: UIView? = nil) -> UIBezierPath? {
        guard
            let view = self as? UIView,
            let superview = superview ?? view.superview
            else { return nil }
        view.layoutIfNeeded()
        let offsetPoint = view.convert(view.bounds, to: superview).origin
        let relativePath = coverablePath
        relativePath.translate(to: offsetPoint)
        return relativePath
    }
    
    func addCoverablePath(to totalCoverablePath: UIBezierPath, superview: UIView? = nil) {
        guard let coverablePath = makeCoverablePath(superview: superview) else { return }
        totalCoverablePath.append(coverablePath)
    }
    
}
