//
//  SPGestures.swift
//  Demo
//
//  Created by Mikhail Sivykh on 20/07/2019.
//  Copyright © 2019 Mikhail Sivykh. All rights reserved.
//

import UIKit

private extension UIGestureRecognizer {
    func cancel() {
        isEnabled = false; isEnabled = true
    }
}

// MARK: - Handle gestures

internal extension SPViewController {
    
    @objc func didRecognizePan(gesture: UIPanGestureRecognizer) {
        let translatedPoint = gesture.translation(in: view)
        let translated: CGFloat = translatedPoint.x
        let isLeftActive: Bool = leftAppearanceRule == .under && leftViewController != nil
        let isRightActive: Bool = rightAppearanceRule == .under && rightViewController != nil
        let maxX: CGFloat = isLeftActive ? sidePanelWidth : 0
        let minX: CGFloat = isRightActive ? -sidePanelWidth : 0
        
        guard (translated >= 0 && (isLeftActive || presentedContent == .right)) ||
            (translated <= 0 && (isRightActive || presentedContent == .left)) else {
                gesture.cancel()
                UIView.animate(withDuration: 0.3, animations: updateFrames)
                return
        }
        
        switch gesture.state {
        case .began:
            originalX = centerView.frame.origin.x
            view.bringSubviewToFront(centerView)
        case .changed:
            centerView.frame.origin.x = max(minX, min(maxX, originalX + translated))
            if centerView.frame.origin.x > 0 {
                leftView.frame.origin.x = 0
                if isRightActive {
                    rightView.frame.origin.x = leftView.frame.origin.x + leftView.frame.width
                } else {
                    rightView.frame.origin.x = view.frame.width
                }
            } else if centerView.frame.origin.x == 0 {
                leftView.frame.origin.x = isLeftActive ? 0 : -sidePanelWidth
                rightView.frame.origin.x = isRightActive ? view.frame.width - sidePanelWidth : view.frame.width
            } else {
                rightView.frame.origin.x = view.frame.width - sidePanelWidth
                if isLeftActive {
                    leftView.frame.origin.x = rightView.frame.origin.x - leftView.frame.width
                } else {
                    leftView.frame.origin.x = -leftView.frame.width
                }
            }
        case .ended:
            let percent = abs(translated / sidePanelWidth)
            if centerView.frame.origin.x > 0 && percent > 0.5 {
                toggleLeft(animated: true)
            } else if centerView.frame.origin.x < 0 && percent > 0.5 {
                toggleRight(animated: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    if self.centerView.frame.origin.x == 0 && percent > 0.5 {
                        self.presentedContent = .center
                    }
                    self.updateFrames()
                }
            }
        default:
            break
        }
    }
    
    @objc func didRecognizeEdgePan(gesture: UIScreenEdgePanGestureRecognizer) {
        let translatedPoint = gesture.translation(in: view)
        let isLeft = gesture.edges == .left
        let multi: CGFloat = isLeft ? 1 : -1
        let translated: CGFloat = min(sidePanelWidth, max(0, multi * translatedPoint.x))
        let percent = translated / sidePanelWidth
        
        switch gesture.state {
        case .began:
            guard !((isLeft && presentedContent == .left) || (!isLeft && presentedContent == .right)) else {
                gesture.cancel()
                return
            }
            guard !((isLeft && presentedContent == .right) || (!isLeft && presentedContent == .left)) else {
                UIView.animate(withDuration: 0.3) {
                    self.presentedContent = .center
                    self.updateFrames()
                }
                gesture.cancel()
                return
            }
            if isLeft && leftAppearanceRule == .under {
                view.bringSubviewToFront(leftView)
                view.bringSubviewToFront(centerView)
            } else if !isLeft && rightAppearanceRule == .under {
                view.bringSubviewToFront(rightView)
                view.bringSubviewToFront(centerView)
            }
        case .changed:
            if isLeft {
                if leftAppearanceRule == .under {
                    centerView.frame.origin.x = multi * translated
                } else {
                    overlayButton.alpha = percent
                    leftView.frame.origin.x = translated - leftView.frame.width
                }
            } else {
                if rightAppearanceRule == .under {
                    centerView.frame.origin.x = multi * translated
                } else {
                    overlayButton.alpha = percent
                    rightView.frame.origin.x = view.frame.width - translated
                }
            }
        case .ended:
            if isLeft && percent > 0.5 {
                toggleLeft(animated: true)
            } else if !isLeft && percent > 0.5 {
                toggleRight(animated: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.overlayButton.alpha = 0
                    self.updateFrames()
                }
            }
        default:
            break
        }
    }
}
