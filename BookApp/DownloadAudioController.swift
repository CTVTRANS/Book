//
//  DownloadAudioController.swift
//  BookApp
//
//  Created by kien le van on 10/2/17.
//  Copyright © 2017 Le Cong. All rights reserved.
//

import UIKit

class DownloadAudioController: BaseViewController {

    private var downloadImagelesonSuccess = true
    private var downloadAudioLessonSuccess = false
    private var downloadImageBookSuccess = false
    private var downloadAudioBookSucess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func postNotificationDownloadSuccess() {
        NotificationCenter.default.post(name: Notification.Name("downloadSuccess"), object: nil)
    }
    
    func postNotificationStartDownload() {
         NotificationCenter.default.post(name: Notification.Name("downloadStart"), object: nil)
    }
    
    // MARK: Download leeson
    
    func downloadArrayLeeson(arrayLesson: [Lesson], completionHandler: @escaping (Int) -> Void) {
        postNotificationStartDownload()
        let group = DispatchGroup()
        var downloaded = 0
        for leson in arrayLesson {
            group.enter()
            self.downloadSingleLesson(lesson: leson) { error in
                if !error {
                    downloaded += 1
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
             completionHandler(downloaded)
             self.postNotificationDownloadSuccess()
        }
    }
    
    private func downloadSingleLesson(lesson: Lesson, completionHandler: @escaping (Bool) -> Void) {
        self.downloadImagelesonSuccess = false
        self.downloadAudioLessonSuccess = false
        let downloadImageLesson = DownloadTask(path: lesson.imageChapURL)
        downloadFileSuccess(task: downloadImageLesson, success: { (data) in
            if let imageOffline = data as? URL {
                lesson.imageOffline = imageOffline
                self.downloadImagelesonSuccess = true
                if self.downloadImagelesonSuccess && self.downloadAudioLessonSuccess {
                    self.setListLesson(chap: lesson)
                    completionHandler(false)
                }
            }
        }) { (_) in
            completionHandler(true)
        }

        let downloadLesson = DownloadTask(path: lesson.contentURL)
        downloadFileSuccess(task: downloadLesson, success: { (data) in
            if let audioOffline = data as? URL {
                lesson.audioOffline = audioOffline
                self.downloadAudioLessonSuccess = true
                if self.downloadImagelesonSuccess && self.downloadAudioLessonSuccess {
                    self.setListLesson(chap: lesson)
                    completionHandler(false)
                }
            }
        }) { (_) in
            completionHandler(true)
        }
    }
    
    // MARK: Down Load Book
    
    func downloadBook(book: Book) {
        postNotificationStartDownload()
        let downloadImage = DownloadTask(path: book.imageURL)
        downloadFileSuccess(task: downloadImage, success: { (data) in
            if let imageOflline = data as? URL {
                self.downloadImageBookSuccess = true
                book.imageOffline = imageOflline
                if self.downloadAudioBookSucess && self.downloadImageBookSuccess {
                    self.saveAudio(book: book)
                    self.postNotificationDownloadSuccess()
                }
            }
        }) { (_) in
        }
        let downloadAudio = DownloadTask(path: book.audio)
        downloadFileSuccess(task: downloadAudio, success: { (data) in
            if let audioOffline = data as? URL {
                self.downloadAudioBookSucess = true
                book.audioOffline = audioOffline
                if self.downloadAudioBookSucess && self.downloadImageBookSuccess {
                    self.saveAudio(book: book)
                    self.postNotificationDownloadSuccess()
                }
            }
        }) { (_) in
        }
    }
    
    // MARK: Save Book
    
    func saveAudio(book: Book) {
        var listBookDownaloaed = Book.getBook()
        for singleBook in listBookDownaloaed! where singleBook.idBook == book.idBook {
            return
        }
        listBookDownaloaed?.append(book)
        Book.saveBook(myBook: listBookDownaloaed!)
    }

    // MARK: Save lesson
    
    func setListLesson(chap: Lesson) {
        var listLesson = Lesson.getLesson()
        for singleLesson in listLesson! where chap.idChap == singleLesson.idChap {
            return
        }
        listLesson?.append(chap)
        Lesson.saveLesson(lesson: listLesson!)
        print("sucess")
    }
}
