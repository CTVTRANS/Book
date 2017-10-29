//
//  Base_Dailog.swift
//  BookApp
//
//  Created by kien le van on 9/27/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class BaseDailog: UIView {

    @IBOutlet weak var contenView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
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
        contenView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .layoutSubviews, animations: { [weak self] in
            self?.contenView.transform = CGAffineTransform.identity
        }) { (_) in
            
        }
    }
    
    func hide() {
        contenView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.2, animations: { [weak self] _ in
            self?.contenView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func pressHidden(_ sender: Any) {
        hide()
    }

}
