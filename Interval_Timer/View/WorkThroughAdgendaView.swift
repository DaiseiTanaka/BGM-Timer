//
//  WorkThroughAdgendaView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/10/10.
//

import Foundation
import SwiftUI

struct WorkThroughAdgendaView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var timeManager: TimeManager
    
    @State var showWorkThroughView: Bool = false
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    private var adgendas: [String] = [
        "初めに",
        "ホーム画面について",
        "タイマーの追加方法について",
        "タイマーの編集方法について",
        "マイリストの追加方法について",
        "マイリストの削除方法について",
        "リストの編集方法について"
    ]
    
    private var adgendaIndex: [Int] = [0, 1, 8, 10, 12, 15, 19]

    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Section(header: Text("contents")) {
                        ForEach(Array(adgendas.enumerated()), id: \.element) { index, element in
                            HStack {
                                Text("\(index+1):   \(element)")
                                    .contentShape(Rectangle())
                                    .font(.subheadline)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                self.timeManager.workThroughPageIndex = adgendaIndex[index]
                                self.showWorkThroughView = true
                            }
                        }
                    }
                }
            }
            .sheet (isPresented: self.$showWorkThroughView) {
                WorkThroughView()
            }
            //.background(.white)
            .navigationBarTitleDisplayMode(.automatic)
            .navigationTitle("Tutorial")
            .navigationBarItems(
                trailing:
                    Text("Close")
                    .padding(.leading, 10)
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                    .onTapGesture{
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                        presentation.wrappedValue.dismiss()
                    })
        }
        .navigationViewStyle(.stack)
    }
}

struct WorkThroughAdgendaView_Previews: PreviewProvider {
    static var previews: some View {
        WorkThroughAdgendaView().environmentObject(TimeManager())
    }
}

