//
//  SPChildViewControllerHandling.swift
//  Demo
//
//  Created by Mikhail Sivykh on 20/07/2019.
//  Copyright © 2019 Mikhail Sivykh. All rights reserved.
//

import UIKit

internal extension SPViewController {
    func remove(viewController: UIViewController?, withAppearance: Bool) {
        guard let viewController = viewController else {
            return
        }
        if withAppearance {
            viewController.beginAppearanceTransition(false, animated: false)
        }
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
        viewController.sidePanelController = nil
        if withAppearance {
            viewController.endAppearanceTransition()
        }
    }
    
    func add(viewController: UIViewController?, to view: UIView, withAppearance: Bool) {
        guard let viewController = viewController else {
            return
        }
        if withAppearance {
            viewController.beginAppearanceTransition(true, animated: false)
        }
        viewController.willMove(toParent: self)
        view.addSubview(viewController.view)
        addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.sidePanelController = self
        if withAppearance {
            viewController.endAppearanceTransition()
        }
    }
    
    func instanciateOverlayButton() -> UIButton {
        let button = UIButton()
        button.alpha = 0
        button.backgroundColor = sideOverlayViewColor
        button.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        button.addTarget(self, action: #selector(didTapOnPanelMargin), for: .touchUpInside)
        return button
    }
    
    func updateFrames() {
        let sidePanelMarginWidth = view.frame.width - sidePanelWidth

        switch presentedContent {
        case .left:
            leftView.frame = viewFrameWith(0, sidePanelWidth)
            centerView.frame = leftAppearanceRule == .above ?
                view.bounds :
                viewFrameWith(sidePanelWidth, view.frame.width)
            rightView.frame = viewFrameWith(view.frame.width, sidePanelWidth)
        case .center:
            leftView.frame = leftAppearanceRule == .under ?
                viewFrameWith(0, sidePanelWidth) :
                viewFrameWith(-sidePanelWidth, sidePanelWidth)
            centerView.frame = view.bounds
            rightView.frame = rightAppearanceRule == .under ?
                viewFrameWith(sidePanelMarginWidth, sidePanelWidth) :
                viewFrameWith(view.frame.width, sidePanelWidth)
        case .right:
            leftView.frame = viewFrameWith(-sidePanelWidth, sidePanelWidth)
            centerView.frame = rightAppearanceRule == .above ?
                view.bounds :
                viewFrameWith(-sidePanelWidth, view.frame.width)
            rightView.frame = viewFrameWith(sidePanelMarginWidth, sidePanelWidth)
        }
        
        leftViewController?.view.frame = leftView.bounds
        centerViewController?.view.frame = centerView.bounds
        rightViewController?.view.frame = rightView.bounds
        
        view.bringSubviewToFront(centerView)
        view.bringSubviewToFront(overlayButton)
        if leftAppearanceRule == .above {
            view.bringSubviewToFront(leftView)
        }
        if rightAppearanceRule == .above {
            view.bringSubviewToFront(rightView)
        }
    }
}

// MARK: - Handling the tap on empty space

private extension SPViewController {
    func viewFrameWith(_ customX: CGFloat, _ customWidth: CGFloat) -> CGRect {
        return CGRect(x: customX, y: 0, width: customWidth, height: self.view.frame.height)
    }

    @objc func didTapOnPanelMargin() {
        switch presentedContent {
        case .left:
            toggleLeft(animated: true)
        case .center:
            break
        case .right:
            toggleRight(animated: true)
        }
    }
}
