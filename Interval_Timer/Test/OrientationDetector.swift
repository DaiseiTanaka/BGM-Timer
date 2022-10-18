//
//  OrientationDetector.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/18.
//

import SwiftUI

class OrientationDetector: ObservableObject {
    @Published var currentDeviceOrientation: String = ""
    private var orientationObserver: NSObjectProtocol? = nil
    let notification = UIDevice.orientationDidChangeNotification

    func start() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        orientationObserver = NotificationCenter.default.addObserver(forName: notification, object: nil, queue: .main) {
            [weak self] _ in
            switch UIDevice.current.orientation {
            case .faceUp:
                self?.currentDeviceOrientation = "Face Up"
            case .faceDown:
                self?.currentDeviceOrientation = "Face Down"
            case .portrait:
                self?.currentDeviceOrientation = "Portrait"
            case .portraitUpsideDown:
                self?.currentDeviceOrientation = "Portrait Upside Down"
            case .landscapeRight:
                self?.currentDeviceOrientation = "Landscape Right"
            case .landscapeLeft:
                self?.currentDeviceOrientation = "Landscape Left"
            case .unknown:
                self?.currentDeviceOrientation = "Unknown"
            default:
                break            }
        }
    }

    func stop() {
        if let orientationObserver = orientationObserver {
            NotificationCenter.default.removeObserver(orientationObserver, name: notification, object: nil)
        }
        orientationObserver = nil
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }

    deinit {
        stop()
    }
}
