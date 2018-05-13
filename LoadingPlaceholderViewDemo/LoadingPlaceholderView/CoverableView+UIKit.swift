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
    }
    
    /**
     If `true` this view will be covered by a `LoadingPlaceholderView`
     when `cover(_:, animated:)` is called.
     
     The default value is `true` if the object has width and height greather than 10.
     */
    open var isCoverable: Bool {
        get {
            let settedValue = objc_getAssociatedObject(self, &AssociatedObjectKey.isCoverable) as? Bool
            return settedValue ?? (bounds.width > 10 && bounds.height > 10)
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectKey.isCoverable,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var defaultCoverablePath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: layer.cornerRadius)
    }
    
}

extension UIImageView: CoverableView {
    
    var coverablePath: UIBezierPath {
        return defaultCoverablePath
    }

}

extension UIButton: CoverableView {
    
    var coverablePath: UIBezierPath {
        return defaultCoverablePath
    }
    
}

extension UILabel: CoverableView {
    
    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }
    
    var coverablePath: UIBezierPath {
        return .multiLinePath(numberOfLines: numberOfVisibleLines, bounds: bounds)
    }
    
}


extension UITextView: CoverableView {
    
    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }
    
    var coverablePath: UIBezierPath {
        return .multiLinePath(numberOfLines: numberOfVisibleLines, bounds: bounds)
    }
    
}

extension UISegmentedControl: CoverableView {
    
    var coverablePath: UIBezierPath {
        return defaultCoverablePath
    }
    
}

extension UITableViewCell: CoverableView {
    
    var coverablePath: UIBezierPath {
        return coverableSubviews()
            .reduce(UIBezierPath(), { totalBezierPath, coverableView in
                coverableView.addCoverablePath(to: totalBezierPath, superview: self)
                return totalBezierPath
            })
    }
    
}

extension UITableView: CoverableView {
    
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
    
    var coverablePath: UIBezierPath {
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

extension Array where Element: CoverableView {
    
    var coverablePath: UIBezierPath {
        return reduce(UIBezierPath(), { totalPath, cell in
            guard
                let cellPath = cell.makeCoverablePath()
                else { return totalPath }
            totalPath.append(cellPath)
            return totalPath
        })
    }
    
}

extension UICollectionView: CoverableView {
    
    var coverablePath: UIBezierPath {
        return visibleCells.coverablePath
    }
}

extension UICollectionViewCell: CoverableView {
    
    var coverablePath: UIBezierPath {
        return coverableSubviews()
            .reduce(UIBezierPath(), { totalBezierPath, coverableView in
                coverableView.addCoverablePath(to: totalBezierPath, superview: self)
                return totalBezierPath
            })
    }
    
}
