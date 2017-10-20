//
//  ShowAllActivityGroupController.swift
//  BookApp
//
//  Created by kien le van on 9/8/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ShowAllActivityGroupController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var table: UITableView!
    private var arraySecsionGroup: [SectionGroup] = []
    private var listGroup: [SecrectGroup] = []
    private var listTitleSecrion: [String] = []
    
    var listIDGroupJoined = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        table.estimatedRowHeight = 140
        table.tableFooterView = UIView()

        setupNavigation()
        addButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func setupNavigation() {
        navigationItem.title = "分會關注"
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "分會圈子", style: .done, target: self, action: #selector(pressRightBarButton))
    }
    
    // MARK: Get Data
    
    func getData() {
        let getAllGroup: GetAllGroupTask = GetAllGroupTask(memberID: (memberInstance?.idMember)!)
        requestWithTask(task: getAllGroup, success: { (data) in
            self.listGroup = (data as? [SecrectGroup])!
            self.listGroup = self.listGroup.sorted(by: { (ob1, ob2) -> Bool in
                return ob1.charaterGroup.compare(ob2.charaterGroup) == .orderedAscending
            })
            self.arraySecsionGroup = self.createDictionaryObject(groupObject: self.listGroup)
            self.table.reloadData()
            self.stopActivityIndicator()
        }) { (error) in
            self.stopActivityIndicator()
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
        
        let getGroupJoined: GetGroupJoinedTask = GetGroupJoinedTask(idMember: (memberInstance?.idMember)!)
        requestWithTask(task: getGroupJoined, success: { (data) in
            Constants.sharedInstance.listGroupJoined = (data as? [SecrectGroup])!
            for group in  Constants.sharedInstance.listGroupJoined {
                self.listIDGroupJoined.insert(group.idGroup)
            }
        }) { (error) in
            self.stopActivityIndicator()
            _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
    }
    
    // MARK: Create Dictionary Object
    
    func createDictionaryObject(groupObject: [SecrectGroup]) -> [SectionGroup] {
        var dictionaryGroup: [SectionGroup] = []
        var charterGroup = ""
        for group in groupObject {
            if group.charaterGroup == "" {
                continue
            }
            if group.charaterGroup.compare(charterGroup) != .orderedSame {
                charterGroup = group.charaterGroup
                listTitleSecrion.append(charterGroup)
                let array = groupObject.filter({ (object: SecrectGroup) -> Bool in
                    return object.charaterGroup == charterGroup
                })
                let secsion = SectionGroup(charater: charterGroup, array: array)
                dictionaryGroup.append(secsion)
            }
        }
        return dictionaryGroup
    }
    
    // MARK: TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arraySecsionGroup.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return listTitleSecrion
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arraySecsionGroup[section].chraterGroup
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arraySecsionGroup[section].arrayGroup?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ActivityGroupCell {
            let arrayGroup = arraySecsionGroup[indexPath.section].arrayGroup
            cell.binData(group: (arrayGroup?[indexPath.row])!)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let arrayGroup = arraySecsionGroup[indexPath.section].arrayGroup
        let group = arrayGroup?[indexPath.row]
        if listIDGroupJoined.contains((group?.idGroup)!) {
            group?.isSubcrible = false
            for index in 0..<Constants.sharedInstance.listGroupJoined.count where group?.idGroup == Constants.sharedInstance.listGroupJoined[index].idGroup {
                    listIDGroupJoined.remove((group?.idGroup)!)
                    Constants.sharedInstance.listGroupJoined.remove(at: index)
                break
            }
        } else {
            group?.isSubcrible = true
            listIDGroupJoined.insert((group?.idGroup)!)
            Constants.sharedInstance.listGroupJoined.append(group!)
        }
        table.reloadData()
    }
    
    func pressRightBarButton() {
        if !checkLogin() {
            goToSigIn()
            return
        }
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GroupJoinedViewController") as? GroupJoinedViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions.prettyPrinted) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    // MARK: UIControl
    
    @IBAction func pressedAddButton(_ sender: Any) {
        if !checkLogin() {
            goToSigIn()
            return
        }
        let arrayListIdGroup = Array(listIDGroupJoined)
        let jsonObject: String = notPrettyString(from: arrayListIdGroup)!
        print(jsonObject)
        let subcrible: SubcribleGroupTask = SubcribleGroupTask(memberID: (memberInstance?.idMember)!, arryID: jsonObject, token: tokenInstance!)
        requestWithTask(task: subcrible, success: { (data) in
            if let status = data as? Bool {
                if status {
                    _ = UIAlertController.initAler(title: "", message: "success", inViewController: self)
                }
            }
        }) { (error) in
             _ = UIAlertController(title: nil, message: error as? String, preferredStyle: .alert)
        }
    }
}

class SectionGroup: NSObject {
    var chraterGroup: String?
    var arrayGroup: [SecrectGroup]?
    
    init(charater: String, array: [SecrectGroup]) {
        chraterGroup = charater
        arrayGroup = array
    }
}
