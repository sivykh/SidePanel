//
//  TabBarViewController.swift
//  SidePanelController_Example
//
//  Created by Mikhail Sivykh on 21/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SidePanelController

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let above = SPViewController()
        above.title = "Above"
        above.setAppearance(.above)
        above.centerViewController = GreenViewController()
        above.leftViewController = RedViewController()
        above.rightViewController = BlueViewController()
        
        let under = SPViewController()
        under.title = "Under"
        under.setAppearance(.under)
        under.centerViewController = GreenViewController()
        under.leftViewController = RedViewController()
        under.rightViewController = BlueViewController()
        
        let different = SPViewController()
        different.title = "Different"
        different.leftAppearanceRule = .above
        different.rightAppearanceRule = .under
        different.centerViewController = GreenViewController()
        different.leftViewController = RedViewController()
        different.rightViewController = BlueViewController()
        
        let left = SPViewController()
        left.title = "Only left"
        left.centerViewController = GreenViewController()
        left.leftViewController = RedViewController()

        let right = SPViewController()
        right.title = "Only right"
        right.sidePanelWidth = 300
        right.centerViewController = GreenViewController()
        right.rightViewController = BlueViewController()
        
        self.viewControllers = [above, under, different, left, right]
    }

}
