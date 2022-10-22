//
//  SoundListView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/23.
//

import SwiftUI
import AudioToolbox
import AVFoundation

struct SoundListView: View {
    @EnvironmentObject var timeManager: TimeManager
    @Environment(\.colorScheme) var colorScheme  //ダークモードかライトモードか検出

    @State var soundPlay = try!  AVAudioPlayer(data: NSDataAsset(name: "Mute")!.data)
    @State var prevTappedCell = -1
    
    var body: some View {
        //NavigationView {
        List {
            Section( header: Text("sound")) {
                ForEach(Array(self.timeManager.noises.enumerated()), id: \.offset) { index, sound in
                    HStack {
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
                        Text(("\(sound.soundName)"))
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.timeManager.soundID = sound.id
                        self.timeManager.soundName = sound.soundName
                        
                        soundPlay.stop()
                        soundPlay = try!  AVAudioPlayer(data: NSDataAsset(name: sound.soundName)!.data)
                        if self.timeManager.noises[index].checked != true {
                            soundPlay.stop()
                            soundPlay.numberOfLoops = -1
                            soundPlay.play()
                            
                            self.timeManager.noises[index].checked.toggle()
                        } else {
                            self.timeManager.noises[index].checked.toggle()
                            soundPlay.stop()
                        }
                        
                        if prevTappedCell != -1 && prevTappedCell != index && self.timeManager.noises[prevTappedCell].checked == true {
                            self.timeManager.noises[prevTappedCell].checked.toggle()
                        }
                        
                        prevTappedCell = index
                    }
                }
            }
            
            Section( header: Text("music")) {
                ForEach(Array(self.timeManager.bgms.enumerated()), id: \.offset) { index, sound in
                    HStack {
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
                        Text(("\(sound.soundName)"))
                        
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.timeManager.soundID = sound.id
                        self.timeManager.soundName = sound.soundName
                        
                        soundPlay.stop()
                        soundPlay = try!  AVAudioPlayer(data: NSDataAsset(name: sound.soundName)!.data)
                        if self.timeManager.bgms[index].checked != true {
                            soundPlay.stop()
                            soundPlay.numberOfLoops = -1
                            soundPlay.play()
                            
                            self.timeManager.bgms[index].checked.toggle()
                        } else {
                            self.timeManager.bgms[index].checked.toggle()
                            soundPlay.stop()
                        }
                        
                        if prevTappedCell != -1 && prevTappedCell != index && self.timeManager.bgms[prevTappedCell].checked == true {
                            self.timeManager.bgms[prevTappedCell].checked.toggle()
                        }
                        
                        prevTappedCell = index
                    }
                }
            }
            
        }
        .navigationBarTitle("BGM", displayMode: .automatic)
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
