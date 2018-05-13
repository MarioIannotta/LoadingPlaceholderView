//
//  CoverableView+UIKit.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 04/05/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

extension UIView {
    
    private struct AssociatedObjectKey {
        static var isCoverable = "isCoverable"
        static var coverablePath = "coverablePath"
    }
    
    /**
     If `true` this view will be covered by a `LoadingPlaceholderView`
     when `cover(_:, animated:)` is called.
     
     The default value is `true` if the object has width and height greather than 10.
     */
    open var isCoverable: Bool {
        get {
            let settedValue = objc_getAssociatedObject(self, &AssociatedObjectKey.isCoverable) as? Bool
            return settedValue ?? isBigEnough
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectKey.isCoverable,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open var coverablePath: UIBezierPath? {
        get {
            let settedCoverablePath = objc_getAssociatedObject(self,
                                                               &AssociatedObjectKey.coverablePath) as? UIBezierPath
            return settedCoverablePath ?? (self as? Coverable)?.defaultCoverablePath
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectKey.coverablePath,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var isBigEnough: Bool {
        return bounds.width > 10 && bounds.height > 10
    }
    
    fileprivate var subviewsCoverablePath: UIBezierPath {
        return coverableSubviews()
            .reduce(UIBezierPath(), { totalBezierPath, coverableView in
                coverableView.addCoverablePath(to: totalBezierPath, superview: self)
                return totalBezierPath
            })
    }
    
}

extension UIImageView: Coverable { }
extension UIButton: Coverable { }
extension UISegmentedControl: Coverable { }

extension UILabel: Coverable {

    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }

    var defaultCoverablePath: UIBezierPath? {
        return .multiLinePath(numberOfLines: numberOfVisibleLines,
                              bounds: bounds)
    }

}

extension UITextView: Coverable {

    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }

    var defaultCoverablePath: UIBezierPath? {
        return .multiLinePath(numberOfLines: numberOfVisibleLines,
                              bounds: bounds)
    }

}

extension UITableView: Coverable {
    
    private struct AssociatedObjectKey {
        static var coverableCellsIdentifiers = "coverableCellsIdentifiers"
    }
    
    open var coverableCellsIdentifiers: [String]? {
        get {
            return objc_getAssociatedObject(self,
                                            &AssociatedObjectKey.coverableCellsIdentifiers) as? [String]
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectKey.coverableCellsIdentifiers,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var defaultCoverablePath: UIBezierPath? {
        guard
            let coverableCellsIdentifiers = coverableCellsIdentifiers
            else { return makeCoverablePathFromVisibleCells() }
        return makeCoverablePath(from: coverableCellsIdentifiers)
    }
    
    private func makeCoverablePath(from coverableCellsIdentifiers: [String]) -> UIBezierPath {
        var height: CGFloat = 0
        return coverableCellsIdentifiers.reduce(UIBezierPath(), { totalPath, identifier in
            guard
                let cell = dequeueReusableCell(withIdentifier: identifier)
                else { return totalPath }
            cell.frame = CGRect(x: 0, y: height, width: frame.width, height: cell.frame.height)
            if let cellCoverablePath = cell.makeCoverablePath(superview: cell) {
                cellCoverablePath.translate(to: CGPoint(x: 0, y: cell.frame.origin.y))
                totalPath.append(cellCoverablePath)
            }
            height += cell.frame.height
            return totalPath
        })
    }
    
    private func makeCoverablePathFromVisibleCells() -> UIBezierPath {
        return visibleCells.coverablePath
    }
    
}

extension UITableViewCell: Coverable {
    
    var defaultCoverablePath: UIBezierPath? {
        return subviewsCoverablePath
    }
    
}

extension UICollectionView: Coverable {
    
    var defaultCoverablePath: UIBezierPath? {
        return visibleCells.coverablePath
    }
    
}

extension UICollectionViewCell: Coverable {
    
    var defaultCoverablePath: UIBezierPath? {
        return subviewsCoverablePath
    }
    
}
