//
//  CustomTopTabbar.swift
//  BookApp
//
//  Created by kien le van on 8/21/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CustomTopTabbar: UIView {
    
    var changeViewPressed:(( _ originX: CGFloat, _ originY: CGFloat, _ widdth: CGFloat, _ hight: CGFloat, _ forIndex: Int) -> Void)?
    var showVideoPressed = {}
    var showTextPressed = {}
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    
    private var originY: CGFloat!
    private var width: CGFloat!
    private var hight: CGFloat!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        originY = animationView.frame.origin.y
        width = widthScreen/3
        hight = animationView.frame.size.height
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

    @IBAction func showAudio(_ sender: Any) {
        self.changeViewPressed!(audioButton.frame.origin.x, originY!, width!, hight!, 0)
    }
    
    @IBAction func showVideo(_ sender: Any) {
        self.changeViewPressed!(videoButton.frame.origin.x, originY!, width!, hight!, 1)
    }
    
    @IBAction func showText(_ sender: Any) {
        self.changeViewPressed!(textButton.frame.origin.x, originY, width!, hight!, 2)
    }
}
