//
//  UILabel+Extension.swift
//  BookApp
//
//  Created by le kien on 12/14/17.
//

import Foundation

extension UILabel {
    @IBInspectable var useLocalized: Bool {
        set {
            if newValue {
                text = text?.localized
            }
        }
        get {
            return true
        }
    }
}
