//
//  SoundListView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/23.
//

import SwiftUI
import AudioToolbox
import AVFoundation

struct checkCircle {
    var checked: Bool
    var kind: String
    
    init(_ kind: String) {
        self.checked = false
        self.kind = kind
    }
}

struct SoundListView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    @State var soundPlay = try!  AVAudioPlayer(data: NSDataAsset(name: "Mute")!.data)
    @State var prevTappedCell = -1
    
    var body: some View {
        //NavigationView {
        List {
            ForEach(Array(self.timeManager.sounds.enumerated()), id: \.offset) { index, sound in
                //ForEach(self.timeManager.sounds) { sound in
                //リストの行に関する記述
                HStack {
                    //試聴用のアイコンを表示
                    if self.timeManager.soundID == sound.id {
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
                    
                    //Image(systemName: self.timeManager.soundID == sound.id ? "checkmark.circle.fill" : "circle")
                    
                    //現在選択されているサウンドの場合はチェックマークを表示
                    //                    if self.timeManager.soundID == sound.id {
                    //                        Image(systemName: "checkmark")
                    //                    }
                }
                .contentShape(Rectangle())
                //行をタップでサウンド選択（IDと名前をTimeManagerへ反映）
                .onTapGesture {
                    self.timeManager.soundID = sound.id
                    self.timeManager.soundName = sound.soundName
                    
                    soundPlay.stop()
                    soundPlay = try!  AVAudioPlayer(data: NSDataAsset(name: sound.soundName)!.data)
                    if self.timeManager.sounds[index].checked != true {
                        soundPlay.stop()
                        soundPlay.numberOfLoops = -1
                        soundPlay.play()
                        
                        self.timeManager.sounds[index].checked.toggle()
                    } else {
                        self.timeManager.sounds[index].checked.toggle()
                        soundPlay.stop()
                    }
                    
                    if prevTappedCell != -1 && prevTappedCell != index && self.timeManager.sounds[prevTappedCell].checked == true {
                        self.timeManager.sounds[prevTappedCell].checked.toggle()
                    }
                    
                    prevTappedCell = index
                }
            }
            //}
            .navigationBarTitle("BGM", displayMode: .automatic)
            //            .navigationBarItems(
            //                trailing:
            //                    //Text("hello")
            //                Image(systemName: "checkmark.circle.fill")
            //                    .font(.title)
            //                    .foregroundColor(.blue)
            //                    .opacity(0.75)
            //                    .onTapGesture {
            //
            //                    })
        }
        .onDisappear {
            self.timeManager.addScreenCount = 1
        }
        
    }
    
}


struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
            .environmentObject(TimeManager())
    }
}
