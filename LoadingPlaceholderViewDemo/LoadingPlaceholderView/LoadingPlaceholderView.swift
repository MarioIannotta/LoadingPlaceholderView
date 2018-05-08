//
//  LoadingPlaceholderView.swift
//  LoadingPlaceholderViewDemo
//
//  Created by Mario on 28/04/2018.
//  Copyright © 2018 Mario. All rights reserved.
//

import UIKit

open class LoadingPlaceholderView: UIView {
    
    // MARK: - Public properties
    
    public struct GradientConfiguration {
        
        public var width: Double
        public var backgroundColor: UIColor
        public var primaryColor: UIColor
        public var secondaryColor: UIColor
        
        init() {
            self.init(color: .white)
        }
        
        public init(color: UIColor, width: Double = 0.2) {
            backgroundColor = color.withBrightness(brightness: 0.98)
            primaryColor = color.withBrightness(brightness: 0.95)
            secondaryColor = color.withBrightness(brightness: 0.88)
            self.width = width
        }
        
    }
    
    open var fadeAnimationDuration: TimeInterval = 0.15
    open var loadingAnimationDuration: TimeInterval = 1
    open var defaultBorderRadius: CGFloat = 8
    open var gradientConfiguration = GradientConfiguration()
    open var gradientColor: UIColor = .clear {
        didSet {
            gradientConfiguration = GradientConfiguration(color: gradientColor)
        }
    }
    
    // MARK: - Private properties
    
    private var viewToCover: UIView?
    private var maskLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    private var viewToConverObservation: NSKeyValueObservation?
    private var isCovering: Bool { return superview != nil }
    
    public func cover(_ viewToCover: UIView, animated: Bool = true) {
        viewToCover.layoutIfNeeded()
        setupView(viewToCover: viewToCover)
         // make sure the view has a valid layout
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            self?.startLoading(animated: animated)
        }
    }
    
    public func uncover(animated: Bool = true) {
        guard isCovering else { return }
        fadeOut(animated: animated)
        let dispatchTime: DispatchTime = .now() + fadeAnimationDuration
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) { [weak self] in
            self?.removeGradientAndMask()
            self?.removeFromSuperview()
        }
    }
    
    deinit {
        viewToConverObservation = nil
    }
    
    private func setupView(viewToCover: UIView) {
        self.viewToCover = viewToCover
        self.frame = viewToCover.bounds
        viewToConverObservation = observe(\.bounds) { [weak self] _, _ in
            if self?.isCovering == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.setupMaskLayerIfNeeded()
                    self?.setupGradientLayerIfNeeded()
                }
            }
        }
    }
    
    private func startLoading(animated: Bool) {
        guard !isCovering, let viewToCover = viewToCover else { return }
        viewToCover.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        frame = viewToCover.bounds
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: viewToCover.topAnchor),
            bottomAnchor.constraint(equalTo: viewToCover.bottomAnchor),
            leftAnchor.constraint(equalTo: viewToCover.leftAnchor),
            rightAnchor.constraint(equalTo: viewToCover.rightAnchor)
            ])
        setupMaskLayerIfNeeded()
        setupGradientLayerIfNeeded()
        setupGradientLayerAnimation()
        fadeIn(animated: animated)
    }
    
    private func setupMaskLayerIfNeeded() {
        guard let superview = superview else { return }
        maskLayer.frame = superview.bounds
        let toalBezierPath = superview
            .coverableSubviews()
            .reduce(UIBezierPath(), { totalBezierPath, coverableView in
                coverableView.addCoverablePath(to: totalBezierPath, superview: superview)
                return totalBezierPath
            })
        maskLayer.path = toalBezierPath.cgPath
        maskLayer.fillColor = UIColor.red.cgColor
        layer.addSublayer(maskLayer)
    }
    
    private func setupGradientLayerIfNeeded() {
        guard let superview = superview else { return }
        
        gradientLayer.frame = CGRect(x: 0,
                                     y: 0,
                                     width: superview.bounds.size.width,
                                     height: superview.bounds.size.height)
        superview.layer.addSublayer(gradientLayer)
        gradientLayer.startPoint = CGPoint(x: -1 - gradientConfiguration.width*2, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1 + gradientConfiguration.width*2, y: 0)
        
        gradientLayer.colors = [
            gradientConfiguration.backgroundColor.cgColor,
            gradientConfiguration.primaryColor.cgColor,
            gradientConfiguration.secondaryColor.cgColor,
            gradientConfiguration.primaryColor.cgColor,
            gradientConfiguration.backgroundColor.cgColor
        ]

        let startLocations = [NSNumber(value: Double(gradientLayer.startPoint.x)),
                              NSNumber(value: Double(gradientLayer.startPoint.x)),
                              NSNumber(value: 0),
                              NSNumber(value: gradientConfiguration.width),
                              NSNumber(value: 1 + gradientConfiguration.width)]
        
        gradientLayer.locations = startLocations
        gradientLayer.cornerRadius = superview.layer.cornerRadius
        layer.addSublayer(gradientLayer)
        gradientLayer.mask = maskLayer
    }
    
    private func setupGradientLayerAnimation() {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = gradientLayer.locations
        gradientAnimation.toValue = [NSNumber(value: 0),
                                     NSNumber(value: 1),
                                     NSNumber(value: 1),
                                     NSNumber(value: 1 + gradientConfiguration.width),
                                     NSNumber(value: 1 + gradientConfiguration.width)]
        
        gradientAnimation.repeatCount = .infinity
        gradientAnimation.isRemovedOnCompletion = false
        gradientAnimation.duration = loadingAnimationDuration
        gradientLayer.add(gradientAnimation, forKey: "locations")
    }
    
    private func fadeIn(animated: Bool) {
        guard
            animated
            else {
                self.alpha = 1
                return
            }
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = alpha
        opacityAnimation.toValue = 1
        opacityAnimation.duration = fadeAnimationDuration
        gradientLayer.add(opacityAnimation, forKey: "opacityAnimationIn")
        
        UIView.animate(withDuration: fadeAnimationDuration) {
            self.alpha = 1
        }
    }
    
    private func fadeOut(animated: Bool) {
        guard
            animated
            else {
                self.alpha = 0
                return
            }
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = alpha
        opacityAnimation.toValue = 0
        opacityAnimation.duration = fadeAnimationDuration
        gradientLayer.add(opacityAnimation, forKey: "opacityAnimationOut")
        
        UIView.animate(withDuration: fadeAnimationDuration) {
            self.alpha = 0
        }
    }
    
    private func removeGradientAndMask() {
        gradientLayer.removeAllAnimations()
        gradientLayer.removeFromSuperlayer()
        maskLayer.removeFromSuperlayer()
    }
    
}

extension UIColor {
    
    fileprivate func withBrightness(brightness: CGFloat) -> UIColor {
        var H: CGFloat = 0, S: CGFloat = 0, B: CGFloat = 0, A: CGFloat = 0
        if getHue(&H, saturation: &S, brightness: &B, alpha: &A) {
            B += (brightness - 1.0)
            B = max(min(B, 1.0), 0.0)
            return UIColor(hue: H, saturation: S, brightness: B, alpha: A)
        }
        return self
    }
    
}
