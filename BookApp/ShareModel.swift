//
//  ShareModel.swift
//  BookApp
//
//  Created by kien le van on 10/18/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ShareModel: NSObject {
    
    var nameShare: String = ""
    var detailShare: String = ""
    var linkDownApp: String = appDownload
    
    static let shareIntance = ShareModel()
    private override init() {}
}
