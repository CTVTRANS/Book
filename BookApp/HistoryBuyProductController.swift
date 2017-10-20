//
//  HistoryBuyProductController.swift
//  BookApp
//
//  Created by kien le van on 9/13/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class HistoryBuyProductController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        table.register(UINib.init(nibName: "ListBookFreee", bundle: nil), forCellReuseIdentifier: "bookCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let cell2 = table.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? ListBookFreee
        cell2?.bottomView.isHidden = true
        if indexPath.row < 6 {
            return cell1
        }
        return cell2!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
