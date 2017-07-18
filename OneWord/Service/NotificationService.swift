//
//  NotificationService.swift
//  OneWord
//
//  Created by Songbai Yan on 14/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class NotificationService {
    private(set) var frequency:Int!
    
    init() {
        frequency = UserDefaults.standard.integer(forKey: "pushWordFrequency")
    }
    
    func updateFrequency(frequency:Int){
        self.frequency = frequency
        UserDefaults.standard.set(frequency, forKey: "pushWordFrequency")
        UserDefaults.standard.synchronize()
    }
    
    func createNotifications(for days:Int, by frequency:Int){
        // frequency是一天几次
        // days是重复的天数
        let service = MainService()
        let currentDate = Calendar.current.dateComponents(in: .current, from: Date())
        let totalDateComponents = getDateComponents(from: currentDate, by: frequency)
        for date in totalDateComponents{
            let word = service.getRandomWord()
            createNotification(word: word, dateComponents: date)
        }
    }
    
    func resetNotifications(by frequency: Int){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requestList) in
            print("\(Date()) -- 还有\(requestList.count)个通知请求未经展示。")
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            if frequency > 0{
                self.createNotifications(for: 7, by: frequency)
            }
        }
    }
    
    func appendNotificationsIfNeeded(by frequency: Int){
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requestList) in
            print("\(Date()) -- 还有\(requestList.count)个通知请求未经展示。")
            
            // 如果还未推送的小于2天，就添加新的推送
            if requestList.count/frequency < 2{
                if let lastRequest = requestList.last{
                    if let trigger = lastRequest.trigger as? UNCalendarNotificationTrigger{
                        let dateComponents = trigger.dateComponents
                        let totalDateComponents = self.getDateComponents(from: dateComponents, by: frequency)
                        let service = MainService()
                        for date in totalDateComponents{
                            let word = service.getRandomWord()
                            self.createNotification(word: word, dateComponents: date)
                        }
                    }
                }
            }
        }
    }
    
    private func getDateComponents(from lastComponents:DateComponents, by frequency:Int) -> [DateComponents]{
        var results = [DateComponents]()
        for i in 1...7{
            let hours = getHours(by: frequency)
            for hour in hours{
                let dayMonthYear = getDayMonthYear(day: lastComponents.day! + i, month: lastComponents.month!, year: lastComponents.year!)
                let year = dayMonthYear.2
                let month = dayMonthYear.1
                let day = dayMonthYear.0
                let hour = hour
                let minute = 0
                let second = 0
                let newComponents = DateComponents(calendar: Calendar.current, timeZone: .current, year: year, month: month, day: day, hour: hour, minute: minute, second: second)
                results.append(newComponents)
            }
        }
        return results
    }
    
    private func getDayMonthYear(day:Int, month:Int, year:Int) -> (Int, Int, Int){
        var resultDay = day
        var resultMonth = month
        var resultYear = year
        let lastDay = getLastDay()
        if day > lastDay{
            resultDay = lastDay - day
            resultMonth += 1
            if resultMonth > 12{
                resultMonth = 1
                resultYear += 1
            }
        }
        return (resultDay, resultMonth, resultYear)
    }
    
    private func getLastDay() -> Int{
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let currentDateString = dateFormatter.string(from: currentDate)
        let dateComponents = currentDateString.components(separatedBy: "/")
        let year = Int(dateComponents[0])
        let month = Int(dateComponents[1])
        let nextMonthDate = dateFormatter.date(from:"\(year!)-\(month!+1)-01")
        let lastDayDate = Date(timeInterval:(24*60*60)*(-1), since: nextMonthDate!)
        let lastDateString = dateFormatter.string(from: lastDayDate)
        let result = lastDateString.components(separatedBy: "/")
        let day = Int(result[2])
        return day!
    }
    
    private func getHours(by frequency:Int) -> [Int]{
        switch frequency {
        case 1:
            return [11]
        case 3:
            return [11, 15, 21]
        case 5:
            return [9, 11, 15, 18, 21]
        case 8:
            return [8, 10, 12, 14, 16, 18, 20, 22]
        case 12:
            return [8, 9, 10, 11, 12, 15, 16, 17, 18, 19, 20, 21]
        case 16:
            return [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
        default:
            return []
        }
    }
    
    private func createNotification(word:Word, dateComponents:DateComponents) {
        let content = UNMutableNotificationContent()
        content.attachments = getImageNotificationAttachment(from: word)
        content.title = word.text
        content.subtitle = word.soundmark
        content.body = word.partOfSpeech + " " + word.paraphrase
        content.categoryIdentifier = "easystudio.oneword.sharecategory"
        content.userInfo = ["word": word.text, "soundmark":word.soundmark, "partOfSpeech":word.partOfSpeech, "paraphrase": word.paraphrase]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // 创建发送通知请求的标识符
        let identifier = "easystudio.oneword.wordpush." + word.text
        
        addNotification(identifier, content, trigger)
    }
    
    private func getImageNotificationAttachment(from word: Word) -> [UNNotificationAttachment] {
        let extendedIdentifier = "word.image.jpg"
        
        if let imageURL = getImageUrl(by: word){
            do {
                let attachement = try UNNotificationAttachment(identifier: extendedIdentifier, url: imageURL, options: nil)
                return [attachement]
            }
            catch let error{
                print("attachement加载失败: " + error.localizedDescription)
            }
        }
        
        return []
    }
    
    private func getImageUrl(by word: Word) -> URL?{
        let image = ImageCreator.createWordImage(for: word)
        let imageUrl = ImageCreator.saveImageToFile(with: word.text, image: image)
        return imageUrl
    }
    
    // 用于创建发送通知的请求, 并将其添加到通知中心
    private func addNotification(_ identifier: String, _ content: UNMutableNotificationContent, _ trigger: UNNotificationTrigger?) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("error adding notification: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}
