//
//  CustomBookCollection.swift
//  BookApp
//
//  Created by kien le van on 8/17/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CustomBookCollection: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var bookCollection: UICollectionView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    
    var bookArray = [Book]()
    var callBackClickCell:((_ book: Book) -> Void)?
    var callBackReloadButton = {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        self.bookCollection.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
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
    
    public func setupView(image: UIImage) {
        detailImage.image = image
    }
    
    // MARK: Colection Data Source
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return bookArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bookCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? BookCollectionViewCell
        cell?.binData(book: bookArray[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthSpace: CGFloat = 21
        widthSpace.adjustsSizeToRealIPhoneSize = 12
        let widthPerItem = (bookCollection.frame.size.width - widthSpace * 2) / 3 - 1
        let hightPerItem = bookCollection.frame.size.height
        
        return CGSize(width: widthPerItem, height: hightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        var space: CGFloat = 1
        space.adjustsSizeToRealIPhoneSize = 12
        return space
    }
    
    // MARK: Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callBackClickCell?(bookArray[indexPath.row])
    }
    
    func reloadData(arrayOfBook: [Book]) {
        bookArray = arrayOfBook
        bookCollection.reloadData()
    }
    
    @IBAction func presedButton(_ sender: Any) {
        self.callBackReloadButton()
    }
}
