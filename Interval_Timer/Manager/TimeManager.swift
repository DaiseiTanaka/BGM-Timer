//
//  TimerManager.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/15.
//

import SwiftUI
import AudioToolbox
import UserNotifications


class TimeManager: ObservableObject {
    //Pickerで設定した"時間"を格納する変数
    @Published var hourSelection: Int = 0
    //Pickerで設定した"分"を格納する変数
    @Published var minSelection: Int = 0
    //Pickerで設定した"秒"を格納する変数
    @Published var secSelection: Int = 0
    //カウントダウン残り時間
    @Published var duration: Double = 0
    //カウントダウン開始前の最大時間
    @Published var maxValue: Double = 0
    //設定した時間が1時間以上、1時間未満1分以上、1分未満1秒以上によって変わる時間表示形式
    @Published var displayedTimeFormat: TimeFormat = .min
    //タイマーのステータス
    @Published var timerStatus: TimerStatus = .stopped
    //アラーム音オン/オフの設定
    @Published var isAlarmOn: Bool = true
    //バイブレーションオン/オフの設定
    @Published var isVibrationOn: Bool = true
    //プログレスバー表示オン/オフの設定
    @Published var isProgressBarOn: Bool = true
    //エフェクトアニメーション表示オン/オフの設定
    @Published var isEffectAnimationOn: Bool = true
    //設定画面の表示/非表示
    @Published var isSetting: Bool = false
    //1秒ごとに発動するTimerクラスのpublishメソッド
    var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    @Published var show: Bool = false
    
    @Published var taskList: [String] = ["Please set time"]
    @Published var soundList: [String] = [""]
    @Published var alarmList: [Int] = [0]
    @Published var timeList: [Int] = [0]
    @Published var minList: [Int] = [0]
    @Published var secList: [Int] = [0]
    
    @Published var task: String = ""
    @Published var soundID: SystemSoundID = 0
    @Published var soundName: String = "Mute"
    @Published var alarmId: SystemSoundID = 0
    @Published var alarmName: String = "Mute"
    @Published var min: Int = 0
    @Published var sec: Int = 0
    
    @Published var editIndex: Int = 0
    
    @Published var intervalCount: Int = 0
    @Published var screenCount: Int = 0
    @Published var editScreenCount: Int = 0 // editViewに反映するデータを一度だけリストから持ってくるため
    @Published var soundIconCount: Double = 0
    @Published var addScreenCount: Int = 0  // addViewを開くたびに初期化するため　またsoundListやalarmListを開いたのち、editViewに戻った時は初期化しないようにする。
    
    
    @Published var timeSum: Double = 0
    @Published var timeSuffixFrom: Int = 0
    @Published var timeSuffixTo: Int = 0
    @Published var timeSumDuration: Double = 0
    
    //@Published var curHeight: CGFloat = UIScreen.main.bounds.height * 0.12
    @Published var curHeight: CGFloat = 0

    
    @Published var intervalList: [IntervalList] = []
    @Published var selectedMyList: [IntervalList] = []
    @Published var myListScreenCount: Int = 0  //Interval Scheduleを編集するとき　0, MyListを編集するとき　1
    @Published var intervalListCount: Int = 0
    @Published var myListAppearingIndex: Int = 0
    @Published var prevMyListAppearingIndex: Int = 0
    @Published var pageIndex = 0
    
    @Published var listName: String = "Test"
    
    @Published var sideMenuOffset: CGFloat = 0
    
    @Published var myListNameList: [String] = []
    
    @Published var showHintView: Bool = false
    
    // Work Through View
    @Published var workThroughPageIndex: Int = 0
    
    
    @Published var sounds: [Sound] = [
        Sound(id:    0, soundName: "Mute"),
        Sound(id:    1, soundName: "Buzzer"),
        Sound(id:    2, soundName: "country"),
        Sound(id:    3, soundName: "morning"),
        Sound(id:    4, soundName: "BGM-099"),
        Sound(id:    5, soundName: "BGM-100"),
        Sound(id:    6, soundName: "BGM-108"),
        Sound(id:    7, soundName: "BGM-115"),
        Sound(id:    8, soundName: "BGM-124"),
        Sound(id:    9, soundName: "BGM-136"),
        Sound(id:    10, soundName: "BGM-138"),
        Sound(id:    11, soundName: "BGM-140"),
        Sound(id:    12, soundName: "BGM-142"),
        Sound(id:    13, soundName: "BGM-143"),
        Sound(id:    14, soundName: "BGM-145"),
        Sound(id:    15, soundName: "BGM-146"),
        Sound(id:    16, soundName: "BGM-147"),
        Sound(id:    17, soundName: "BGM-151"),
        Sound(id:    18, soundName: "rain1"),
        Sound(id:    19, soundName: "rain2"),
        Sound(id:    20, soundName: "cafe_noise"),
        Sound(id:    21, soundName: "train"),
        Sound(id:    22, soundName: "rock_guitar")
    ]
    
    @Published var alarms: [Sound] = [
        Sound(id:    0, soundName: "Mute"),
        Sound(id: 1151, soundName: "Beat"),
        Sound(id: 1304, soundName: "Alert"),
        Sound(id: 1309, soundName: "Glass"),
        Sound(id: 1310, soundName: "Horn"),
        Sound(id: 1313, soundName: "Bell"),
        Sound(id: 1314, soundName: "Electronic"),
        Sound(id: 1320, soundName: "Anticipate"),
        Sound(id: 1327, soundName: "Minuet"),
        Sound(id: 1328, soundName: "News Flash"),
        Sound(id: 1330, soundName: "Sherwood Forest"),
        Sound(id: 1333, soundName: "Telegraph"),
        Sound(id: 1334, soundName: "Tiptoes"),
        Sound(id: 1335, soundName: "Typewriterst"),
        Sound(id: 1336, soundName: "Update")
    ]
    
    // MARK: - Notification
    //@State var notificationIdentifier = "NotificationTest"

    func setNotification(){

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted {
                //許可
                self.makeNotification()
            }else{
                //非許可
            }
        }

    }

    
    func makeNotification(){
        
        var prevNotificationDate = 0
        
        for num in self.intervalCount..<self.intervalList[self.pageIndex].timeList.count {
            var notificationIdentifier = self.taskList[num] + String(num)
            let notificationDate = Date().addingTimeInterval(num == self.intervalCount ? TimeInterval(self.duration) : TimeInterval(self.intervalList[self.pageIndex].timeList[num] + prevNotificationDate))
            let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
            
            if num == self.intervalCount {
                prevNotificationDate += Int(self.duration)
            } else {
                prevNotificationDate += self.intervalList[self.pageIndex].timeList[num]
            }
            
            //日時でトリガー指定
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
            
            //通知内容
            let content = UNMutableNotificationContent()
            content.title = "\(self.intervalList[self.pageIndex].listName)"
            
            if num != self.intervalList[self.pageIndex].taskList.count-1 {
                //content.body = "\(self.intervalList[self.pageIndex].taskList[num]) " + String(format: "(%02d:%02d) ", self.minList[num], self.secList[num]) + "Finished!"
                content.body = "\(self.intervalList[self.pageIndex].taskList[num])  Finished!  [\(num+1)/\(self.intervalList[self.pageIndex].taskList.count)]"
                // \nNEXT▶︎  \(self.intervalList[self.pageIndex].taskList[num])" + String(format: "  (%02d:%02d) ", self.minList[num+1], self.secList[num+1])

            } else {
                content.body = "All tasks Finished! 👍"
            }
            content.sound = UNNotificationSound.default

            //リクエスト作成
            let request = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)

            //通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("Notification added! identifer: \(notificationIdentifier) Date: \(notificationDate)")
        }
    }

    func removeNotification(){
        for task in self.intervalList[self.pageIndex].taskList {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task])
            print("Notification removed! \(task)")
        }
    }
    
    
    //MARK: - Set timer
    //Pickerで取得した値からカウントダウン残り時間とカウントダウン開始前の最大時間を計算しその値によって時間表示形式も指定する
    func setTimer() {
        setInterval()
        //残り時間をPickerから取得した時間・分・秒の値をすべて秒換算して合計して求める
        //duration = Double(hourSelection * 3600 + minSelection * 60 + secSelection)
        if minList != [] && secList != [] {
            duration = Double(minList[intervalCount]*60 + secList[intervalCount]) - 0.01
            
        } else {
            duration = -0.01
        }
        
        if taskList.count == 0 {
            intervalCount = 0
        }
        
        //Pickerで時間を設定した時点=カウントダウン開始前のため、残り時間=最大時間とする
        maxValue = duration
        timeSum = Double(minList.reduce(0, +) * 60 + secList.reduce(0, +)) - 0.01
        timeSumDuration = Double(timeList.suffix(taskList.count - intervalCount).reduce(0, +)) - 0.01
        print("timeSum; ", timeSum, timeList.suffix(2).reduce(0, +))
        //時間表示形式を残り時間（最大時間）から指定する
        //60秒未満なら00形式、60秒以上3600秒未満なら00:00形式、3600秒以上なら00:00:00形式
        if duration < 60 {
            displayedTimeFormat = .sec
        } else if duration < 3600 {
            displayedTimeFormat = .min
        } else {
            displayedTimeFormat = .hr
        }
        print("settimer() is called")
    }
    
    func setInterval() {
        self.intervalList = loadIntervalList() ?? [IntervalList(listName: "New List", taskList: ["Task1"], bgmNameList: ["Mute"], alarmIDList: [0], timeList: [90], minList: [1], secList: [30])]
        
        self.intervalListCount = self.intervalList.count
//        if self.intervalListCount == 0 {
//            intervalList.append(contentsOf: [IntervalList(listName: "New List", taskList: [], bgmNameList: [], alarmIDList: [], timeList: [], minList: [], secList: [])])
//        }
        
        if intervalList[self.pageIndex].taskList.count == 0 {
            intervalList[pageIndex].taskList.append("Task1")
            intervalList[pageIndex].timeList.append(0)
            intervalList[pageIndex].bgmNameList.append("Mute")
            intervalList[pageIndex].alarmIDList.append(0)
            intervalList[pageIndex].minList.append(0)
            intervalList[pageIndex].secList.append(0)
            print("=== IntervalList Debug Called!\n \(intervalList[self.pageIndex])")
        }
        self.myListNameList = returnMyListName()
        
        self.taskList = self.intervalList[self.pageIndex].taskList
        self.timeList = self.intervalList[self.pageIndex].timeList
        self.soundList = self.intervalList[self.pageIndex].bgmNameList
        self.alarmList = self.intervalList[self.pageIndex].alarmIDList
        self.minList = self.intervalList[self.pageIndex].minList
        self.secList = self.intervalList[self.pageIndex].secList
        saveIntervalList(intervalList: intervalList)

        //print("=== setInterval is called! intervalListCount: \(intervalList.count) pageIndex: \(pageIndex) \n ---intervalList: \(intervalList) \n ---intervalCount: \(intervalCount) taskList: \(taskList)  timeList: \(timeList)  soundList: \(soundList)  finSoundList: \(alarmList)  minList; \(minList)  secList: \(secList)  myListNameList: \(myListNameList)")
    }
    
    func loadIntervalList() -> [IntervalList]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "LIST2"),
              let intervalList = try? jsonDecoder.decode([IntervalList].self, from: data) else {
            //print("😭: IntervalListのロードに失敗しました。")
            return nil
        }
        //print("😄👍: IntervalListのロードに成功しました。")
        return intervalList
    }
    
    func saveIntervalList(intervalList: [IntervalList]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(intervalList) else {
            //print("😭: IntervalListの保存に失敗しました。")
            return
        }
        UserDefaults.standard.set(data, forKey: "LIST2")
        //print("😄👍: IntervalListの保存に成功しました。")
    }
    
    func returnMyListName() -> [String] {
        var myList: [String] = []
        for num in 0..<intervalListCount {
            myList.append(intervalList[num].listName)
        }
        return myList
    }
    
    //カウントダウン中の残り時間を表示するためのメソッド
    func displayTimer() -> String {
        //残り時間（時間単位）= 残り合計時間（秒）/3600秒
        let hr = Int(duration) / 3600
        //残り時間（分単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒
        let min = Int(duration) % 3600 / 60
        //残り時間（秒単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒 で割った余り
        let sec = Int(duration) % 3600 % 60 + 1
        
        //print(Int(duration))
        //setTimerメソッドの結果によって時間表示形式を条件分岐し、上の3つの定数を組み合わせて反映
        if timerStatus == .stopped && timeSumDuration < 0.1 {
            return String("0")
        }
        switch displayedTimeFormat {
        case .hr:
            return String(format: "%02d:%02d:%02d", hr, min, sec)
        case .min:
            //print(Int(duration))
            if Int(duration) > 59 {
                if Int(duration) % 60 == 59 {
                    if Int(duration) > 601 {
                        return String(format: "%02d:%02d", min+1, 00)
                    } else {
                        return String(format: "%01d:%02d", min+1, 00)
                    }
                } else {
                    if Int(duration) > 601 {
                        return String(format: "%02d:%02d", min, sec)
                    } else {
                        return String(format: "%01d:%02d", min, sec)
                    }
                }
                
            } else if Int(duration) > 9 {  // 1分未満の時は2桁のみ表示
                if Int(duration) % 60 == 59 {
                    return String("1:00")
                } else {
                    return String(format: "%02d", sec)
                }
                
            } else {
                return String("\(sec)")
            }
            
        case .sec:
            if Int(duration) > 9 {
                return String(format: "%02d", sec)
            } else {
                return String("\(sec)")
            }
        }
    }
    
    func displayTotalTime() -> String {
        let hr = Int(timeSumDuration) / 3600
        //残り時間（分単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒
        let min = Int(timeSumDuration) % 3600 / 60
        //残り時間（秒単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒 で割った余り
        let sec = Int(timeSumDuration) % 3600 % 60 + 1
        
        //print(Int(timeSumDuration))
        if timerStatus == .stopped && timeSumDuration < 0.1 {
            return String("0")
        }
        
        let sum = Int(timeSumDuration) + 1
//        print("------")
//        print("\(sum)")
//        print("\(hr)")
//        print("\(min)")
//        print("\(sec)")
        
//        if Int(timeSumDuration) > 59 {
//            if Int(timeSumDuration) % 60 == 59 {
//                if Int(timeSumDuration) > 601 {
//                    return String(format: "%02d:%02d", min+1, 00)
//                } else {
//                    return String(format: "%01d:%02d", min+1, 00)
//                }
//            } else {
//                if Int(timeSumDuration) > 601 {
//                    return String(format: "%02d:%02d", min, sec)
//                } else {
//                    return String(format: "%01d:%02d", min, sec)
//                }
//            }
//
//        } else  {  // 1分未満の時は2桁のみ表示
//            if Int(timeSumDuration) % 60 == 59 {
//                return String("1:00")
//            } else {
//                return String(format: "00:%02d", sec)
//            }
//        }
        
        if sum % 60 == 0 {
            if sum >= 3600 {
                if sum == 3600 {
                    return String("01:00:00")
                } else if sum == 36000 {
                    return String("10:00:00")
                } else {
                    return String(format: "%02d:%02d:%02d", hr, min+1, 00)
                }
            } else if sum > 60 {
                return String(format: "%02d:%02d", min+1, 00)
            } else {
                return String("01:00")
            }
        } else {
            if sum >= 3600 {
                return String(format: "%02d:%02d:%02d", hr, min, sec)
            } else if sum > 60 {
                return String(format: "%02d:%02d", min, sec)
            } else {
                return String(format: "00:%02d", sec)
            }
        }
    }
    
    func displaySumTime() -> String {
        let hr = Int(timeSum) / 3600
        //残り時間（分単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒
        let min = Int(timeSum) % 3600 / 60
        //残り時間（秒単位）= 残り合計時間（秒）/ 3600秒 で割った余り / 60秒 で割った余り
        let sec = Int(timeSum) % 3600 % 60 + 1
        
        //print(Int(timeSumDuration))
        if timerStatus == .stopped && timeSumDuration < 0.1 {
            return String("0")
        }
        
        let sum: Int = timeList.reduce(0, +)
        
//        print("------")
//        print("\(sum)")
//        print("\(hr)")
//        print("\(min)")
//        print("\(sec)")
        
        if sec % 60 == 0 {
            if sum >= 3600 {
                return String(format: "%02d:%02d:%02d", hr+1, 00, 00)
            } else if sum > 60 {
                return String(format: "%02d:%02d", min+1, 00)
            } else {
                return String("1:00")
            }
        } else {
            if sum >= 3600 {
                return String(format: "%02d:%02d:%02d", hr, min, sec)
            } else if sum > 60 {
                return String(format: "%02d:%02d", min, sec)
            } else {
                return String(format: "00:%02d", sec)
            }
        }
    }
    
    //スタートボタンをタップしたときに発動するメソッド
    func start() {
        //タイマーステータスを.runningにする
        timerStatus = .running
    }
    
    //一時停止ボタンをタップしたときに発動するメソッド
    func pause() {
        //タイマーステータスを.pauseにする
        timerStatus = .pause
    }
    
    //リセットボタンをタップしたときに発動するメソッド
    func reset() {
        print("reset is called")
        timerStatus = .stopped
        intervalCount = 0
        //残り時間がまだ0でなくても強制的に0にする
//        if minList != [] && secList != [] {
//            duration = Double(minList[0]*60 + secList[0])
//        } else {
//            duration = 0
//        }
        show = false
    }
    
    func restart() {
        print("restart is called")
        intervalCount = 0
        //setTimer()
        timerStatus = .running
        
        show = false
    }
}
