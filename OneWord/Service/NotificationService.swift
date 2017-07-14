//
//  NotificationService.swift
//  OneWord
//
//  Created by Songbai Yan on 14/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService {
    
    func createNotifications(frequency:Int, days:Int){
        // frequency是一天几次
        // days是重复的天数
        let dateComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        var date = Calendar.current.dateComponents(dateComponents, from: Date())
        date.hour = 8
        date.minute = 0
        date.second = 0
    }
    
    func getDateComponents(for days:Int, frequency:Int) -> [DateComponents]{
        var results = [DateComponents]()
        for i in 0...days{
            let dateComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
            var date = Calendar.current.dateComponents(dateComponents, from: Date())
            date.day = date.day! + i
            date.hour = 8
            date.minute = 0
            date.second = date.second! + 5
            results.append(date)
        }
        
        return results
    }
    
    func createNotification(word:Word, dateComponents:DateComponents) {
        let content = UNMutableNotificationContent()
//        TODO: add word image
//        content.attachments
        content.title = word.text
        content.subtitle = word.soundmark
        content.body = "\(word.partOfSpeech) \(word.paraphrase)"
        content.userInfo = ["word": word.text, "soundmark":word.soundmark, "partOfSpeech":word.partOfSpeech, "paraphrase": word.paraphrase]
        
        let dateComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
        var date = Calendar.current.dateComponents(dateComponents, from: Date())
        date.second = date.second! + 5
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
        
        // 创建发送通知请求的标识符
        let identifier = "message.wordpush"
        
        addNotification(identifier, content, trigger)
    }
    
    // 用于创建发送通知的请求, 并将其添加到通知中心
    func addNotification(_ identifier: String, _ content: UNMutableNotificationContent, _ trigger: UNNotificationTrigger?) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("error adding notification: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
