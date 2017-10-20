//
//  CustomHistorySearch.swift
//  BookApp
//
//  Created by kien le van on 9/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CustomHistorySearch: UIView {
    
    private var linecount = 1
    private var originY: CGFloat = 0.0
    private var originX: CGFloat = 16.0
    private let spaceHorizontoal: CGFloat = 12.0
    private let spaceVertical: CGFloat = 10.0
    
    var listText: [String] = []
    var callBackButton:((_ nameButton: String) -> Void)?
    
//    private var myView: UIView?
    private var height: CGFloat = 0.0
    var heightForView: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        show(aray: listText)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        show(aray: listText)
    }
    
    private func viewfromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        }
        return UIView()
    }
    
    private func show(aray: [String]) {
        for index in 0..<listText.count {
            let button = UIButton()
            button.setTitle(aray[index], for: .normal)
            button.tag = index
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 0.5
            var sizeFont: CGFloat = 13
            sizeFont.adjustsSizeToRealIPhoneSize = 13
            
            button.titleLabel!.font = UIFont(name: "DFHeiStd-W5", size: sizeFont)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = UIColor.rgb(201, 201, 201).cgColor
            var widthButton = (button.titleLabel?.intrinsicContentSize.width)! + 20
            let heightButton = (button.titleLabel?.intrinsicContentSize.height)! + 8
            height = heightButton
            if originX + widthButton + spaceHorizontoal > widthScreen {
                linecount += 1
                originX = 16.0
            }
            if widthButton >= frame.size.width {
                widthButton = frame.size.width - 16
            }
            
            let yButton = originY + spaceVertical * CGFloat(linecount) + CGFloat((linecount - 1)) * heightButton
            button.frame = CGRect(x: originX, y: yButton, width: widthButton, height: heightButton)
            addSubview(button)
            originX += (widthButton + 10.0)
            button.addTarget(self, action: #selector(pressedButton(_ :)), for: .touchUpInside)
        }
        heightForView = originY + spaceVertical * CGFloat(linecount) + CGFloat(linecount) * height
    }
    
    func realoadData() {
        subviews.forEach({$0.removeFromSuperview()})
        originX = 16.0
        linecount = 1
        show(aray: listText)
    }
    
    @objc func pressedButton(_ sender: UIButton) {
        self.callBackButton!(listText[sender.tag])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
