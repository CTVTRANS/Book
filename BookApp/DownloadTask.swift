//
//  DownloadTask.swift
//  BookApp
//
//  Created by kien le van on 9/20/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import LCNetwork

class DownloadTask: BaseTaskNetwork {

    private var pathFile: String = ""
    
    init(path: String) {
        pathFile = path
    }
    
//    override func path() -> String! {
//        return pathFile
//    }
    
    override func pathFileDownload() -> String! {
        return pathFile
    }
    
    override func method() -> String! {
        return GET
    }
    
    override func data(withResponse response: Any!) -> Any! {
        return response
    }
}
