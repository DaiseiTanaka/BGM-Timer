//
//  SoundListView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/23.
//

import SwiftUI
import AudioToolbox
import AVFoundation
import MusicKit

struct SoundListView: View {
    @EnvironmentObject var timeManager: TimeManager
    @Environment(\.colorScheme) var colorScheme  //ダークモードかライトモードか検出

    @State var soundPlay = try!  AVAudioPlayer(data: NSDataAsset(name: "Mute")!.data)
    @State var prevTappedCell = -1
    @State var prevTappedAppleMusicID = MusicItemID("0")
    
    @State private var musicSubscription: MusicSubscription?
    
    @State var showAuthView: Bool = false
    
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
                        self.timeManager.appleMusicSelectedID = MusicItemID("0")
                        self.timeManager.appleMusic = nil
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
            
            Section( header: Text("Apple Music")) {
//                NavigationLink("Auth") {
//                    AuthView()
//                }
//                NavigationLink("Subscription Information") {
//                    SubscriptionInfoView()
//                }
                ForEach(Array(self.timeManager.appleMusicSelectedList.enumerated()), id: \.offset) { index, sound in
                    HStack {
                        if self.timeManager.appleMusicSelectedID == sound.id {
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
                        Text(sound.title)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        self.timeManager.soundID = SystemSoundID(100)               //TODO: - なんとかしよう
                        self.timeManager.appleMusicSelectedID = sound.id
                        self.timeManager.soundName = sound.title
                        self.timeManager.appleMusic = sound
                        print("SoundListView tapped music: ", sound)
                        Task {
                            //ApplicationMusicPlayer.shared.queue = .init(for: [sound])
                            SystemMusicPlayer.shared.queue = .init(for: [sound])
                            do {
//                                try await ApplicationMusicPlayer.shared.prepareToPlay()
//                                try await ApplicationMusicPlayer.shared.play()
                                try await SystemMusicPlayer.shared.play()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                        self.timeManager.setTimer()

                        prevTappedCell = index
                    }
                }
                HStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            //print("helloo")
                            self.showAuthView = true
                        }){
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(Color.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .opacity((musicSubscription?.canPlayCatalogContent ?? false) ? 0 : 1)
                        
                        Spacer()
                    }
                    .frame(width: 25)
                    NavigationLink {
                        SearchSongsView()
                    } label: {
                        HStack {
                            
                            
                            Text("Search for music")
                                .foregroundColor(Color.blue)
                            Spacer()
                        }
                        
                    }
                    .disabled(!(musicSubscription?.canPlayCatalogContent ?? false))
                }
//                NavigationLink {
//                    SearchAlbumView()
//                } label: {
//                    Text("Search for album")
//                        .foregroundColor(Color.blue)
//                }
            }
            .task {
                for await subscription in MusicSubscription.subscriptionUpdates {
                    self.musicSubscription = subscription
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
                        self.timeManager.appleMusicSelectedID = MusicItemID("0")
                        self.timeManager.appleMusic = nil
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
            //ApplicationMusicPlayer.shared.stop()
            SystemMusicPlayer.shared.stop()
            self.timeManager.addScreenCount = 1
        }
        .sheet(isPresented: self.$showAuthView) {
            AuthView()
        }
    }
}


struct SoundListView_Previews: PreviewProvider {
    static var previews: some View {
        SoundListView()
            .environmentObject(TimeManager())
    }
}
