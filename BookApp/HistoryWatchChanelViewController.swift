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

class HistoryWatchChanelViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var listHistoryLesson: [Lesson] = []
    lazy var mp3 = MP3Player.shareIntanse
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.tableFooterView = UIView()
        table.estimatedRowHeight = 140
        table.register(UINib.init(nibName: "HistoryWatchChanelCell", bundle: nil), forCellReuseIdentifier: "cell")
        listHistoryLesson = Constants.sharedInstance.historyViewChanelLesson
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "播放記錄"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listHistoryLesson.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? HistoryWatchChanelCell {
            let lesson = listHistoryLesson[indexPath.row]
            cell.binData(lesson: lesson)
            cell.callBackButton = { [weak self] (action: String) in
                switch action {
                case "playChanel":
                    self?.play(lesson: lesson, index: indexPath.row)
                    break
                case "removeChanel":
                    Constants.sharedInstance.historyViewChanelLesson.remove(at: indexPath.row)
                    self?.listHistoryLesson = Constants.sharedInstance.historyViewChanelLesson
                    self?.table.reloadData()
                    break
                default:
                    break
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
