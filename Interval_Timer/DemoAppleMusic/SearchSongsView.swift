//
//  SearchSongsView.swift
//  MusicKit_Demo
//
//  Created by Shunzhe on 2022/01/22.
//

import SwiftUI
import MusicKit

struct SearchSongsView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    @State private var searchTerm: String = ""
    @State private var searchResultSongs: MusicItemCollection<Song> = []
    @State private var isPerformingSearch: Bool = false
    
    @State private var musicSubscription: MusicSubscription?
    private var resultLimit: Int = 10
    
    @State private var editting = false
    @FocusState  var isActive: Bool
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.gray)
                    TextField("Search term", text: $searchTerm,
                              onEditingChanged: { begin in
                        if begin {
                            self.editting = true    // 編集フラグをオン
                        } else {
                            self.editting = false   // 編集フラグをオフ
                        }
                    })
                    .focused($isActive)
                }
            }
            
            HStack {
                if isPerformingSearch {
                    ProgressView()
                        .padding(.trailing, 10)
                }
                
                Button("Perform search") {
                    Task {
                        /*
                         Here, we're searching for songs,
                         you can also modify the parameters to search for
                         artists, albums, or other types of data.
                         */
                        do {
                            if searchTerm != "" {
                                let request = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                                self.isPerformingSearch = true
                                let response = try await request.response()
                                self.isPerformingSearch = false
                                self.searchResultSongs = response.songs
                                UIApplication.shared.closeKeyboard()
                            }
                        } catch {
                            print(error.localizedDescription)
                            fatalError("Error")
                            // Have you created a token? Please refer to https://developer.apple.com/documentation/musickit/using-automatic-token-generation-for-apple-music-api
                            // If you cannot find this app within the Identifiers' list, try to add any entitlement in the Xcode project window (like `iCloud` or `Push notification`) so that Xcode can automatically create a provisioning profile for this app.
                        }
                    }
                }
                .disabled(!(musicSubscription?.canPlayCatalogContent ?? false) || isPerformingSearch)
            }
            
            ForEach(self.searchResultSongs) { song in
                SongInfoView(songItem: song)
                    .onTapGesture {
                        Task {
                            //ApplicationMusicPlayer.shared.queue = .init(for: [sound])
                            SystemMusicPlayer.shared.queue = .init(for: [song])

                            do {
                                self.timeManager.isRoadingAppleMusic = true
//                                try await ApplicationMusicPlayer.shared.prepareToPlay()
//                                try await ApplicationMusicPlayer.shared.play()
                                try await SystemMusicPlayer.shared.play()
                                self.timeManager.isRoadingAppleMusic = false
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
            }
            
        }
//        .simultaneousGesture(editting ? TapGesture().onEnded {
//            self.timeManager.setTimer()
//            UIApplication.shared.closeKeyboard()
//        } : nil)
        .task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                self.musicSubscription = subscription
            }
        }
        .onAppear {
            self.isActive = true
        }
        .onDisappear {
            Task {
                ApplicationMusicPlayer.shared.stop()
                SystemMusicPlayer.shared.stop()
                //                do {
                //                    try await ApplicationMusicPlayer.shared.stop()
                //                } catch {
                //                    print(error.localizedDescription)
                //                }
            }
        }
        
    }
    
}

