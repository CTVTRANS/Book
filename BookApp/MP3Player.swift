//
//  MP3Player.swift
//  TestAVplayer
//
//  Created by kien le van on 9/28/17.
//  Copyright © 2017 kien le van. All rights reserved.
//

import UIKit
import AVFoundation

class MP3Player: NSObject {
    private var asset: AVAsset?
    var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    var listPlay: [AnyObject] = []
    var currentAudio: AnyObject?
    var oldIndexListPlay: Int?
    
    static let shareIntanse = MP3Player()
    var didLoadAudio:((_ time: Float, _ timeSting: String) -> Void) = {_ in}
    
    func track(object: AnyObject, types: TypePlay) {
        if let book = object as? Book {
            playBook(audio: book, type: types)
            addBookListPlay(newBook: book)
        }
        
        if let lesson = object as? Lesson {
            playLesson(audio: lesson, type: types)
            addLeesonListPlay(newLesson: lesson)
        }
    }
    
    func playBook(audio: Book, type: TypePlay) {
        if type == TypePlay.offLine {
            currentAudio = audio
            player = AVPlayer(url: audio.audioOffline!)
            play()
            self.didLoadAudio(0.0, " ")
            return
        }
        if let book = currentAudio as? Book {
            if book.idBook == audio.idBook {
                return
            }
        }
        asset = AVAsset(url: URL(string:audio.audio)!)
        let keys: [String] = ["audio"]
        asset?.loadValuesAsynchronously(forKeys: keys) {
            DispatchQueue.main.async {
                self.playerItem = AVPlayerItem(asset: self.asset!)
                self.player = AVPlayer(playerItem: self.playerItem)
                self.didLoadAudio(self.getTotalTime(), self.getTotalTimeString())
                self.play()
                self.currentAudio = audio
            }
        }
    }
    
    func playLesson(audio: Lesson, type: TypePlay) {
        if type == TypePlay.offLine {
            currentAudio = audio
            player = AVPlayer(url: audio.audioOffline)
            play()
            self.didLoadAudio(0.0, " ")
            return
        }
        if let lesson = currentAudio as? Lesson {
            if lesson.idChap == audio.idChap {
                return
            }
        }
        asset = AVAsset(url: URL(string:audio.contentURL)!)
        let keys: [String] = ["audio"]
        asset?.loadValuesAsynchronously(forKeys: keys) {
            DispatchQueue.main.async {
                self.playerItem = AVPlayerItem(asset: self.asset!)
                self.player = AVPlayer(playerItem: self.playerItem)
                self.didLoadAudio(self.getTotalTime(), self.getTotalTimeString())
                self.play()
                self.currentAudio = audio
            }
        }
    }
    
    func addBookListPlay(newBook: Book) {
        for index in 0..<listPlay.count {
            if let book = listPlay[index] as? Book {
                if book.idBook == newBook.idBook {
                    listPlay.remove(at: index)
                    listPlay.append(newBook)
                    return
                }
            }
        }
        listPlay.append(newBook)
    }
    
    func addLeesonListPlay(newLesson: Lesson) {
        for index in 0..<listPlay.count {
            if let lesson = listPlay[index] as? Lesson {
                if lesson.idChap == newLesson.idChap {
                    listPlay.remove(at: index)
                    listPlay.append(newLesson)
                    return
                }
            }
        }
        listPlay.append(newLesson)
    }
    
    func getCurrentIndex() -> Int {
        for index in 0..<listPlay.count {
            if let book = listPlay[index] as? Book {
                if (currentAudio as? Book)?.idBook == book.idBook {
                    return index
                }
                
            }
            if let lesson = listPlay[index] as? Lesson {
                if (currentAudio as? Lesson)?.idChap == lesson.idChap {
                    return index
                }
            }
            continue
        }
        return 999999
    }
    
    func isNil() -> Bool {
        if playerItem == nil {
            return true
        }
        return false
    }
    
    func isPlaying() -> Bool {
        if player?.rate == 1 {
            return true
        } else {
            return false
        }
    }
    
    func play() {
        if player?.rate == 0 {
            player?.play()
        }
    }
    
    func pause() {
        if player?.rate == 1 {
            player?.pause()
        }
    }
    
    func getCurrentTime() -> (Float, String) {
        let current = playerItem?.currentTime()
        let currentTime = CMTimeGetSeconds(current!)
        let sec = Int(currentTime) % 60
        let min = Int(currentTime) / 60
        let timeString = String(format: "%0.2d:%0.2d", min, sec)
        let timeFloat = Float(currentTime)
        return (timeFloat, timeString)
    }
    
    func getTotalTimeString() -> String {
        let duration = playerItem?.asset.duration
        let totalTime = CMTimeGetSeconds(duration!)
        let sec = Int(totalTime) % 60
        let min = Int(totalTime) / 60
        let timeString = String(format: "%0.1d:%0.2d", min, sec)
        return timeString
    }
    
    func getTotalTime() -> Float {
        let duration = playerItem?.asset.duration
        let totalTime = CMTimeGetSeconds(duration!)
        let timeFloat = Float(totalTime)
        return timeFloat
    }
}
