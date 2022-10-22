//
//  ContentView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/07.
//

import SwiftUI
import UIKit
import AudioToolbox
import AVFoundation
import FloatingPanel
import ResizableSheet
import UserNotifications
import Neumorphic


struct ContentView: View {    
    @EnvironmentObject var timeManager: TimeManager
    //@EnvironmentObject var detecter: OrientationDetector
    @State var viewHeight: CGFloat = UIScreen.main.bounds.height
    @State var viewWidth: CGFloat = UIScreen.main.bounds.width
    @Environment(\.colorScheme) var colorScheme  //ダークモードかライトモードか検出

    @Environment(\.scenePhase) private var scenePhase  // アプリが閉じた時と開いた時を検知
    @EnvironmentObject var sceneDelegate: SceneDelegate
    //@EnvironmentObject var notificationModel: NotificationModel  // 通知
    
    @State private var showModal = false
    
    @State var taskList: [String] = []
    @State var timeList: [Int] = []
    @State var soundList: [String] = []
    @State var finSoundList: [Int] = []
    @State var minList: [Int] = []
    @State var secList: [Int] = []
    
    @State var sound = try!  AVAudioPlayer(data: NSDataAsset(name: "Mute")!.data)
    @State var prevIntervalCount = -1
    @State var prevTimerState: String = "stopped"
    
    @State private var showHintView: Bool = false
    
    // Update timer from background
    @State var updateTimeFlag: Bool = false
    @State var timeFinishedFlag: Bool = false
    @ObservedObject var stopwatch = Stopwatch()
    @State var timeDifference: Int = 0
        
    // Modal view height
    let minHeight: CGFloat = UIScreen.main.bounds.height * 0.10
    let middleHeight: CGFloat = UIScreen.main.bounds.height * 0.38
    let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.9
    
    let animationHeight: CGFloat = 110
    
    private let explosion = try!  AVAudioPlayer(data: NSDataAsset(name: "Bomber")!.data)
    private let clock = try!  AVAudioPlayer(data: NSDataAsset(name: "clock2")!.data)
    
    //@Environment(\.scenePhase) var scenePhase
    @State var refreshID = UUID()
        
    private func playExplosion(){
        explosion.stop()
        explosion.currentTime = 0.0
        explosion.play()
    }
    
    private func clockPlay(rate: Float) {
        clock.enableRate = true
        clock.rate = rate
        clock.stop()
        clock.currentTime = TimeInterval(80)
        clock.play()
        print("playing clock as rate: ", rate)
    }
    
    var body: some View {
        GeometryReader { _ in
            
            ZStack {
                //if sceneDelegate.interfaceOrientation == .portrait {
                    if UIDevice.current.userInterfaceIdiom == .phone {
                        if self.timeManager.show != true {
                            titlePhone
                                .offset(x: 0, y: -viewHeight * 0.38 - 80*returnAnimationMinToMiddleHeight())
                                .animation(.easeOut, value: self.timeManager.curHeight)
                        }
                    }
                    else if UIDevice.current.userInterfaceIdiom == .pad {
                        if self.timeManager.show != true {
                            titlePad
                        }
                    }
                    
                    if timeManager.isProgressBarOn {
                        ProgressBarView()
                            .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
                            .animation(.easeOut, value: self.timeManager.curHeight)
                    }
                    
                    if timeManager.timerStatus == .stopped {
                        if self.timeManager.show == true {
                            TimeOverView()
                                .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
                                .animation(.easeOut, value: self.timeManager.curHeight)
                        } else {
                            TimerView()
                                .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
                                .animation(.easeOut, value: self.timeManager.curHeight)
                                .animation(.easeInOut, value: self.timeManager.intervalCount)
                                .animation(.easeInOut, value: self.timeManager.pageIndex)
                        }
                    } else {
                        TimerView()
                            .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
                            .animation(.easeOut, value: self.timeManager.curHeight)
                            .animation(.easeInOut, value: self.timeManager.intervalCount)
                            .animation(.easeInOut, value: self.timeManager.pageIndex)
                    }
                    
//                    VStack {
//                        Spacer()
//                        BannerView()
//                            .frame(height: 60)
//                    }
//                    .padding(.bottom, 110)
//
//                    VStack {
//                        Spacer()
//                        BannerView()
//                            .frame(height: 60)
//                    }

                    ModalView(isShowing: $timeManager.isSetting)

//                } else {
//                    if timeManager.isProgressBarOn {
//                        ProgressBarView()
//                            .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
//                            .animation(.easeOut, value: self.timeManager.curHeight)
//                    }
//
//                    if timeManager.timerStatus == .stopped {
//                        if self.timeManager.show == true {
//                            TimeOverView()
//                                .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
//                                .animation(.easeOut, value: self.timeManager.curHeight)
//                        } else {
//                            TimerView()
//                                .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
//                                .animation(.easeOut, value: self.timeManager.curHeight)
//                                .animation(.easeInOut, value: self.timeManager.intervalCount)
//                                .animation(.easeInOut, value: self.timeManager.pageIndex)
//                        }
//                    } else {
//                        TimerView()
//                            .offset(y: self.timeManager.curHeight <= middleHeight ? -animationHeight*returnAnimationMinToMiddleHeight() : -animationHeight)
//                            .animation(.easeOut, value: self.timeManager.curHeight)
//                            .animation(.easeInOut, value: self.timeManager.intervalCount)
//                            .animation(.easeInOut, value: self.timeManager.pageIndex)
//                    }
//                }
                
                
            }
            //MARK: - Animation
            //.animation(.easeOut, value: self.timeManager.curHeight)
            .sheet (isPresented: self.$timeManager.showHintView) {
                WorkThroughAdgendaView()
            }
//            .fullScreenCover(isPresented: self.$timeManager.showMyListView) {
//                MyListView()
//                    .backgroundClearSheet()
//                    .background(.ultraThinMaterial.opacity(0.6))
//            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.statusBar(hidden: true)
            .onAppear {
                self.timeManager.isSetting = true
                self.timeManager.setTimer()
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert]) { (_, _) in }
            }
            // MARK: - BackGround
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .active:
                    if self.updateTimeFlag {
                        self.timeManager.removeNotification()
                        self.updateTimeFlag = false
                        self.timeDifference = stopwatch.message
                        UpdateTimerFromBackGround()
                        if self.timeFinishedFlag {
                            self.timeManager.start()
                        }
                    }
                    stopwatch.stop()
                    
                    print("The scene is in the foreground and interactive.")
                    
                case .inactive:
                    print("The scene is in the foreground but should pause its work.")
//                    if self.timeManager.timerStatus == .running {
//                        self.updateTimeFlag = true
//                        self.timeManager.pause()
//                        stopwatch.start()
//                    }
                case .background:
                    print("The scene isn’t currently visible in the UI.")
                    if self.timeManager.timerStatus == .running {
                        self.timeManager.setNotification()
                        //self.Notify()
                        self.updateTimeFlag = true
                        self.timeManager.pause()
                        stopwatch.start()
                    }
                @unknown default: break
                }
            }
            .ignoresSafeArea()
            //指定した時間（1秒）ごとに発動するtimerをトリガーにしてクロージャ内のコードを実行
            .onReceive(timeManager.timer) { _ in
                //print("\(self.timeManager.curHeight) min: \(minHeight) middle: \(middleHeight) max: \(maxHeight)")
                guard self.timeManager.timerStatus == .running else {
                    if self.timeManager.timerStatus == .pause {
                        prevTimerState = "pause"
                        sound.pause()
                    }
                    if self.timeManager.timerStatus == .stopped {
                        prevIntervalCount = -1
                        prevTimerState = "stopped"
                        sound.stop()
                    }
                    return
                    
                }
                //残り時間が0より大きい場合
                if self.timeManager.duration > 0 {
                    //print("Duration: \(self.timeManager.duration)")
                    //残り時間から -0.05 する
                    self.timeManager.duration -= 0.05
                    self.timeManager.timeSumDuration -= 0.05
                    if self.timeManager.soundIconCount < 2 {
                        self.timeManager.soundIconCount += 0.1
                    } else {
                        self.timeManager.soundIconCount = 0
                    }
                    
                    //playFinishClockSound()
                    //playDefaultSound()
                    //playVibration()
                    
                    if self.prevIntervalCount != self.timeManager.intervalCount {
                        sound = try!  AVAudioPlayer(data: NSDataAsset(name: self.timeManager.soundList[self.timeManager.intervalCount])!.data)
                        playSound()
                    } else {
                        if prevTimerState == "pause" {
                            playSound()
                        }
                    }
                    
                    self.prevIntervalCount = self.timeManager.intervalCount
                    prevTimerState = "running"
                    
                } else {
                    self.timeManager.show = true
                    if self.timeManager.intervalCount != self.timeManager.taskList.count - 1 {
                        sound.currentTime = 0.0
                        playDefaultSound()
                        self.timeManager.intervalCount += 1
                        self.timeManager.setTimer()
                        self.timeManager.show = false
                    } else {
                        self.timeManager.timerStatus = .stopped
                        self.timeManager.intervalCount = 0
                        self.timeManager.setTimer()
                    }
                    prevTimerState = "stopped"
                    
                }
                
            }
        }
    }
    
    func UpdateTimerFromBackGround() {
        if stopwatch.message >= Int(self.timeManager.timeSumDuration) {
            self.timeManager.reset()
            self.timeManager.setTimer()
            self.timeFinishedFlag = false
        } else {
            for num in 0..<self.timeManager.intervalList[self.timeManager.pageIndex].timeList.count {
                print("😄Back from Background!! Num: \(num)  \(self.timeManager.duration) - \(Double(self.timeDifference)) = \(self.timeManager.duration - Double(self.timeDifference)) sumDuration: \(self.timeManager.timeSumDuration) \n intervalCount: \(self.timeManager.intervalCount) ListCount: \(self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count)")

                if self.timeManager.timeList[self.timeManager.intervalCount] < self.timeDifference || Int(self.timeManager.duration) < self.timeDifference {
                    if num == 0 {
                        print("Back A")
                        self.timeDifference -= Int(self.timeManager.duration)
                        self.timeManager.timeSumDuration -= Double(self.timeManager.duration)
                    } else {
                        print("Back B")
                        self.timeDifference -= self.timeManager.timeList[self.timeManager.intervalCount]
                        self.timeManager.timeSumDuration -= Double(self.timeManager.timeList[self.timeManager.intervalCount])
                    }
                    self.timeManager.intervalCount += 1
                    self.timeManager.setTimer()
                } else {
//                    print("Back from Background!! \(self.timeManager.duration) - \(Double(self.timeDifference)) = \(self.timeManager.duration - Double(self.timeDifference))")
                    self.timeManager.duration -= Double(self.timeDifference)
                    self.timeManager.timeSumDuration -= Double(self.timeDifference)
                    self.timeFinishedFlag = true
                    print("Back C")
                    return
                }
            }
        }
    }
    
    func Notify() {
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Timer is Completed successfully in BackGround !!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    private func playSound(){
        print("Playing sound: ", self.timeManager.soundList[self.timeManager.intervalCount])
        sound.stop()
        //sound.currentTime = 0.0
        sound.numberOfLoops = -1
        sound.play()
    }
    
    func playFinishClockSound() {
        if self.timeManager.duration < 2 && self.timeManager.duration > 1.95 {
            //clock.volume = 1
            clockPlay(rate: 4.0)
        }
        else if self.timeManager.duration < 6 && self.timeManager.duration > 5.95 {
            clockPlay(rate: 2.0)
        }
        else if self.timeManager.duration < 10 && self.timeManager.duration > 9.95 {
            clockPlay(rate: 1.0)
        }
    }
    
    func playDefaultSound() {
        var soundIdRing: SystemSoundID = SystemSoundID(self.timeManager.alarmList[self.timeManager.intervalCount])
        if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
            AudioServicesPlaySystemSound(soundIdRing)
        }
    }
    
    func playVibration() {
        //バイブレーション
        if self.timeManager.duration > 10 && self.timeManager.duration <= 60 {
            if timeManager.isVibrationOn {
                AudioServicesPlaySystemSound( 1520 )
            }
        }
    }
    
    var titlePhone: some View {
        VStack {
            ZStack {
                if self.timeManager.intervalList.count == 0 {
                    Text("BGM Timer")
                        .font(.largeTitle)
                        .foregroundColor(Color(UIColor.label))
                        .fontWeight(.heavy)
                        .opacity((self.timeManager.show != true && self.timeManager.timerStatus == .stopped) ? 1 : 0)
                        .padding(.top, 50)
                        .padding(.bottom, 20)
                } else {
                    Text("\(self.timeManager.taskList[self.timeManager.intervalCount])")
                        .font(.largeTitle)
                        .foregroundColor(Color(UIColor.label))
                        .fontWeight(.heavy)
                        .opacity((self.timeManager.timerStatus != .pause) ? 1 : 0.2)
                        .padding(.top, 50)
                        .padding(.bottom, 20)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .lineLimit(1)
                }
            }
            .opacity(self.timeManager.curHeight <= middleHeight ? CGFloat(1-returnAnimationMinToMiddleHeight()) : 0)
            
            HStack(spacing: 10) {
                if self.timeManager.taskList.count != 0 {
                    Spacer()
                    if self.timeManager.timerStatus == .stopped && self.timeManager.timeSumDuration < 0.1 {
                        Text("Please set time!")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray))
                            .fontWeight(.medium)
                    } else {
                        
                        // My list name
                        Text(String(self.timeManager.intervalList[self.timeManager.pageIndex].listName))
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray))
                            .fontWeight(.medium)
                            .frame(maxWidth: viewWidth * 0.4, alignment: .center)
                            .lineLimit(1)
                            .padding(.trailing, self.timeManager.curHeight >= middleHeight ? 0 : 20)
                            .padding(.leading, self.timeManager.curHeight < middleHeight ? 0 : 20)
                        
                        if self.timeManager.curHeight >= middleHeight {
                            Text("\(self.timeManager.taskList[self.timeManager.intervalCount])")  // Task name
                                .font(.title2)
                                .foregroundColor(Color(UIColor.systemGray))
                                .fontWeight(.medium)
                                .opacity(self.timeManager.curHeight <= middleHeight ? CGFloat(returnAnimationMinToMiddleHeight()) : 1)
                                .frame(maxWidth: viewWidth * 0.4, alignment: .center)
                                .padding(.trailing, 20)
                                .lineLimit(1)
                        }
                        
                        if self.timeManager.curHeight < middleHeight {
                            HStack(alignment: .center) {
                                Image(systemName: "timer")
                                    .font(.title2)
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .opacity(self.timeManager.curHeight <= middleHeight ? CGFloat(1-returnAnimationMinToMiddleHeight()) : 0)
                                
                                Text(String(format: "%02d:%02d", self.timeManager.minList[self.timeManager.intervalCount], self.timeManager.secList[self.timeManager.intervalCount]))
                                    .font(.title2)
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .fontWeight(.medium)
                                    .opacity(self.timeManager.curHeight <= middleHeight ? CGFloat(1-returnAnimationMinToMiddleHeight()) : 0)
                                    .padding(.trailing, 20)
//                                    .frame(maxWidth: viewWidth * 0.4, alignment: .center)
                            }
                            .frame(maxWidth: viewWidth * 0.4)
                            
                        }
                        
//                        Text("\(self.timeManager.intervalCount + 1) / \(self.timeManager.taskList.count)")
//                            .font(.title2)
//                            .foregroundColor(Color(UIColor.systemGray))
//                            .fontWeight(.medium)
//                            //.frame(maxWidth: UIScreen.main.bounds.width * 0.3)
//                            .padding(.trailing, 30)

                    }
                    Spacer()
                }
            }
            .opacity(self.timeManager.curHeight >= middleHeight ? CGFloat(1-returnAnimationMiddleToMaxHeight()) : 1)

        }
    }
    
    var titlePad: some View {
        VStack {
            Text("My Interval")
                .font(.largeTitle)
                .foregroundColor(Color(UIColor.label))
                .fontWeight(.heavy)
                .opacity((self.timeManager.show != true && self.timeManager.timerStatus == .stopped) ? 1 : 0)
                .offset(x: 0, y: viewHeight * 0.02)
                .padding(.top, 50)
            
            HStack {
                Spacer()
                Image(systemName: "chevron.backward.2")
                    .resizable()
                    .frame(width: 25, height: 25)
                //.offset(x: 0, y: -viewHeight * 0.55)
                    .opacity(self.timeManager.intervalCount == 0 ? 0.1 : 1)
                    .onTapGesture {
                        if self.timeManager.intervalCount != 0 {
                            self.timeManager.intervalCount -= 1
                            self.timeManager.setTimer()
                        }
                    }
                Spacer()
                Group {
                    if self.timeManager.timerStatus == .stopped && self.timeManager.timeSumDuration < 0.1 {
                        Text("Please set time!")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray))
                            .fontWeight(.medium)
                            //.offset(x: 0, y: -viewHeight * 0.55)
                    } else {
                        Text("\(self.timeManager.taskList[self.timeManager.intervalCount])")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray))
                            .fontWeight(.medium)
                            //.offset(x: 0, y: -viewHeight * 0.55)
                        Spacer()
                        Text(String(format: "%02d:%02d", self.timeManager.minList[self.timeManager.intervalCount], self.timeManager.secList[self.timeManager.intervalCount]))
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray))
                            .fontWeight(.medium)
                            //.offset(x: 0, y: -viewHeight * 0.55)
                        Spacer()
                        Text("\(self.timeManager.intervalCount + 1)/\(self.timeManager.taskList.count)")
                            .font(.title2)
                            .foregroundColor(Color(UIColor.systemGray))
                            .fontWeight(.medium)
                            //.offset(x: 0, y: -viewHeight * 0.55)
                    }
                }
                Spacer()
                Image(systemName: "chevron.forward.2")
                    .resizable()
                    .frame(width: 25, height: 25)
                    //.offset(x: 0, y: -viewHeight * 0.38)
                    .opacity(self.timeManager.intervalCount == self.timeManager.taskList.count - 1 ? 0.1 : 1)
                    .onTapGesture {
                        if self.timeManager.intervalCount != self.timeManager.taskList.count - 1 {
                            self.timeManager.intervalCount += 1
                            self.timeManager.setTimer()
                        }
                    }
                Spacer()
            }
            .padding(.top, 40)
            
            Spacer()
        }
    }
    
    private func returnAnimationMinToMiddleHeight() -> CGFloat {
       return (self.timeManager.curHeight-minHeight)/(middleHeight - minHeight)
    }
    
    private func returnAnimationMiddleToMaxHeight() -> CGFloat {
        //return (self.timeManager.curHeight-middleHeight)/(maxHeight - middleHeight)
        return (self.timeManager.curHeight-middleHeight)/100

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(TimeManager())
        }
    }
}
