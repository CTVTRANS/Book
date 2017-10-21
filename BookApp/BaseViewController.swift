//
//  BaseViewController.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork
import AFNetworking
import Social
import SWRevealViewController
import SDWebImage

class BaseViewController: UIViewController {
    
    var activity: UIActivityIndicatorView?
    var backGroundview: UIView?
    let managerNetWork = AFNetworkReachabilityManager.shared()
    lazy var globalStoryboard = UIStoryboard(name: "Global", bundle: nil)
    lazy var memberInstance = ProfileMember.getProfile()
    lazy var tokenInstance = ProfileMember.getToken()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        AFNetworkReachabilityManager.shared().startMonitoring()
    }
    
    func setupRightSlideOut() {
        if self.revealViewController() != nil {
            revealViewController().rightViewRevealWidth = 80
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_share_rightBar"), style: .plain, target: self.revealViewController(), action: #selector(revealViewController().rightRevealToggle(_:)))
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    func requestWithTask(task: BaseTaskNetwork, success: @escaping BlockSuccess, failure: @escaping BlockFailure) {
        if AFNetworkReachabilityManager.shared().isReachable {
            task.request(blockSucess: { (data) in
                success(data)
            }) { (error) in
                failure(error)
            }
        } else {
            _ = UIAlertController.initAler(title: "", message: "No internet access", inViewController: self)
        }
    }
    
    func downloadFileSuccess(task: BaseTaskNetwork, success: @escaping BlockSuccess, failure: @escaping BlockFailure) {
        task.downloadFileSuccess({ (data) in
            success(data)
        }) { (error) in
            failure(error)
        }
    }
    
    func downloadFileWithProcess(task: BaseTaskNetwork, process:  @escaping BlockProgress, success: @escaping BlockSuccess, failure: @escaping BlockFailure) {
        task.downloadFile(progress: { (percent) in
            process(percent)
        }, success: { (data) in
            success(data)
        }) { (error) in
            failure(error)
        }
    }
    
    func uploadFileWithTask(task: BaseTaskNetwork, success: @escaping BlockSuccess, failure: @escaping BlockFailure) {
        task.upLoadFile({ (data) in
            success(data)
        }) { (error) in
            failure(error)
        }
    }
    
    func showActivity(inView myView: UIView) {
//        backGroundview = UIView(frame: UIScreen.main.bounds)
        backGroundview = UIView(frame: myView.frame)
        backGroundview?.backgroundColor = UIColor.white
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        loadingView.backgroundColor = UIColor.clear
        activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loadingView.addSubview(activity!)
        let nameLoading = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        nameLoading.font = UIFont(name: "Helvetica Neue", size: 15)
        nameLoading.text = "loading..."
        nameLoading.textAlignment = .center
        nameLoading.textColor = UIColor.gray
        nameLoading.backgroundColor = UIColor.clear
        nameLoading.translatesAutoresizingMaskIntoConstraints = true
        loadingView.addSubview(nameLoading)
        
        backGroundview?.addSubview(loadingView)
        nameLoading.center = CGPoint(x: loadingView.center.x, y: loadingView.center.y + 23)
        activity?.center = loadingView.center
        loadingView.center = (backGroundview?.center)!
        myView.addSubview(backGroundview!)
//        UIApplication.shared.keyWindow?.addSubview(backGroundview!)
        activity?.startAnimating()
    }
    
    func stopActivityIndicator() {
        activity?.stopAnimating()
        backGroundview?.removeFromSuperview()
    }
    
    func goToSigIn() {
        let mystoryboard = UIStoryboard(name: "Global", bundle: nil)
        if let vc = mystoryboard.instantiateViewController(withIdentifier: "Login") as? UINavigationController {
            present(vc, animated: true, completion: nil)
        }
    }
    
    func checkLogin() -> Bool {
        let token = ProfileMember.getToken()
        if token == "" {
            return false
        }
        return true
    }
    
    func goToNotification(myViewController: BaseViewController) {
        if let vc = globalStoryboard.instantiateViewController(withIdentifier: "NotificationMessageViewController") as? NotificationMessageViewController {
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionReveal
            //kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
            //transition.subtype = kCATransitionFromTop; 
            //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
            myViewController.navigationController?.view.layer.add(transition, forKey: nil)
            myViewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func goToListPlayaudio() {
        if let vc = globalStoryboard.instantiateViewController(withIdentifier: "NotificationVideoViewController") as? UINavigationController {
            present(vc, animated: true, completion: nil)
        }
    }
    
    func goToSearch() {
        if let vc = globalStoryboard.instantiateViewController(withIdentifier: "Search") as? UINavigationController {
            present(vc, animated: true, completion: nil)
        }
    }
    
    func upDatePointBase(type: Int) {
        let updatepoint = UpdatePointTask(memberID: (self.memberInstance?.idMember)!,
                                          token: self.tokenInstance!,
                                          type: type)
        self.requestWithTask(task: updatepoint, success: { (_) in
            
        }, failure: { (_) in
            
        })
    }
    
    func goToPayment() {
        if let choosePay = ChooseMethodPayment.instance() as? ChooseMethodPayment {
            choosePay.show()
            choosePay.callBackWeChat = {
                print("wechat")
            }
            
            choosePay.callBackAlipay = {
                print("alipay")
            }
            
            choosePay.callBackIOS = {
                print("ios")
            }
        }
    }
}

extension UIView {
    class func initFooterView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: widthScreen, height: 100))
        let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activity.tag = 8
        activity.frame = CGRect(x: view.frame.size.width / 2 - 10, y: 40, width: 20, height: 20)
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        return view
    }
}
