//
//  SongListView.swift
//  AppleMusic_Test
//
//  Created by 田中大誓 on 2022/11/05.
//

//import SwiftUI
//import MediaPlayer
//
//struct SongListView: View {
//    @ObservedObject var userSelection: UserSelection
//    
//    var body: some View {
//        Group {
//            if userSelection.playlist != nil {
//                List {
//                    ForEach(userSelection.playlist!.items, id: \.self) {item in
//                        Text("\(item.title!)")
//                    }
//                }
//            } else {
//                EmptyView()
//            }
//        }
//    }
//}
//
//struct SongListView_Previews: PreviewProvider {
//    static var previews: some View {
//        SongListView(userSelection: UserSelection())
//    }
//}
