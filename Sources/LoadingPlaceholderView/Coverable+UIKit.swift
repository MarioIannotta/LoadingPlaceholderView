//
//  Coverable+UIKit.swift
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
     
     The default value is `true` if the object has width and height greather than 5.
     */
    @IBInspectable
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
    
    /**
     The path that will be used to mask the content and add the gradient.
     If this value is provided `Coverable.defaultCoverablePath` is ignored.
    */
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
        return bounds.width > 5 && bounds.height > 5
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
extension UITextField: Coverable { }

extension UILabel: Coverable {
    
    private struct AssociatedObjectKey {
        static var linesSpacing = "linesSpacing"
    }
    
    /**
     The spacing between the lines.
     The default value is 3.
     */
    @IBInspectable
    open var linesSpacing: CGFloat {
        get {
            let settedValue = objc_getAssociatedObject(self, &AssociatedObjectKey.linesSpacing) as? CGFloat
            return settedValue ?? 3
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectKey.linesSpacing,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }

    public var defaultCoverablePath: UIBezierPath? {
        return .multiLinePath(numberOfLines: numberOfVisibleLines,
                              spacing: linesSpacing,
                              bounds: bounds)
    }

}

extension UITextView: Coverable {
    
    private struct AssociatedObjectKey {
        static var linesSpacing = "linesSpacing"
    }
    
    /**
     The spacing between the lines.
     The default value is 3.
     */
    @IBInspectable
    open var linesSpacing: CGFloat {
        get {
            let settedValue = objc_getAssociatedObject(self, &AssociatedObjectKey.linesSpacing) as? CGFloat
            return settedValue ?? 3
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedObjectKey.linesSpacing,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    private var numberOfVisibleLines: Int {
        guard let font = self.font else { return 1 }
        return max(1, Int(bounds.height/font.lineHeight))
    }

    public var defaultCoverablePath: UIBezierPath? {
        return .multiLinePath(numberOfLines: numberOfVisibleLines,
                              spacing: linesSpacing,
                              bounds: bounds)
    }

}

extension UISwitch: Coverable {
    
    public var defaultCoverablePath: UIBezierPath? {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: bounds.height/2)
    }
    
}

extension UISegmentedControl: Coverable {
    
    public var defaultCoverablePath: UIBezierPath? {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: 4)
    }
    
}

extension UIStepper: Coverable {
    
    public var defaultCoverablePath: UIBezierPath? {
        return UIBezierPath(roundedRect: bounds,
                            cornerRadius: 4)
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
    
    public var defaultCoverablePath: UIBezierPath? {
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
    
    public var defaultCoverablePath: UIBezierPath? {
        return subviewsCoverablePath
    }
    
}

extension UICollectionView: Coverable {
    
    public var defaultCoverablePath: UIBezierPath? {
        let coverablePath = visibleCells.coverablePath
        coverablePath.translate(to: contentOffset.applying(CGAffineTransform(scaleX: 0, y: -1)))
        return coverablePath
    }
    
}

extension UICollectionViewCell: Coverable {
    
    public var defaultCoverablePath: UIBezierPath? {
        return subviewsCoverablePath
    }
    
}
