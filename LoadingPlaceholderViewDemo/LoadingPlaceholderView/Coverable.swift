//
//  Coverable.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 28/04/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

public protocol Coverable {
    
    /**
     The path that will be used to mask the content and add the gradient.
     The default value for all the `UIViews` is a rounded rect of the size of the view's bounds.
     
     It's possible to customize the default path by explicitly set `UIView.coverablePath`
     */
    var defaultCoverablePath: UIBezierPath? { get }
    
}

typealias CoverableView = UIView & Coverable

extension Coverable where Self: UIView {
    
    func makeCoverablePath(superview: UIView? = nil) -> UIBezierPath? {
        guard
            let superview = superview ?? self.superview
            else { return nil }
        layoutIfNeeded()
        let offsetPoint = convert(bounds, to: superview).origin
        let relativePath = coverablePath ?? UIBezierPath()
        relativePath.translate(to: offsetPoint)
        return relativePath
    }
    
    func addCoverablePath(to totalCoverablePath: UIBezierPath, superview: UIView? = nil) {
        guard
            let coverablePath = makeCoverablePath(superview: superview)
            else { return }
        totalCoverablePath.append(coverablePath)
    }
    
    public var defaultCoverablePath: UIBezierPath? {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: layer.cornerRadius)
    }
    
}

extension Array where Element: CoverableView {
    
    var coverablePath: UIBezierPath {
        return reduce(UIBezierPath(), { totalPath, cell in
            cell.addCoverablePath(to: totalPath)
            return totalPath
        })
    }
    
}


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
