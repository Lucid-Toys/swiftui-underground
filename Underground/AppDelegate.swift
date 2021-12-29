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

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // MARK: Register background fetching
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "toys.lucid.underground.bgFetch", using: nil) { task in
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
      let fetcher = TransitLineViewModel()
      
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

      Task {
        await fetcher.load()
        task.setTaskCompleted(success: true)
        scheduleDataFetcher()
      }
    }
}
