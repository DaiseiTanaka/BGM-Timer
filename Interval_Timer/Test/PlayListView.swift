//
//  PlayListView.swift
//  AppleMusic_Test
//
//  Created by 田中大誓 on 2022/11/05.
//

//import SwiftUI
//import MediaPlayer
//
//struct PlayListView: View {
//    @EnvironmentObject var appModel: AppModel
//    @ObservedObject var userSelection: UserSelection
//
//    var body: some View {
//        List(selection: $userSelection.playlist, content: {
//            ForEach(appModel.playlists, id: \.self) { item in
//                Text("\(item.name!)  \(item.count)")
//            }
//        })
//            .environment(\.editMode, .constant(.active))
//    }
//}
//
//struct PlayListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayListView(userSelection: UserSelection())
//    }
//}
