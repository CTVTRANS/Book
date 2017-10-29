//
//  AppInfomationViewController.swift
//  BookApp
//
//  Created by kien le van on 9/14/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class AppInfomationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
