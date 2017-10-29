//
//  CustomTeacherCollection.swift
//  BookApp
//
//  Created by kien le van on 8/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CustomChanelCollection: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var callBackClickCell:((_ model: Chanel) -> Void)?
    
    var arrChanel = [Chanel]()

    @IBOutlet weak var chanelCollection: UICollectionView!
    @IBOutlet weak var name: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        chanelCollection.register(UINib(nibName: "ChanelCollectionCell", bundle: nil), forCellWithReuseIdentifier: "cell")
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
    
    // MARK: Collection Data Source
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return arrChanel.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = chanelCollection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChanelCollectionCell {
            cell.binData(chanel: arrChanel[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthSpace: CGFloat = 11
        widthSpace.adjustsSizeToRealIPhoneSize = 11
        let widthPerItem = (chanelCollection.frame.size.width - widthSpace * 2) / 3 - 1
        let hightPerItem = chanelCollection.frame.size.height
        
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
        var space: CGFloat = 11
        space.adjustsSizeToRealIPhoneSize = 11
        return space
    }
    
    // MARK: Collection Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callBackClickCell?(arrChanel[indexPath.row])
    }
    
    func reloadChanel(arrayChanel: [Chanel]) {
        if arrayChanel.count > 0 {
            arrChanel = arrayChanel
            chanelCollection.reloadData()
        }
    }
}
