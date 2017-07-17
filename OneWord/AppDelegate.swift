//
//  AppDelegate.swift
//  OneWord
//
//  Created by Songbai Yan on 15/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window!.rootViewController = UINavigationController.init(rootViewController: MainViewController());
        
        Fabric.with([Crashlytics.self])
        initAliyunService()
        setPushCategories()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.hasPrefix("EasyStudioOneWord://action=shareWord"){
            if let controller = self.window!.rootViewController?.childViewControllers.first(where: { (vc) -> Bool in
                return vc is MainViewController
            }) as? MainViewController{
                let word = getSharedWordFromTodayExtension()
                if controller.isViewLoaded{
                    controller.shareWord(word)
                }else{
                    //延迟执行，因为view可能还没有load
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        controller.shareWord(word)
                    })
                }
            }
        }
        return true
    }
    
    func setPushCategories() {
        let shareAction = UNNotificationAction(identifier: "share.action", title: "分享单词", options: [.foreground])
        
        let shareCategory = UNNotificationCategory(identifier: "easystudio.oneword.sharecategory", actions: [shareAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([shareCategory])
    }
    
    private func getSharedWordFromTodayExtension() -> Word?{
        let userDefaults = UserDefaults.init(suiteName: "group.oneWordSharedDefaults")
        guard let wordText = userDefaults?.string(forKey: "todayWordTextKey") else{
            return nil
        }
        guard let soundmark = userDefaults?.string(forKey: "todaySoundmarkKey") else{
            return nil
        }
        guard let partOfSpeech = userDefaults?.string(forKey: "todayPartOfSpeechKey") else{
            return nil
        }
        guard let paraphrase = userDefaults?.string(forKey: "todayParaphraseKey") else{
            return nil
        }
        return Word(text: wordText, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
    }
    
    private func initAliyunService(){
        let man = ALBBMANAnalytics.getInstance()
//        man?.turnOnDebug()
        man?.initWithAppKey("24230825", secretKey: "5ff601e164b633b955658810c7a1d0f9")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "OneWord")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

