//
//  ViewController.swift
//  BookApp
//
//  Created by kien le van on 9/25/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import TYPagerController

class AllTypeBookController: TYTabPagerController {
    
    var listTitles: [BookType] = []
    var startIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.layout.barStyle = TYPagerBarStyle.progressView
        self.tabBar.layout.animateDuration = 0.2
        self.tabBar.backgroundColor = UIColor.rgb(241, 241, 241)
        self.tabBar.layout.progressColor = UIColor.rgb(255, 102, 0)
        self.tabBar.layout.progressBorderColor = UIColor.rgb(255, 102, 0)
        self.tabBar.layout.selectedTextColor = UIColor.rgb(255, 102, 0)
        self.tabBar.layout.cellSpacing = 0
        self.dataSource = self
        self.delegate = self
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pagerController.scrollToController(at: startIndex, animate: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func loadData() {
        self.updateData()
    }
}

extension AllTypeBookController: TYTabPagerControllerDelegate, TYTabPagerControllerDataSource {
    func numberOfControllersInTabPagerController() -> Int {
        return listTitles.count
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, controllerFor index: Int, prefetching: Bool) -> UIViewController {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SingleTypeBookController") as? SingleTypeBookController
        vc?.typeBook = listTitles[index]
        return vc!
    }
    
    func tabPagerController(_ tabPagerController: TYTabPagerController, titleFor index: Int) -> String {
        let title = listTitles[index].name
        return title
    }
}
