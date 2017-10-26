//
//  HistoryListenBookell.swift
//  BookApp
//
//  Created by kien le van on 10/26/17.
//
//

import UIKit

class HistoryListenBookell: UITableViewCell {

    @IBOutlet weak var imagePlay: UIImageView!
    @IBOutlet weak var imageBook: UIImageView!
    @IBOutlet weak var typeBook: UILabel!
    @IBOutlet weak var nameBook: UILabel!
    @IBOutlet weak var detailBook: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    
    var callBackButton:((_ action: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
        removeButton.layer.borderColor = UIColor.rgb(255, 102, 0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func binData(book: Book) {
        imageBook.sd_setImage(with: URL(string:book.imageURL))
        typeBook.text = book.typeName
        nameBook.text = book.name
        let arrayString = book.descriptionBook.components(separatedBy: "</p>")
        if let firstString = arrayString.first {
            if firstString.characters.count > 10 {
                let index = firstString.index(firstString.startIndex, offsetBy: 3)
                detailBook.text = firstString.substring(from: index)
            }
            detailBook.text = ""
        }
        if let currentBok = MP3Player.shareIntanse.currentAudio as? Book {
            if currentBok.idBook == book.idBook && MP3Player.shareIntanse.isPlaying() {
                imagePlay.image = #imageLiteral(resourceName: "audio_pause")
            } else {
                imagePlay.image = #imageLiteral(resourceName: "audio_play")
            }
        } else {
            imagePlay.image = #imageLiteral(resourceName: "audio_play")
        }
        time.text = book.timeUpBook.components(separatedBy: " ")[0]
    }
    
    @IBAction func pressedPlay(_ sender: Any) {
        self.callBackButton!("play")
    }
    @IBAction func pressedRemove(_ sender: Any) {
        self.callBackButton!("remove")
    }
}
