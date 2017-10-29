//
//  FooterLoadMoreReusableView.swift
//  BookApp
//
//  Created by kien le van on 9/26/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class FooterLoadMoreReusableView: UICollectionReusableView {
        
    @IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
    
    var isAnimatingFinal: Bool = false
    var currentTransform: CGAffineTransform?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareInitialAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setTransform(inTransform: CGAffineTransform, scaleFactor: CGFloat) {
        if isAnimatingFinal {
            return
        }
        currentTransform = inTransform
        refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
    }
    
    // MARK: Reset The Animation
    
    func prepareInitialAnimation() {
        self.isAnimatingFinal = false
        refreshControlIndicator?.stopAnimating()
        refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
    }
    
    func startAnimate() {
        isAnimatingFinal = true
        refreshControlIndicator?.startAnimating()
    }
    
    func stopAnimate() {
        isAnimatingFinal = false
        refreshControlIndicator?.stopAnimating()
    }
    
    // MARK: Final Animation To Display Loading
    
    func animateFinal() {
        if isAnimatingFinal {
            return
        }
        isAnimatingFinal = true
        UIView.animate(withDuration: 0.2) {
            self.refreshControlIndicator?.transform = CGAffineTransform.identity
        }
    }
}
