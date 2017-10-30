//
//  AppDelegate.swift
//  TimelinesSwift
//
//  Created by Twitter  on 5/26/15.
//  Copyright (c) 2015 Twitter. All rights reserved.
//

import UIKit
import TwitterKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var consumer_key: String = ""
    var consumer_secret: String = ""
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // grab app keys from Twitter.plist in app bundle
        // avoids having to have that file in source control...
        if let url = Bundle.main.url(forResource:"Twitter", withExtension: "plist") {
            do {
                let data = try Data(contentsOf:url)
                let swiftDictionary = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any]
                consumer_key = swiftDictionary["consumer_key"] as! String
                consumer_secret = swiftDictionary["consumer_secret"] as! String
            } catch {
                print(error)
            }
        }

        Twitter.sharedInstance().start(withConsumerKey:consumer_key, consumerSecret:consumer_secret)
        let store = Twitter.sharedInstance().sessionStore
        
        if store.existingUserSessions().count == 0 {
            
            Twitter.sharedInstance().logIn(completion: { (session, error) in
                if let sess = session {
                    print("signed in as \(sess.userName)");
                } else {
                    print("error: \(error!.localizedDescription)");
                }
            })
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if Twitter.sharedInstance().application(app, open: url, options: options) {
            return true
        }
        // Your other open URL handlers follow […]
        return false
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate.
        // Save data if appropriate. See also applicationDidEnterBackground:.
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
        let container = NSPersistentContainer(name: "Smash")
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
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                //  although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

