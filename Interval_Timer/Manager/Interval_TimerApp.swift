//
//  Interval_TimerApp.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/07.
//

import SwiftUI
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            config.delegateClass = SceneDelegate.self
            return config
        }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate, ObservableObject {
    @Published var interfaceOrientation: UIInterfaceOrientation = .unknown

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let scene = scene as? UIWindowScene {
            interfaceOrientation = scene.interfaceOrientation
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let scene = scene as? UIWindowScene {
            interfaceOrientation = scene.interfaceOrientation
        }
    }

    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        interfaceOrientation = windowScene.interfaceOrientation
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
