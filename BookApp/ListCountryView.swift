//
//  ListCountryView.swift
//  BookApp
//
//  Created by kien le van on 10/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ListCountryView: UIView, UITableViewDataSource, UITableViewDelegate {

    var callBack:((_ codeCountry: String) -> Void) = {_ in}
    @IBOutlet weak var table: UITableView!
    var listCountry = [String]()
    
    let arrayCountry: [String] = ["南韓 82", "日本 81", "台灣 886", "香港 852", "澳門 853", "中國大陸 86",
                                  "泰國 66", "馬來西亞 60", "新加坡 65", "菲律賓 63", "印尼 62", "越南 84",
                                  "印度 91", "澳洲 61", "紐西蘭 64", "帛琉 680", "大溪地 689", "美國 1",
                                  "夏威夷 1", "關島 1671", "加拿大 1", "巴拿馬 507", "阿根廷 54", "巴西 55",
                                  "英國 44", "法國 33", "義大利 39", "西班牙 34", "葡萄牙 351", "希臘 30",
                                  "瑞典 46", "奧地利 43", "德國 49", "荷蘭 31", "挪威 47", "俄羅斯 7",
                                  "南非共合國 27", "埃及 20", "摩洛哥 212", "模里西斯 230", "肯亞 254"
                                    ]
    let arrayCountry2: [String] = ["南韩 82", "日本 81", "台湾 886", "香港 852", "澳门 853", "中国大陆 86",
                                   "泰国 66", "马来西亚 60", "新加坡 65", "菲律宾 63", "印尼 62", "越南 84",
                                   "印度 91", "澳洲 61", "纽西兰 64", "帛琉 680", "大溪地 689", "美洲 美国 1",
                                   "夏威夷 1", "关岛 1671", "加拿大 1", "巴拿马 507", "阿根廷 54", "巴西 55",
                                   "欧洲英国 44", "法国 33", "义大利 39", "西班牙 34", "葡萄牙 351", "希腊 30",
                                   "瑞典 46", "奥地利 43", "德国 49", "荷兰 31", "挪威 47", "俄罗斯 7",
                                   "非洲南非共合国 27", "埃及 20", "摩洛哥 212", "摩洛哥 212", "肯亚 254"
                                   ]
    
    // MARK: Load View From Xib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        table.register(UINib.init(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
        if Constants.sharedInstance.language == 0 {
            self.listCountry = arrayCountry
        } else {
            self.listCountry = arrayCountry2
        }
    }
    
    static func instance() -> UIView {
        if let view = Bundle.main.loadNibNamed(String(describing: self.self), owner: self, options: nil)?.first as? UIView {
            return view
        }
        return UIView()
    }
    
    func show() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        let windown = UIApplication.shared.delegate?.window
        windown!!.addSubview(self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CountryCell
        cell?.binData(nameCountry: listCountry[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = listCountry[indexPath.row].components(separatedBy: " ")
        self.callBack(country[1])
        self.removeFromSuperview()
    }
   
    @IBAction func pressClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
