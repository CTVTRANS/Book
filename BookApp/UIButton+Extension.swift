//
//  UIButton+Extension.swift
//  BookApp
//
//  Created by le kien on 12/14/17.
//

import Foundation

extension UIButton {
    @IBInspectable var useLocalized: Bool {
        set {
            if newValue {
                let newTitle = titleLabel?.text?.localized
                setTitle(newTitle, for: .normal)
            }
        }
        get {
            return true
        }
    }
}
