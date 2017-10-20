//
//  BottomView.swift
//  BookApp
//
//  Created by Le Cong on 8/10/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class BottomView: UIView {
    
    var pressedBottomButton:((_ index: BottomButton) -> Void)?
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var numberBookmark: UILabel!
    @IBOutlet weak var numberLike: UILabel!
    @IBOutlet weak var numberComment: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var bookMarkImage: UIImageView!
    
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
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view!
    }
    
    func hiddenBottom() {
        backButton.isHidden = true
        backImage.isHidden = true
        bookMarkImage.isHidden = true
        bookMarkButton.isHidden = true
        downloadImage.isHidden = true
        downloadButton.isHidden = true
        numberBookmark.isHidden = true
    }

    @IBAction func pressedBack(_ sender: Any) {
        self.pressedBottomButton!(BottomButton.back)
    }
    
    @IBAction func pressedComment(_ sender: Any) {
        self.pressedBottomButton!(BottomButton.comment)
    }
    
    @IBAction func pressedLikeButton(_ sender: Any) {
        self.pressedBottomButton!(BottomButton.like)
    }

    @IBAction func pressedBookMarkButton(_ sender: Any) {
        self.pressedBottomButton!(BottomButton.bookMark)
    }
    
    @IBAction func pressedDownloadButton(_ sender: Any) {
        self.pressedBottomButton!(BottomButton.download)
    }
}
