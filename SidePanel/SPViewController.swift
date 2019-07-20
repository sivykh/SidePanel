//
//  SPViewController.swift
//  Demo
//
//  Created by Mikhail Sivykh on 20/07/2019.
//  Copyright © 2019 Mikhail Sivykh. All rights reserved.
//

import UIKit

public final class SPViewController: UIViewController {
    
    // MARK: - Children controllers
    public var leftViewController: UIViewController? { didSet {
        change(old: oldValue, by: leftViewController, in: leftView,
               with: presentedContent == .left, relatedGesture: leftEdgeGesture)
    }}

    public var centerViewController: UIViewController? { didSet {
        updateCentralUserInteractionEnabled(for: centerViewController)
        change(old: oldValue, by: centerViewController, in: centerView,
               with: true /* always visible */, relatedGesture: nil)
        updateCentralUserInteractionEnabled(for: oldValue, forced: true)
        setNeedsStatusBarAppearanceUpdate()
    }}

    public var rightViewController: UIViewController? { didSet {
        change(old: oldValue, by: rightViewController, in: rightView,
               with: presentedContent == .right, relatedGesture: rightEdgeGesture)
    }}
    
    // MARK: - Subviews, internal properties
    internal lazy var leftView = UIView()
    internal lazy var centerView = UIView()
    internal lazy var rightView = UIView()
    internal lazy var overlayButton = self.instanciateOverlayButton()
    
    // MARK: - Gestures
    public internal(set) var leftEdgeGesture: UIScreenEdgePanGestureRecognizer!
    public internal(set) var rightEdgeGesture: UIScreenEdgePanGestureRecognizer!
    public internal(set) var panGesture: UIPanGestureRecognizer!
    internal var originalX: CGFloat = 0
    
    // MARK: - Layout states
    public internal(set) var presentedContent = SPPresentedController.center { didSet {
        updateCentralUserInteractionEnabled(for: centerViewController)
        setNeedsStatusBarAppearanceUpdate()
    }}

    public var sidePanelWidth: CGFloat = 250 { didSet {
        if isViewLoaded { view.setNeedsLayout() }
    }}

    public var leftAppearanceRule = SPControllerAppearance.above { didSet {
        panGesture?.isEnabled = leftAppearanceRule == .under || rightAppearanceRule == .under
        if isViewLoaded { view.setNeedsLayout() }
    }}

    public var rightAppearanceRule = SPControllerAppearance.above { didSet {
        panGesture?.isEnabled = leftAppearanceRule == .under || rightAppearanceRule == .under
        if isViewLoaded { view.setNeedsLayout() }
    }}
    
    public var sideOverlayViewColor = UIColor(white: 0, alpha: 0.7) { didSet {
        overlayButton.backgroundColor = sideOverlayViewColor
    }}
}

// MARK: - Private functions

private extension SPViewController {
    func change(old: UIViewController?, by new: UIViewController?, in view: UIView,
                with appearance: Bool, relatedGesture: UIGestureRecognizer?) {
        remove(viewController: old, withAppearance: appearance)
        add(viewController: new, to: view, withAppearance: appearance)
        relatedGesture?.isEnabled = new != nil
    }
    
    func updateCentralUserInteractionEnabled(for centerViewController: UIViewController?, forced: Bool? = nil) {
        if let vc = (centerViewController as? UINavigationController)?.viewControllers.last {
            vc.view.isUserInteractionEnabled = forced ?? (presentedContent == .center)
        } else if let vc = centerViewController {
            vc.view.isUserInteractionEnabled = forced ?? (presentedContent == .center)
        }
    }
}
