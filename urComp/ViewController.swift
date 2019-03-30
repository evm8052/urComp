//
//  ViewController.swift
//  urComp
//
//  Created by spoonik on 2018/10/18.
//  Copyright © 2018 spoonikapps. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        HealthData.sharedManager.activateHealthKit()
        super.viewDidLoad()
    }
}

