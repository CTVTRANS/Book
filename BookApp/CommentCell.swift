//
//  CommentCell.swift
//  BookApp
//
//  Created by kien le van on 8/28/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var imageLike: UIImageView!
    @IBOutlet weak var numberLike: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    var pressLikeComment = {}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func binData(commentObject: Comment) {
        name.text = commentObject.userComment.name
        avatar.sd_setImage(with: URL(string:commentObject.userComment.avata), placeholderImage: #imageLiteral(resourceName: "place_holder"))
        let timeComment: String = commentObject.timeComment
        let dateComment = timeComment.components(separatedBy: " ")
        let date = dateComment[0].components(separatedBy: "-")
        time.text = date[1] + "." + date[2]
        content.text = commentObject.contentComment
        numberLike.text = String(commentObject.numberLikeComment)
        imageLike.image = commentObject.status == 1 ? #imageLiteral(resourceName: "ic_bottom_liked") : #imageLiteral(resourceName: "ic_bottom_like")
    }

    @IBAction func pressedLike(_ sender: Any) {
        self.pressLikeComment()
    }
}
