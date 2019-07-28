//
//  UIViewController+SP.swift
//  Demo
//
//  Created by Mikhail Sivykh on 20/07/2019.
//  Copyright © 2019 Mikhail Sivykh. All rights reserved.
//

import UIKit

public extension UIViewController {
    private struct AssociatedKeys {
        static var sidePanelController = "sidePanelControllerAssociatedKey"
    }
    
    internal(set) var sidePanelController: SPViewController? {
        get {
            if let side = objc_getAssociatedObject(self, &AssociatedKeys.sidePanelController) as? SPViewController {
                return side
            } else if let nc = self.navigationController {
                return objc_getAssociatedObject(nc, &AssociatedKeys.sidePanelController) as? SPViewController
            } else {
                return nil
            }
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self, &AssociatedKeys.sidePanelController, newValue, .OBJC_ASSOCIATION_ASSIGN
                )
            } else {
                objc_setAssociatedObject(
                    self, &AssociatedKeys.sidePanelController, nil, .OBJC_ASSOCIATION_ASSIGN
                )
            }
        }
    }
}
