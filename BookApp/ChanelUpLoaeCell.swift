//
//  TeacherUpLoaeCell.swift
//  BookApp
//
//  Created by kien le van on 8/15/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class ChanelUpLoaeCell: UITableViewCell {

    @IBOutlet weak var timeUp: UILabel!
    @IBOutlet weak var descriptionChapter: UILabel!
    @IBOutlet weak var nameChapter: UILabel!
    @IBOutlet weak var chapter: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var heightOfAvatar: NSLayoutConstraint!
    @IBOutlet weak var imagePlay: UIImageView!
    
    var callBackButton:((_ typeButton: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = heightOfAvatar.constant / 2
    }

    func binData(chap: Lesson) {
        let date = chap.timeUp.components(separatedBy: " ")
        timeUp.text = date[0]
        descriptionChapter.text = chap.descriptionChap
        nameChapter.text = chap.name
        chapter.text = String(chap.chapter)
        avatar.sd_setImage(with: URL(string: chap.imageChapURL), placeholderImage: #imageLiteral(resourceName: "userPlaceHolder"))
        if let lesson = MP3Player.shareIntanse.currentAudio as? Lesson {
            if chap.idChap == lesson.idChap && MP3Player.shareIntanse.isPlaying() {
                imagePlay.image = #imageLiteral(resourceName: "audio_pause")
                return
            }
        }
        imagePlay.image = #imageLiteral(resourceName: "audio_play")

    }

    @IBAction func pressedDowloadLesson(_ sender: Any) {
        self.callBackButton!("download")
    }
    @IBAction func pressedPlayButton(_ sender: Any) {
        self.callBackButton!("play")
    }
}
