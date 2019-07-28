//
//  SPViewControllerOverride.swift
//  Demo
//
//  Created by Mikhail Sivykh on 20/07/2019.
//  Copyright © 2019 Mikhail Sivykh. All rights reserved.
//

import UIKit

public extension SPViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateFrames()
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(leftView)
        view.addSubview(rightView)
        view.addSubview(centerView)

        overlayButton.frame = view.bounds
        view.addSubview(overlayButton)
        updateFrames()
        
        leftEdgeGesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(didRecognizeEdgePan(gesture:))
        )
        leftEdgeGesture.edges = .left
        view.addGestureRecognizer(leftEdgeGesture)
        
        rightEdgeGesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(didRecognizeEdgePan(gesture:))
        )
        rightEdgeGesture.edges = .right
        view.addGestureRecognizer(rightEdgeGesture)
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didRecognizePan(gesture:)))
        centerView.addGestureRecognizer(panGesture)
        
        panGesture.require(toFail: leftEdgeGesture)
        panGesture.require(toFail: rightEdgeGesture)
        
        panGesture.isEnabled = centerViewController != nil &&
            (leftAppearanceRule == .under || rightAppearanceRule == .under)
        leftEdgeGesture.isEnabled = leftViewController != nil
        rightEdgeGesture.isEnabled = rightViewController != nil
        
        if let centerNavigationVC = centerViewController as? UINavigationController,
            let popRecognizer = centerNavigationVC.interactivePopGestureRecognizer {
            leftEdgeGesture?.require(toFail: popRecognizer)
        }
    }
    
    override var childForStatusBarStyle: UIViewController? {
        switch presentedContent {
        case .left:
            return leftViewController
        case .center:
            return centerViewController
        case .right:
            return rightViewController
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch presentedContent {
        case .left:
            return leftViewController?.preferredStatusBarStyle ?? .default
        case .center:
            return centerViewController?.preferredStatusBarStyle ?? .default
        case .right:
            return rightViewController?.preferredStatusBarStyle ?? .default
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        switch presentedContent {
        case .left:
            return leftViewController?.supportedInterfaceOrientations ?? .all
        case .center:
            return centerViewController?.supportedInterfaceOrientations ?? .all
        case .right:
            return rightViewController?.supportedInterfaceOrientations ?? .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        switch presentedContent {
        case .left:
            return leftViewController?.prefersStatusBarHidden ?? false
        case .center:
            return centerViewController?.prefersStatusBarHidden ?? false
        case .right:
            return rightViewController?.prefersStatusBarHidden ?? false
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}

