//
//  StopWatch.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/10/14.
//

import Foundation
import SwiftUI
import Combine


class Stopwatch: ObservableObject {
    /// String to show in UI
    @Published private(set) var message = 0

    /// Is the timer running?
    @Published private(set) var isRunning = false

    /// Time that we're counting from
    private var startTime: Date? { didSet { saveStartTime() } }

    /// The timer
    private var timer: AnyCancellable?

    init() {
        startTime = fetchStartTime()

        if startTime != nil {
            start()
        }
    }
}

// MARK: - Public Interface

extension Stopwatch {
    func start() {
        timer?.cancel()               // cancel timer if any

        if startTime == nil {
            startTime = Date()
        }

        message = 0

        timer = Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let startTime = self.startTime
                else { return }

                let now = Date()
                let elapsed = now.timeIntervalSince(startTime)

//                guard elapsed < 60 else {
//                    self.stop()
//                    return
//                }

                //elf.message = String(format: "%0.1f", elapsed)
                self.message = Int(elapsed)

                //print(self.message)
            }

        isRunning = true
    }

    func stop() {
        timer?.cancel()
        timer = nil
        startTime = nil
        isRunning = false
        message = 0
    }
}

// MARK: - Private implementation

private extension Stopwatch {
    func saveStartTime() {
        if let startTime = startTime {
            UserDefaults.standard.set(startTime, forKey: "startTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }

    func fetchStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }
}
