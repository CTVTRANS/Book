//
//  HistoryWatchChanelViewController.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class HistoryWatchChanelViewController: BaseViewController {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    var listHistoryLesson: [Lesson] = []
    var listHistoryBook: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivity(inView: self.view)
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        table.register(UINib.init(nibName: "HistoryWatchChanelCell", bundle: nil), forCellReuseIdentifier: "cell")
        table.register(UINib.init(nibName: "HistoryListenBookell", bundle: nil), forCellReuseIdentifier: "bookCell")
        getHistoryLesson()
        getHistoryBook()
        mp3.limitTime = { [weak self] in
            self?.table.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "播放记录"
    }
    
    func getHistoryLesson() {
        let getData = GetHistoryListenTask(memberID: (memberInstance?.idMember)!, token: tokenInstance!, type: ScreenShow.chanel.rawValue)
        requestWithTask(task: getData, success: { (data) in
            if let arrayLesson = data as? [Lesson] {
                self.listHistoryLesson = arrayLesson
                self.table.reloadData()
            }
        }) { (_) in
            self.stopActivityIndicator()
        }
    }
    
    func getHistoryBook() {
        let getData = GetHistoryListenTask(memberID: (memberInstance?.idMember)!, token: tokenInstance!, type: ScreenShow.book.rawValue)
        requestWithTask(task: getData, success: { (data) in
            self.stopActivityIndicator()
            if let arrayBook = data as? [Book] {
                self.listHistoryBook = arrayBook
                self.table.reloadData()
            }
        }) { (_) in
            self.stopActivityIndicator()
        }
    }
    
    func playBook(book: Book, index: Int) {
        if let current = mp3.currentAudio as? Book {
            if  book.idBook == current.idBook && mp3.isPlaying() {
                mp3.pause()
                table.reloadData()
                return
            } else if book.idBook == current.idBook && !mp3.isPlaying() {
                mp3.play()
                table.reloadData()
                return
            }
        }
        mp3.track(object: book, types: TypePlay.onLine)
        table.reloadData()
        mp3.didLoadAudio = { [weak self] _, _ in
            self?.table.reloadData()
        }
    }

    func play(lesson: Lesson, index: Int) {
        if let current = mp3.currentAudio as? Lesson {
            if lesson.idChap == current.idChap && mp3.isPlaying() {
                mp3.pause()
                table.reloadData()
                return
            } else if lesson.idChap == current.idChap && !mp3.isPlaying() {
                mp3.play()
                table.reloadData()
                return
            }
        }
        mp3.track(object: lesson, types: TypePlay.onLine)
        mp3.didLoadAudio = { [weak self] _, _ in
            self?.table.reloadData()
        }
    }
    
    func removeAudio(type: Int, objecID: Int) {
        let removeAudioTask = RemoveHistoryAudioTask(memberID: (memberInstance?.idMember)!,
                                                   token: tokenInstance!,
                                                   type: type,
                                                   idObject: objecID)
        requestWithTask(task: removeAudioTask, success: { (_) in
            
        }) { (_) in
            
        }
    }
    
    @IBAction func pressedSegment(_ sender: Any) {
        table.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HistoryWatchChanelViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return listHistoryBook.count
        } else {
            return listHistoryLesson.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segment.selectedSegmentIndex == 0 {
            return bookCell(indexPath: indexPath)
        } else {
            return lessonCell(indexPath: indexPath)
        }
    }
    
    func lessonCell(indexPath: IndexPath) -> HistoryWatchChanelCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryWatchChanelCell
            let lesson = listHistoryLesson[indexPath.row]
            cell?.binData(lesson: lesson)
            cell?.timeUpLesson.text = lesson.timeRead.components(separatedBy: " ")[0]
            cell?.callBackButton = { [weak self] (action: String) in
                switch action {
                case "playChanel":
                    self?.play(lesson: lesson, index: indexPath.row)
                    break
                case "removeChanel":
                    self?.removeAudio(type: ScreenShow.chanel.rawValue, objecID: lesson.idChap)
                    self?.listHistoryLesson.remove(at: indexPath.row)
                    self?.table.reloadData()
                    break
                default:
                    break
                }
            }
        return cell!
    }
    
    func bookCell(indexPath: IndexPath) -> HistoryListenBookell {
        let bookCell = table.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? HistoryListenBookell
        let book = listHistoryBook[indexPath.row]
        bookCell?.binData(book: book)
        bookCell?.callBackButton = { [weak self] (action: String) in
            switch action {
            case "play":
                self?.playBook(book: book, index: indexPath.row)
                break
            case "remove":
                self?.removeAudio(type: ScreenShow.book.rawValue, objecID: book.idBook)
                self?.listHistoryBook.remove(at: indexPath.row)
                self?.table.reloadData()
            default:
                break
            }
        }
        return bookCell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
}
