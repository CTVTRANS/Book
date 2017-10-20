//
//  NavigationCustom.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class NavigationCustom: UIView {
    
    @IBOutlet weak var imageNotifocation: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    var callBackTopButton:((_ typeButton: TopButton) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        let view = viewfromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleHeight,
            UIViewAutoresizing.flexibleWidth
        ]
        addSubview(view)
    }
    
    private func viewfromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        }
        return UIView()
    }
    
    func checkNotifocation() {
        if Constants.sharedInstance.hasNotification {
            imageNotifocation.isHidden = false
        } else {
            imageNotifocation.isHidden = true
        }
    }
    
    @IBAction func pressedMessageNotification(_ sender: Any) {
        Constants.sharedInstance.hasNotification = false
        imageNotifocation.isHidden = true
        self.callBackTopButton!(TopButton.messageNotification)
    }
    
    @IBAction func pressedVideoNotification(_ sender: Any) {
        self.callBackTopButton!(TopButton.videoNotification)
    }

    @IBAction func pressedSearch(_ sender: Any) {
        self.callBackTopButton!(TopButton.search)
    }
}
