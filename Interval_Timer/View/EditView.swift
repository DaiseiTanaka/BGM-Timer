//
//  EditView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/20.
//

import Foundation
import SwiftUI
import AudioToolbox

struct EditView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var timeManager: TimeManager
    
    let delegate: EditViewDelegate
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var minutes = [Int](0..<60)
    var seconds = [Int](0..<60)
    
    @State var task: String
    @State var sound: String
    @State var alarm: Int
    @State var min: Int
    @State var sec: Int
    
    @State var editIndex: Int
    
    @State private var editting = false
    @FocusState  var isActive: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Form {
                    Section( header: Text("Task name:")) {
                        TextField("Input This Task Name", text: $timeManager.task,
                                  onEditingChanged: { begin in
                            if begin {
                                self.editting = true    // 編集フラグをオン
                            } else {
                                self.editting = false   // 編集フラグをオフ
                            }
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
                        .shadow(color: editting ? .blue : .clear, radius: 3)
                        .focused($isActive)
                        .frame(width: UIScreen.main.bounds.width - 45, height: 29)
                    }
                    
                    Section(header: Text("BGM & Alarm")) {
                        NavigationLink(destination: SoundListView()) {
                            HStack {
                                //設定項目名
                                Text("BGM")
                                
                                Spacer()
                                //現在選択中のアラーム音
                                Text("\(timeManager.soundName)")
                                    .foregroundColor(Color(UIColor.systemGray))
                                
                                if timeManager.soundID != 0 {
                                    Image(systemName: "speaker.wave.2.fill")
                                        .foregroundColor(Color(UIColor.systemGray))
                                } else {
                                    Image(systemName: "speaker.slash.fill")
                                        .foregroundColor(Color(UIColor.systemGray))
                                }
                            }
                        }
                        NavigationLink(destination: FinalSoundListView()) {
                            HStack {
                                //設定項目名
                                Text("Alarm")
                                
                                Spacer()
                                //現在選択中のアラーム音
                                Text("\(timeManager.alarmName)")
                                    .foregroundColor(Color(UIColor.systemGray))
                                
                                if timeManager.alarmId != 0 {
                                    Image(systemName: "bell.fill")
                                        .foregroundColor(Color(UIColor.systemGray))
                                } else {
                                    Image(systemName: "bell.slash.fill")
                                        .foregroundColor(Color(UIColor.systemGray))
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("How long?")) {
                        picker
                    }
                }
                
                Color.black
                    .opacity(editting ? 0.00001 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isActive = false
                    }

                Spacer()
            }
            .background(Color(UIColor.systemGray))
            .navigationTitle("Edit Timer")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                if timeManager.editScreenCount == 0 {
                    self.timeManager.task = task
                    self.timeManager.soundName = sound
                    self.timeManager.soundID = self.timeManager.sounds.first(where: { $0.soundName == self.timeManager.soundList[editIndex] })!.id
                    self.timeManager.alarmName = self.timeManager.alarms.first(where: { $0.id == SystemSoundID(alarm) })!.soundName
                    self.timeManager.alarmId = self.timeManager.alarms.first(where: { $0.id == SystemSoundID(alarm) })!.id
                    self.timeManager.min = min
                    self.timeManager.sec = sec
                }

                timeManager.editScreenCount = 1
            }
            .navigationBarItems(
                leading:
                    Text("Cancel")
                    .padding(.leading, 10)
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                    .onTapGesture{
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                        presentation.wrappedValue.dismiss()
                    }
                ,trailing:
                    Text("OK")
                    .padding(.trailing, 10)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.blue)
                    .onTapGesture {
                        self.timeManager.screenCount = 0
                        delegate.editTodo(task: timeManager.task, time: timeManager.min*60 + timeManager.sec, sound: timeManager.soundName, finSound: Int(timeManager.alarmId), min: timeManager.min, sec: timeManager.sec, editIndex: editIndex)
                        self.timeManager.setTimer()
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.warning)
                        presentation.wrappedValue.dismiss()
                    }
            )
//            .simultaneousGesture(TapGesture().onEnded {
//                UIApplication.shared.closeKeyboard()
//            })
        }
    }
    
    var picker: some View {
        VStack {
            HStack(spacing: 0) {
                //分単位のPicker
                Picker(selection: $timeManager.min, label: Text("minute")) {
                    ForEach(0 ..< self.minutes.count) { index in
                        Text("\(self.minutes[index])")
                            .tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .compositingGroup()
                .clipped(antialiased: true)
                
                //分単位を表すテキスト
                Text("min")
                    .font(.headline)
                
                //秒単位のPicker
                Picker(selection: $timeManager.sec, label: Text("second")) {
                    ForEach(0 ..< self.seconds.count) { index in
                        Text("\(self.seconds[index])")
                            .tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .compositingGroup()
                .clipped(antialiased: true)
                
                //秒単位を表すテキスト
                Text("sec")
                    .font(.headline)
            }
            .padding(.horizontal)
        }
    }
}