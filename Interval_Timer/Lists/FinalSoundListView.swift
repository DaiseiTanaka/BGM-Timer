//
//  FinalSoundListView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/16.
//


import SwiftUI
import AudioToolbox

struct FinalSoundListView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    var body: some View {
        //NavigationView {
        List {
            ForEach(Array(self.timeManager.alarms.enumerated()), id: \.offset) { index, sound in
                //リストの行に関する記述
                HStack {
                    if self.timeManager.alarmId == sound.id {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(Color.blue)
                                .font(.title3)
                            
                            Spacer()
                        }
                        .frame(width: 25)
                    } else {
                        HStack {
                            
                        }
                        .frame(width: 25)
                    }
                    //soundNameの値でリストに表示する
                    Text(("\(sound.soundName)"))
                    
                    Spacer()
                    
                }
                .contentShape(Rectangle())
                //行をタップでサウンド選択（IDと名前をTimeManagerへ反映）
                .onTapGesture {
                    self.timeManager.alarmId = sound.id
                    self.timeManager.alarmName = sound.soundName
                    
                    AudioServicesPlayAlertSoundWithCompletion(sound.id, nil)
                }
            }
        }
        .navigationBarTitle("Alarm", displayMode: .automatic)
        .onDisappear {
            self.timeManager.addScreenCount = 1
        }
        //}
    }
}

struct FinalSoundListView_Previews: PreviewProvider {
    static var previews: some View {
        FinalSoundListView()
            .environmentObject(TimeManager())
    }
}
