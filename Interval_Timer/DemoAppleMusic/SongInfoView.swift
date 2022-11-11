//
//  PlayMusicView.swift
//  MusicKit_Demo
//
//  Created by Shunzhe on 2022/01/22.
//

import SwiftUI
import MusicKit
import AudioToolbox
import AVFoundation


struct SongInfoView: View {
    @Environment(\.presentationMode) var presentation
    var songItem: Song
    
    @State var cotain2flag: Bool = false
    
    @EnvironmentObject var timeManager: TimeManager

    var body: some View {
        Section {
            HStack {
                ZStack {
                    if let artwork = songItem.artwork {
                        ArtworkImage(artwork, height: 70)
                            .cornerRadius(5)
                    }
                    if self.timeManager.isRoadingAppleMusic {
                        ProgressView()
                    }
                }
                .frame(width: 70, height: 70)
                VStack {
                    HStack {
                        Text(songItem.title)
                        Spacer()
                    }
                    HStack {
                        Text("\(songItem.artistName) \(songItem.albumTitle ?? "")")
                            .foregroundColor(Color.gray)
                            .font(.subheadline)
                        Spacer()
                    }
                }
                Spacer()
                Button(action: {
                    updateAppleMusicList()
                    self.timeManager.soundID = SystemSoundID(100)               //TODO: - なんとかしよう
                    self.timeManager.appleMusicSelectedID = songItem.id
                    self.timeManager.soundName = songItem.title
                    self.timeManager.appleMusic = songItem
                    //self.timeManager.setTimer()
                    presentation.wrappedValue.dismiss()
                }){
                    Image(systemName: "plus.circle")
                        .resizable()
                        .foregroundColor(.blue)
                        .font(.title3)
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
        }
    }
    
    func updateAppleMusicList() {
        debugList()
        if self.timeManager.appleMusicSelectedList.count >= 5 && self.cotain2flag { //リストの最大値は5
            self.timeManager.appleMusicSelectedList.remove(at: 0)
        }
        if self.cotain2flag {  // 重複回避
            self.timeManager.appleMusicSelectedList.append(songItem)
        }
        saveAppleMusicList(appleMusicList: self.timeManager.appleMusicSelectedList)
        //print(self.timeManager.appleMusicSelectedList)
        
    }
    
    func debugList() {
        for num in 0..<self.timeManager.appleMusicSelectedList.count {
            if songItem.id == self.timeManager.appleMusicSelectedList[num].id {
                self.cotain2flag = false
                return
            }
        }
        self.cotain2flag = true
    }
    
    func saveAppleMusicList(appleMusicList: [Song]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(appleMusicList) else {
            print("😭: appleMusicListの保存に失敗しました。")
            return
        }
        UserDefaults.standard.set(data, forKey: "appleMusicList")
        print("😄👍: appleMusicListの保存に成功しました。")
    }

}
