//
//  SliderShow.swift
//  BookApp
//
//  Created by kien le van on 9/19/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class SliderShow: NSObject {
    
    private var _imageURL: String!
    private var _link: String?
    
    init(imageURL: String, link: String) {
        _imageURL = imageURL
        _link = link
    }
    var imageURL: String {
        return _imageURL
    }
    var linkBaner: String? {
        return _link
    }
}
