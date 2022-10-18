//
//  Interval_TimerApp.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/07.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

@main
struct Interval_TimerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(TimeManager())
                //.environmentObject(NotificationModel())
                .sheet(isPresented: $isFirstLaunch) {
                    WorkThroughView()
                        .environmentObject(TimeManager())
                        //.environmentObject(NotificationModel())
                }
        }
    }
}
