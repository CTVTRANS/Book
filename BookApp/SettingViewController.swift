//
//  SettingViewController.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var arraySetting = [ListSetting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Help Center".localized,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(pressedRightBarButton))
        table.register(UINib.init(nibName: "SettingViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        customData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.isTranslucent = false
    }
    
    @objc func pressedRightBarButton() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SupportCustomController") as? SupportCustomController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func customData() {
        let setting1 = SettingCellModel(name: "Personal information".localized, specialName: "", arrrowDetail: true, nameDetail: "")
        let setting2 = SettingCellModel(name: "Clear download".localized, specialName: "", arrrowDetail: false, nameDetail: "")
        let setting3 = SettingCellModel(name: "AboutApp".localized, specialName: "", arrrowDetail: true, nameDetail: "")

        let arraySetting1 = ListSetting(array: [setting1])
        let arraySetting2 = ListSetting(array: [setting2, setting3])
        arraySetting.append(arraySetting1)
        arraySetting.append(arraySetting2)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arraySetting.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySetting[section].arr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 15
        height.adjustsSizeToRealIPhoneSize = 15
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 37
        height.adjustsSizeToRealIPhoneSize = 37
        return height
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var height: CGFloat = 15
        height.adjustsSizeToRealIPhoneSize = 15
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: height))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingViewCell {
            let secsionObject = arraySetting[indexPath.section]
            cell.name.textColor = UIColor.black
            cell.binData(settingCell: secsionObject.arr[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if ProfileMember.getToken() == "" {
                goToSigIn()
                return
            }
            if let vc = storyboard?.instantiateViewController(withIdentifier: "MyprofileViewController") as? MyprofileViewController {
                navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        let row = indexPath.row
        switch row {
        case 0:
            let listBook = [Book]()
            Book.saveBook(myBook: listBook)
            let listLesson = [Lesson]()
            Lesson.saveLesson(lesson: listLesson)
            UIAlertController.showAler(title: "", message: "clear Download".localized, inViewController: self)
        case 1:
            if let vc = storyboard?.instantiateViewController(withIdentifier: "AppInfomationViewController") as? AppInfomationViewController {
                navigationController?.pushViewController(vc, animated: true)
            }
        default:
            break
        }
    }
}
