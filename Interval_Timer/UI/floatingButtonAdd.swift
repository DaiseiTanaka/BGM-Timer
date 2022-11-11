//
//  floatingButtonAdd.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/26.
//

import Foundation
import SwiftUI
import MusicKit

struct FloatingButtonAdd: View, AddDetailToListDelegate, InputViewDelegate {
    @EnvironmentObject var timeManager: TimeManager

    func addDetailToList(task: String, bgmName: String, alarmID: Int, time: Int, min: Int, sec: Int, myListIndex: Int, appleMusic: Song?) {}
    
    func addTodo(task: String, time: Int, sound: String, finSound: Int, min: Int, sec: Int, appleMusic: Song?) {}
    
    @State private var showAddView: Bool = false

    var body: some View {
        VStack {  // --- 1
            Spacer()
            HStack { // --- 2
                Spacer()
//                Button(action: {
//                    print("Tapped!!") // --- 3
//                    self.showAddView.toggle()
//
//                }, label: {
//                    Image(systemName: "plus.circle.fill")
//                        //.foregroundColor(.white)
//                        .font(.system(size: 40)) // --- 4
//                })
//                    .frame(width: 39, height: 39)
//                    .background(Color.white)
//                    .cornerRadius(20.0)
//                    .shadow(color: .gray, radius: 3, x: 3, y: 3)
//                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 50.0, trailing: 0)) // --- 5
//                    .sheet(isPresented: self.$showAddView) {
//                        InputView(inputDelegate: self, addDetailToListDelegate: self, task: "", sound: "", min: 0, sec: 0, myListIndex: self.timeManager.pageIndex)
//                    }
                NavigationLink(destination: InputView(inputDelegate: self, addDetailToListDelegate: self, task: "", sound: "", min: 0, sec: 0, myListIndex: self.timeManager.pageIndex, appleMusic: nil)) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .frame(width: 39, height: 39)
                            .background(Color.white)
                            .cornerRadius(20.0)
                            .shadow(color: .gray, radius: 3, x: 3, y: 3)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 50.0, trailing: 0))
                        Spacer()
                    }
                }
                Spacer()
            }
        }
    }
}
