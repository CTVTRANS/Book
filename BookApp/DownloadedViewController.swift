//
//  DownloadedViewController.swift
//  BookApp
//
//  Created by kien le van on 9/7/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DownloadedViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var table: UITableView!
    private var listChanelDownloaded: [Lesson] = []
    private var listBookDownloaded: [Book] = []
    
    private var firstShowDownload = true

    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        table.register(UINib.init(nibName: "HistoryWatchChanelCell", bundle: nil), forCellReuseIdentifier: "chanelCell")
        table.register(UINib.init(nibName: "BookDownloadCell", bundle: nil), forCellReuseIdentifier: "bookCell")
        getBookDownloaded()
        getLessonDownloaded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Downloaded".localized
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: Get Data
    
    func getBookDownloaded() {
        listBookDownloaded = Book.getBook()!
        table.reloadData()
    }
    
    func getLessonDownloaded() {
        listChanelDownloaded = Lesson.getLesson()!
        table.reloadData()
    }
    
    // MARK: Table Data Sources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segment.selectedSegmentIndex == 0 {
            return listBookDownloaded.count
        } else {
            return listChanelDownloaded.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segment.selectedSegmentIndex == 0 {
            return bookCell(indexPath: indexPath)
        }
        return self.chanelCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: Table Delegate
    
    func bookCell(indexPath: IndexPath) -> BookDownloadCell {
        let bookCell = table.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as? BookDownloadCell
        let book = listBookDownloaded[indexPath.row]
        bookCell?.binData(book: book)
        bookCell?.callBackButton = { [weak self] (action: String) in
            switch action {
            case "playBook":
                self?.playBook(book: book, index: indexPath.row)
                break
            case "removeBook":
                self?.pressRemoveBook(book: book)
                self?.listBookDownloaded.remove(at: indexPath.row)
                self?.table.reloadData()
                break
            default:
                break
            }
        }
        return bookCell!
    }
    
    func chanelCell(indexPath: IndexPath) -> HistoryWatchChanelCell {
        let chaneCell = table.dequeueReusableCell(withIdentifier: "chanelCell", for: indexPath) as? HistoryWatchChanelCell
        let lesson = listChanelDownloaded[indexPath.row]
        chaneCell?.binData(lesson: lesson)
        chaneCell?.callBackButton = { [weak self] (action: String) in
            switch action {
            case "playChanel":
                self?.play(lesson: lesson, index: indexPath.row)
                break
            case "removeChanel":
                self?.pressRemoveLesson(lesson: lesson)
                self?.listChanelDownloaded.remove(at: indexPath.row)
                self?.table.reloadData()
                break
            default:
                break
            }
        }
        return chaneCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Play AUudio
    
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
        mp3.track(object: lesson, types: TypePlay.offLine)
        table.reloadData()
        mp3.didLoadAudio = { [weak self] _, _ in
            self?.table.reloadData()
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
        mp3.track(object: book, types: TypePlay.offLine)
        table.reloadData()
        mp3.didLoadAudio = { [weak self] _, _ in
            self?.table.reloadData()
        }
    }
    
    func pressRemoveLesson(lesson: Lesson) {
        var listLesson: [Lesson] = Lesson.getLesson()!
        if listLesson.count > 0 {
            for index in 0..<listLesson.count where listLesson[index].idChap == lesson.idChap {
                listLesson.remove(at: index)
                break
            }
            Lesson.saveLesson(lesson: listLesson)
        }
    }
    
    func pressRemoveBook(book: Book) {
        var listBook: [Book] = Book.getBook()!
        for index in 0..<listBook.count where listBook[index].idBook == book.idBook {
            listBook.remove(at: index)
            break
        }
        Book.saveBook(myBook: listBook)
    }
    
    @IBAction func pressedSegment(_ sender: Any) {
        table.reloadData()
    }
}
