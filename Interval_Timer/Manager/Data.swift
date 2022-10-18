//
//  Data.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/15.
//

import SwiftUI
import AudioToolbox

enum TimeFormat {
    case hr
    case min
    case sec
}

enum TimerStatus {
    case running
    case pause
    case stopped
}

struct Sound: Identifiable {
    let id: SystemSoundID
    let soundName: String
    var checked: Bool
    init(id: SystemSoundID, soundName: String) {
        self.id = id
        self.soundName = soundName
        self.checked = false
    }
}

struct IntervalList: Codable {
    var listName: String
    var taskList: [String]
    var bgmNameList: [String]
    var alarmIDList: [Int]
    var timeList: [Int]
    var minList: [Int]
    var secList: [Int]
}
