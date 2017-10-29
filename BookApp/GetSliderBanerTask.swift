//
//  GetSliderBanerTask.swift
//  BookApp
//
//  Created by kien le van on 9/19/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class GetSliderBanerTask: BaseTaskNetwork {

    private var _type: Int
    
    init(typeSlider: Int) {
        _type = typeSlider
    }
    
    override func path() -> String! {
        return getSlidershowURL
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func parameters() -> [AnyHashable : Any]! {
        return ["screen_show": _type]
    }
    
    override func data(withResponse response: Any!) -> Any! {
        var sliderShow: [SliderShow] = []
        if let object = response as? [[String: Any]] {
            for dictionary in object {
                let iamgeBanerURL = dictionary["image"] as? String ?? " "
                let linBaner = dictionary["link"] as? String ?? " "
                let baner = SliderShow(imageURL: iamgeBanerURL,
                                       link: linBaner)
                sliderShow.append(baner)
            }
        }
        return sliderShow
    }
}
