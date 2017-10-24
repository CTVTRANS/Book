//
//  NotificationVideoViewController.swift
//  BookApp
//
//  Created by kien le van on 9/4/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HistoryPlayAudioController: BaseViewController {

    @IBOutlet weak var table: UITableView!
    
    lazy var mp3 = MP3Player.shareIntanse
    var listHistory: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        listHistory = mp3.listPlay as [AnyObject]
        mp3.oldIndexListPlay = mp3.getCurrentIndex()
    }
    
    // MARK: Play Audio
    
    func playAudio(object: AnyObject, current: Int) {
        if let book = object as? Book {
            playBook(book: book, index: current)
        }
        
        if let lesson = object as? Lesson {
            playLesson(lesson: lesson, index: current)
        }
    }
    
    // MARK: Play Audio Book
    
    func playBook(book: Book, index: Int) {
        if let current = mp3.currentAudio as? Book {
            if book.idBook == current.idBook && mp3.isPlaying() {
                mp3.pause()
                mp3.oldIndexListPlay = nil
                table.reloadData()
                return
            } else if book.idBook == current.idBook && !mp3.isPlaying() {
                mp3.play()
                mp3.oldIndexListPlay = index
                table.reloadData()
                return
            }
        }
        mp3.oldIndexListPlay = index
        mp3.track(object: book, types: TypePlay.onLine)
        table.reloadData()
    }
    
    // MARK: Play Audio of Lesson
    
    func playLesson(lesson: Lesson, index: Int) {
        if let current = mp3.currentAudio as? Lesson {
            if lesson.idChap == current.idChap && mp3.isPlaying() {
                mp3.pause()
                mp3.oldIndexListPlay = nil
                table.reloadData()
                return
            } else if lesson.idChap == current.idChap && !mp3.isPlaying() {
                mp3.play()
                mp3.oldIndexListPlay = index
                table.reloadData()
                return
            }
        }
        mp3.oldIndexListPlay = index
        mp3.track(object: lesson, types: TypePlay.onLine)
        table.reloadData()
    }
    
    // MARK: Button Control
    
    @IBAction func pressedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressedDeleteAllMessage(_ sender: Any) {
        if mp3.isPlaying() {
            mp3.pause()
        }
        mp3.listPlay.removeAll()
        listHistory.removeAll()
        table.reloadData()
    }
}

extension HistoryPlayAudioController: UITableViewDataSource, UITableViewDelegate {
    // MARK: Table Data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistory.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Table Delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "HistoryPlayAudioCell", for: indexPath) as? HistoryPlayAudioCell
        let row = listHistory.count - 1 - indexPath.row
        cell?.bindData(historyObject: listHistory[row])
        if mp3.oldIndexListPlay == row && mp3.isPlaying() {
            cell?.imagePlay.image = #imageLiteral(resourceName: "pauseList")
        } else {
            cell?.imagePlay.image = #imageLiteral(resourceName: "playList")
        }
        
        cell?.callBackDownload = { oject in
            if let book = oject as? Book {
                let download = DownloadAudioController()
                download.downloadBook(book: book)
            }
            if let lesson = oject as? Lesson {
                let download = DownloadAudioController()
                let arr = [lesson]
                download.downloadArrayLeeson(arrayLesson: arr, completionHandler: { (number) in
                    _ = UIAlertController.initAler(title: "", message: "Download \(number) lesson success", inViewController: self)
                })
            }
        }
        cell?.callBackPlayAudio = { [weak self] object in
            self?.playAudio(object: object, current: row)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let index = mp3.listPlay.count - 1 - indexPath.row
            if index != mp3.oldIndexListPlay || (index == mp3.oldIndexListPlay && !mp3.isPlaying()) {
                mp3.listPlay.remove(at: index)
                listHistory.remove(at: index)
                //                tableView.reloadData()
                table.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
