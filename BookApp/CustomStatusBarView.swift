//
//  CustomStatusBarView.swift
//  BookApp
//
//  Created by kien le van on 10/27/17.
//
//

import UIKit

class CustomStatusBarView: UIView {

    var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Download Success".localized
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 11)
        return label
    }()
    var imageView: UIImageView?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor.rgb(201, 201, 201)
        imageView = UIImageView(frame: CGRect(x: 16, y: 3.5, width: 13, height: 13))
        imageView?.image = #imageLiteral(resourceName: "thumb")
        addSubview(imageView!)
        addSubview(statusLabel)
        statusLabel.addConstraintCenter(to: self, x: 0, y: 0)
    }
}
