//
//  HisToryWatchChanelCell.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class HistoryWatchChanelCell: UITableViewCell {

    @IBOutlet weak var timeUpLesson: UILabel!
    @IBOutlet weak var descriptionLesson: UILabel!
    @IBOutlet weak var nameLesson: UILabel!
    @IBOutlet weak var nameChanel: UILabel!
    @IBOutlet weak var numberChap: UILabel!
    @IBOutlet weak var removeChanelButton: UIButton!
    @IBOutlet weak var playChanelButton: UIButton!
    @IBOutlet weak var heightOfAvatar: NSLayoutConstraint!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var imagePlay: UIImageView!
    
    var callBackButton:((_ action: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playChanelButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        removeChanelButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        avatar.layer.cornerRadius = heightOfAvatar.constant / 2
    }
    
    func binData(lesson: Lesson) {
        let date = lesson.timeUp.components(separatedBy: " ")
        timeUpLesson.text = date[0]
        descriptionLesson.text = lesson.descriptionChap
        nameLesson.text = lesson.name
        numberChap.text = String(lesson.chapter)
        nameChanel.text = lesson.chanelOwner
        avatar.sd_setImage(with: URL(string: lesson.imageChapURL), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        if let chap = MP3Player.shareIntanse.currentAudio as? Lesson {
            if chap.idChap == lesson.idChap && MP3Player.shareIntanse.isPlaying() {
                imagePlay.image = #imageLiteral(resourceName: "audio_pause")
            } else {
                imagePlay.image = #imageLiteral(resourceName: "audio_play")
            }
        } else {
             imagePlay.image = #imageLiteral(resourceName: "audio_play")
        }
        if let filePath = lesson.imageOffline?.path {
            if FileManager.default.fileExists(atPath: filePath) {
                do {
                    let data = try? Data(contentsOf: lesson.imageOffline!)
                    avatar?.image = UIImage(data: data!)
                }
            }
            return
        }
    }
    
    @IBAction func pressedPlayChanelButton(_ sender: Any) {
        self.callBackButton!("playChanel")
    }
    
    @IBAction func pressedRemoveChanelButton(_ sender: Any) {
        self.callBackButton!("removeChanel")
    }
}
