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
        let toggle = {
            let hide = self.presentedContent == .right
            self.overlayButton.alpha = hide || self.rightAppearanceRule == .under ? 0 : 1
            self.rightViewController?.beginAppearanceTransition(!hide, animated: animated)
            self.presentedContent = hide ? .center : .right
            self.updateFrames()
            self.rightViewController?.endAppearanceTransition()
        }
        if animated {
            UIView.animate(withDuration: 0.3, animations: toggle)
        } else {
            toggle()
        }
    }
    
    public func toggleLeft(animated: Bool) {
        let toggle = {
            let hide = self.presentedContent == .left
            self.overlayButton.alpha = hide || self.leftAppearanceRule == .under ? 0 : 1
            self.leftViewController?.beginAppearanceTransition(!hide, animated: animated)
            self.presentedContent = hide ? .center : .left
            self.updateFrames()
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
            self.overlayButton.alpha = rule == .under ? 0 : 1
            appearingController?.beginAppearanceTransition(true, animated: animated)
            if shouldCallDisappear {
                disappearingController?.beginAppearanceTransition(false, animated: animated)
            }
            self.presentedContent = content
            self.updateFrames()
            appearingController?.endAppearanceTransition()
            if shouldCallDisappear {
                disappearingController?.endAppearanceTransition()
            }
        }
        let block = {
            switch content {
            case .left:
                action((self.leftAppearanceRule, self.leftViewController, self.rightViewController, content))
            case .right:
                action((self.rightAppearanceRule, self.rightViewController, self.leftViewController, content))
            case .center:
                self.overlayButton.alpha = 0
                let disappearingController =
                    self.presentedContent == .left ? self.leftViewController : self.rightViewController
                disappearingController?.beginAppearanceTransition(false, animated: animated)
                self.presentedContent = content
                self.updateFrames()
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
