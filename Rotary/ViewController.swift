//
//  ViewController.swift
//  Rotary
//
//  Created by Phineas on 2018/11/25.
//  Copyright © 2018 Phineas. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    lazy var wheel : SMRotaryWheel = SMRotaryWheel(frame: CGRect(x: 0, y: 0, width: 200, height: 200), sectionsCount: 6)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(wheel)
        wheel.backgroundColor = UIColor.yellow
    }


}

