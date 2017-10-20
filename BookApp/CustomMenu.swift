//
//  CustomMenu.swift
//  BookApp
//
//  Created by kien le van on 10/16/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CustomMenu: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collection: UICollectionView!
    var callBack:((_ idType: Int) -> Void) = {_ in }
    var arrayTypeNews: [NewsType] = []
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        self.collection.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collection.collectionViewLayout.invalidateLayout()
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
    
    // MARK: COollection Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayTypeNews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? MenuCollectionViewCell
        cell?.nameType.text = arrayTypeNews[indexPath.row].nameType
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sizeFont: CGFloat = 14
        sizeFont.adjustsSizeToRealIPhoneSize = 14
        let width = arrayTypeNews[indexPath.row].nameType.widthOfString(usingFont: UIFont(name: "DFHeiStd-W5", size: sizeFont)!)
        let height = arrayTypeNews[indexPath.row].nameType.heightOfString(usingFont: UIFont(name: "DFHeiStd-W5", size: sizeFont)!)
        return CGSize(width: width + 16, height: height + 10)
    }
    
    // MARK: Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.callBack(arrayTypeNews[indexPath.row].idType)
    }
    
    func reloadType(array: [NewsType]) {
        arrayTypeNews = array
        collection.reloadData()
    }
}

extension String {
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSFontAttributeName: font]
        let size = self.size(attributes: fontAttributes)
        return size.height
    }
}
