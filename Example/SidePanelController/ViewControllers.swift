//
//  ViewControllers.swift
//  SidePanelController_Example
//
//  Created by Mikhail Sivykh on 21/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

class RedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        label.backgroundColor = .init(white: 1, alpha: 0.6)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "This is a \(String(describing: type(of: self))).\nIt aims to be used as demo view controller."
        label.autoresizingMask = [.flexibleWidth]
        view.addSubview(label)
    }
}

class GreenViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        
        let left = UIButton(frame: CGRect(x: 10, y: 50, width: 100, height: 44))
        left.setTitleColor(.darkText, for: .normal)
        left.setTitle("Toggle left", for: .normal)
        left.addTarget(self, action: #selector(showLeft), for: .touchUpInside)
        view.addSubview(left)
        
        let right = UIButton(frame: CGRect(x: view.bounds.width - 110, y: 50, width: 100, height: 44))
        right.setTitleColor(.darkText, for: .normal)
        right.autoresizingMask = [.flexibleLeftMargin]
        right.setTitle("Toggle right", for: .normal)
        right.addTarget(self, action: #selector(showRight), for: .touchUpInside)
        view.addSubview(right)
        
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        label.backgroundColor = .init(white: 1, alpha: 0.6)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "This is a \(String(describing: type(of: self))).\nIt aims to be used as demo view controller."
        label.autoresizingMask = [.flexibleWidth]
        view.addSubview(label)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 350, width: view.bounds.width, height: 50))
        label2.tag = 777
        label2.font = UIFont.systemFont(ofSize: 40)
        label2.textAlignment = .center
        label2.autoresizingMask = [.flexibleWidth]
        view.addSubview(label2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let label2 = view.viewWithTag(777) as? UILabel {
            label2.text = self.sidePanelController?.title ?? ""
        }
    }
    
    @objc private func showLeft() {
        self.sidePanelController?.toggleLeft()
    }
    
    @objc private func showRight() {
        self.sidePanelController?.toggleRight()
    }
}

class BlueViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 200))
        label.backgroundColor = .init(white: 1, alpha: 0.6)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "This is a \(String(describing: type(of: self))).\nIt aims to be used as demo view controller."
        label.autoresizingMask = [.flexibleWidth]
        view.addSubview(label)
    }
}
