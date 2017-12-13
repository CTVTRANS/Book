//
//  String+Extension.swift
//  BookApp
//
//  Created by le kien on 12/13/17.
//

import Foundation
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
