//
//  VipDetailViewController.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class VipDetailViewController: BaseViewController {

    @IBOutlet weak var buyVipButton: UIButton!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var timeLimit: UILabel!
    @IBOutlet weak var statusVip: UILabel!
    @IBOutlet weak var nameMember: UILabel!
    
    private var vip: Vip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "會員狀態"
        getVip()
        nameMember.text = memberInstance?.name
        if memberInstance?.level == 0 {
            statusVip.text = "NO VIP"
            timeLimit.text = ""
        } else {
            statusVip.text = "VIP"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func getVip() {
        let getProductVip: GetProductVipTask = GetProductVipTask()
        requestWithTask(task: getProductVip, success: { (data) in
            if let arrayVip = data as? [Vip] {
                self.vip = arrayVip.first
                self.webView.loadHTMLString( css + (self.vip?.conten)!, baseURL: nil)
                let titleForButton = "立刻儲值升等 年費: " + String((self.vip?.point)!) +  "元"
                self.buyVipButton.setTitle(titleForButton, for: .normal)
            }
        }, failure: { (_) in
            
        })
    }
    @IBAction func pressBuyVip(_ sender: Any) {
        if (memberInstance?.point)! > (vip?.point)! {
            let buyVip = BuyVipPointTask(memberiD: (memberInstance?.idMember)!, token: tokenInstance!, type: 0, idVip: (vip?.idVip)!, numberYear: 1)
            requestWithTask(task: buyVip, success: { (data) in
                if let status = data as? Bool {
                    if status {
                        self.memberInstance?.point -= (self.vip?.point)!
                    }
                }
            }, failure: { (_) in
                
            })
        }
    }
}
