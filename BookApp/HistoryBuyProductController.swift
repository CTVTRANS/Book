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
    var listHistory: [HistoryBuy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        navigationItem.title = "购物记录"
        getHistoryVip()
        getHistoryBook()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func getHistoryVip() {
        let getData = GetHistoryBuyVipTask(idmember: (memberInstance?.idMember)!, token: tokenInstance!)
        requestWithTask(task: getData, success: { (data) in
            if let vip = data as? [HistoryBuy] {
                self.listHistory += vip
                self.table.reloadData()
            }
        }) { (_) in
            
        }
    }
    
    func getHistoryBook() {
        let getData = GetHIstoryBuyBookTask(idmember: (memberInstance?.idMember)!, token: (tokenInstance!))
        requestWithTask(task: getData, success: { (data) in
            if let book = data as? [HistoryBuy] {
                self.listHistory += book
                self.table.reloadData()
            }
        }) { (_) in
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell1 = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryMarkCell
        let cell2 = table.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? HistoryCellBook
        let product = listHistory[indexPath.row]
        if product.producBook == nil {
            cell1?.binData(history: product)
            return cell1!
        }
        cell2?.binData(historyBook: product)
        return cell2!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

class HistoryCellBook: UITableViewCell {
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    func binData(historyBook: HistoryBuy) {
        name.text = historyBook.producBook?.name
        imageBook.sd_setImage(with: URL(string: (historyBook.producBook?.imageURL)!))
        time.text = historyBook.time.components(separatedBy: " ")[0]
        let arrayString = historyBook.producBook?.descriptionBook.components(separatedBy: "</p>")
        let firstString = arrayString?[0]
        let index = firstString?.index((firstString?.startIndex)!, offsetBy: 3)
        detail.text = firstString?.substring(from: index!)
    }
}
