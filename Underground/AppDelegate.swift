//
//  AppDelegate.swift
//  Underground
//
//  Created by Daniel Eden on 17/12/2019.
//  Copyright © 2019 Daniel Eden. All rights reserved.
//

import UIKit
import BackgroundTasks
import os.log

let fetcher = TransitLineViewModel()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Register background fetching
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "toys.lucid.underground.bgFetch", using: nil) { task in
            // swiftlint:disable force_cast
            self.performBackgroundDataRefresh(task as! BGAppRefreshTask)
        }

        return true
    }

    // MARK: Scheduler for future background fetching
    func scheduleDataFetcher() {
        print("Scheduling data fetcher")
        let request = BGAppRefreshTaskRequest(identifier: "toys.lucid.underground.bgFetch")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            os_log("Could not schedule data fetch", type: .error)
            print("\(error)")
        }
    }

    // MARK: Attempt background fetching
    func performBackgroundDataRefresh(_ task: BGAppRefreshTask) {
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        fetcher.load({(success) -> Void in
            print("Fetched in background with success: \(success)")
            task.setTaskCompleted(success: success)
        })

        scheduleDataFetcher()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
