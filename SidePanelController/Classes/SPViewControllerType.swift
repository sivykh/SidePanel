//
//  SPViewControllerType.swift
//  Demo
//
//  Created by Mikhail Sivykh on 20/07/2019.
//  Copyright © 2019 Mikhail Sivykh. All rights reserved.
//

import UIKit

// MARK: - SPViewControllerType declaration

public protocol SPViewControllerType: AnyObject {
    var leftViewController: UIViewController? { get set }
    var centerViewController: UIViewController? { get set }
    var rightViewController: UIViewController? { get set }
    
    var leftEdgeGesture: UIScreenEdgePanGestureRecognizer! { get }
    var rightEdgeGesture: UIScreenEdgePanGestureRecognizer! { get }
    var panGesture: UIPanGestureRecognizer! { get }
    
    var presentedContent: SidePanelController.SPPresentedController { get }
    var sidePanelWidth: CGFloat { get set }
    var leftAppearanceRule: SidePanelController.SPControllerAppearance { get set }
    var rightAppearanceRule: SidePanelController.SPControllerAppearance { get set }
    var sideOverlayViewColor: UIColor { get set }
    
    var shouldDisableShiftedCentralControllerInteractions: Bool { get set }

    func present(content: SPPresentedController, animated: Bool)
    func setAppearance(_ appearance: SPControllerAppearance)
    func setOverlayButton(enabled: Bool)
    func toggleRight(animated: Bool)
    func toggleLeft(animated: Bool)
}

// MARK: - Perform animation by default

public extension SPViewControllerType {
    func present(content: SPPresentedController) { present(content: content, animated: true) }
    
    func toggleRight() { toggleRight(animated: true) }
    
    func toggleLeft() { toggleLeft(animated: true) }
}

// MARK: - SPViewControllerType implementation

extension SPViewController: SPViewControllerType {
    typealias SPPresentationAction =
        (SPControllerAppearance, UIViewController?, UIViewController?, SPPresentedController)

    public func setAppearance(_ appearance: SPControllerAppearance) {
        leftAppearanceRule = appearance
        rightAppearanceRule = appearance
    }
    
    public func setOverlayButton(enabled: Bool) {
        overlayButton.isEnabled = enabled
    }
    
    public func toggleRight(animated: Bool) {
        guard self.rightViewController != nil else {
            return
        }
        let toggle = {
            let hide = self.presentedContent == .right
            self.rightViewController?.beginAppearanceTransition(!hide, animated: animated)
            self.presentedContent = hide ? .center : .right
            self.updateFrames()
            self.makeOverlayButton(hidden: hide || self.rightAppearanceRule == .under)
            self.rightViewController?.endAppearanceTransition()
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: toggle)
        } else {
            toggle()
        }
    }
    
    public func toggleLeft(animated: Bool) {
        guard self.leftViewController != nil else {
            return
        }
        let toggle = {
            let hide = self.presentedContent == .left
            self.leftViewController?.beginAppearanceTransition(!hide, animated: animated)
            self.presentedContent = hide ? .center : .left
            self.updateFrames()
            self.makeOverlayButton(hidden: hide || self.leftAppearanceRule == .under)
            self.leftViewController?.endAppearanceTransition()
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: toggle)
        } else {
            toggle()
        }
    }
    
    public func present(content: SPPresentedController, animated: Bool) {
        guard presentedContent != content else {
            updateFrames()
            return // nothing to do
        }
        let shouldCallDisappear = presentedContent != .center
        let action: (SPPresentationAction) -> Void = { args in
            let (rule, appearingController, disappearingController, content) = args
            appearingController?.beginAppearanceTransition(true, animated: animated)
            if shouldCallDisappear {
                disappearingController?.beginAppearanceTransition(false, animated: animated)
            }
            self.presentedContent = content
            self.updateFrames()
            self.makeOverlayButton(hidden: rule == .under)
            appearingController?.endAppearanceTransition()
            if shouldCallDisappear {
                disappearingController?.endAppearanceTransition()
            }
        }
        let block = {
            switch content {
            case .left:
                action(
                    (self.leftAppearanceRule, self.leftViewController, self.rightViewController, content)
                )
            case .right:
                action(
                    (self.rightAppearanceRule, self.rightViewController, self.leftViewController, content)
                )
            case .center:
                let disappearingController =
                    self.presentedContent == .left ? self.leftViewController : self.rightViewController
                disappearingController?.beginAppearanceTransition(false, animated: animated)
                self.presentedContent = content
                self.updateFrames()
                self.makeOverlayButton(hidden: true)
                disappearingController?.endAppearanceTransition()
            }
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: block)
        } else {
            block()
        }
    }
}

private extension SPViewController {
    func makeOverlayButton(hidden: Bool) {
        overlayButton.alpha = hidden ? 0 : 1
        if hidden {
            view.sendSubviewToBack(overlayButton)
        } else {
            view.bringSubviewToFront(overlayButton)
        }
    }
}
