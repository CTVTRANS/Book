//
//  VideoNotificationCell.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class HistoryPlayAudioCell: UITableViewCell {

    @IBOutlet weak var imagePlay: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descriptionAudio: UILabel!
    var object: AnyObject?
    var callBackDownload:((_ book: AnyObject) -> Void) = {_ in }
    var callBackPlayAudio:((_ book: AnyObject) -> Void) = {_ in}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func bindData(historyObject: AnyObject) {
        if let book = historyObject as? Book {
            object = book
            name.text = book.name
            let arrayString = book.descriptionBook.components(separatedBy: "</p>")
            if let firstString = arrayString.first {
                if firstString.characters.count > 10 {
                    let index = firstString.index(firstString.startIndex, offsetBy: 3)
                    descriptionAudio.text = firstString.substring(from: index)
                }
                descriptionAudio.text = "BookApp"
            }
            return
        }
        
        if let lesson = historyObject as? Lesson {
            object = lesson
            name.text = lesson.name
            descriptionAudio.text = lesson.descriptionChap
        }
    }
    
    @IBAction func pressedplayAudio(_ sender: Any) {
        self.callBackPlayAudio(object!)
    }
    
    @IBAction func pressedDownload(_ sender: Any) {
        self.callBackDownload(object!)
    }
}
