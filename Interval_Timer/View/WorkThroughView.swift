//
//  WorkThroughView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/10/03.
//

import Foundation
import SwiftUI

struct WorkThroughView: View {
    @Environment(\.presentationMode) var presentation
    @EnvironmentObject var timeManager: TimeManager

    @State var pageIndex: Int = 0
    //@State var pageIndex: Int

    @State var progress: CGFloat = 0.0
    
    private var images: [[String]] = [
        ["work_homeView", "BGMタイマーへようこそ！", "　BGMタイマーをダウンロードいただき誠にありがとうございます! ここでは、このアプリの使い方について紹介します。"],
        ["work_home1", "ホーム画面について1", "　まずはホーム画面についてです。ホーム画面には、リセットボタン、スキップボタン、ストップボタンの３つがあります。"],
        ["work_home2", "ホーム画面について2", "　下から画面をスクロール、またはホーム画面をタップすることでも、スケジュール画面を表示することもできます。"],
        ["work_home3", "ホーム画面について3", "　スクロールを中間地点で止めた状態です。リストを確認しながらタスクを実行できます。"],
        ["work_home4", "ホーム画面について4", "　スケジュール画面です。この画面では、リストの確認・追加・編集・削除、さらにマイリストの作成・削除ができます。"],
        ["work_home5", "ホーム画面について5", "スケジュール画面を閉じる方法： \n・同様に上から下に画面上部をスクロール \n・暗くなっている背景をタップ"],
        ["work_home6", "ホーム画面について6", "　中間地点で止めることもできます。"],
        ["work_home7", "ホーム画面について7", "　これでホーム画面の説明を終わります。"],
        ["work_add1", "タイマーの追加方法について1", "　タイマーを追加するにはスケジュール画面下部の+ボタンをタップします。"],
        ["work_add2", "タイマーの追加方法について2", "・BGM（このタイマー実行中に継続して流れます）\n ・アラーム（このタイマーが終了した際に1度だけ鳴ります）"],
        ["work_edit1", "タイマーの編集方法について1", "　タイマーの編集をする場合はスケジュール画面の、編集したいタイマーをタップします。"],
        ["work_edit2", "タイマーの編集方法について2", "　この画面で、タイマーの詳細を編集できます。"],
        ["work_list_add1", "マイリストの追加方法について1", "　'マイリスト'とは、よく使うリストのことで、あなたがいつでも作成・削除することができます。まず初めにスケジュール画面の左上のボタンをタップします。"],
        ["work_list_add2", "マイリストの追加方法について2", "　左側にマイリスト画面が表示されます。画面下にある+ボタンをタップします。"],
        ["work_list_add3", "マイリストの追加方法について3", "　新しい空のリストが作成されました。灰色になっているものが、今スケジュール画面に表示されているリストです。リストをタップして実行できます。"],
        ["work_list_delete1", "マイリストの削除方法について1", "　スケジュール画面から左上のボタンをタップします。"],
        ["work_list_delete2", "マイリストの削除方法について2", "　削除したいリストを右から左にスワイプします。"],
        ["work_list_delete3", "マイリストの削除方法について3", "　deleteボタンが表示されるのでタップします。"],
        ["work_list_delete4", "マイリストの削除方法について4", "　これでリストの削除ができました。削除されたリストは復元できないので注意してください。"],
        ["work_list_edit1", "リストの編集方法について1", "　タイマーを削除、または並び替えをしたい場合は、スケジュール画面の右上のEditをタップします。"],
        ["work_list_edit2", "リストの編集方法について2", "　各タイマーの左に削除ボタン、右側にバーが表示され、リストの削除・並び替えができます。"],
        ["work_list_edit3", "リストの編集方法について3", "　リストの編集が終わったら、スケジュール画面の右上のDone（完了）をタップします。"],
        ["work_finish2", "FINISH!", "　これでBGMタイマーのチュートリアルを終了します。このチュートリアルはスケジュール画面の'?'からいつでも確認できます。\n　これからもBGMタイマーをよろしくお願いします！"]
        
    ]
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.darkGray]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $pageIndex) {
                    ForEach(0..<images.count) { num in
                        ScrollView (.vertical) {
                            VStack {
                                Image(images[num][0])
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.6)
                                    .ignoresSafeArea()
                                    .padding(.top, 10)
                                
                                Text(images[num][2])
                                    .font(.headline)
                                    .padding(.horizontal, 20)
                                    .padding(.top)
                                    .background(.white)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .frame(height: UIScreen.main.bounds.height)
                            
                        }
                        .onAppear {
                            progress = CGFloat(pageIndex)
                        }
                        .onDisappear {
                            progress = CGFloat(pageIndex)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                
                VStack {
                    ProgressBar(progress: $progress)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        HStack {
                            Image(systemName: "arrowshape.left.fill")
                                .foregroundColor(.black)
                                .opacity(pageIndex != 0 ? 1.0 : 0.0)
                            Text(pageIndex != 0 ? images[pageIndex-1][1] : "")
                                .font(.caption)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.leading)
                        .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                        .background(Color(UIColor.white).opacity(0.9))
                        .onTapGesture {
                            if pageIndex != 0 {
                                pageIndex -= 1
                            }
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Text(pageIndex != images.count - 1 ? images[pageIndex+1][1] : "")
                                .font(.caption)
                                .foregroundColor(.black)
                            Image(systemName: "arrowshape.right.fill")
                                .foregroundColor(.black)
                                .opacity(pageIndex != images.count - 1 ? 1.0 : 0.0)
                        }
                        .padding(.trailing)
                        .frame(width: UIScreen.main.bounds.width / 2, height: 50)
                        .background(Color(UIColor.white).opacity(0.9))
                        .onTapGesture {
                            if pageIndex != images.count - 1 {
                                pageIndex += 1
                            }
                        }
                    }
                }
            }
            .background(.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("\(images[pageIndex][1])")
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
            .onAppear{
                self.timeManager.setTimer()
                self.pageIndex = self.timeManager.workThroughPageIndex
            }
            .onDisappear{
                self.timeManager.workThroughPageIndex = 0
            }
        }
    }
}

struct ProgressBar: View {
 
    @State var isShowing = false
    @Binding var progress: CGFloat
 
    var body: some View {
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray)
                    .opacity(0.1)
                    .frame(width: UIScreen.main.bounds.width - 20, height: 8.0)
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(width: self.isShowing ? (UIScreen.main.bounds.width - 20) * (self.progress / 22) : 0.0, height: 8.0)
                    .animation(.linear(duration: 0.6))
            }
            .onAppear {
                self.isShowing = true
            }
            .cornerRadius(4.0)
    }
}


struct WorkThroughView_Previews: PreviewProvider {
    static var previews: some View {
        WorkThroughView()
            .environmentObject(TimeManager())
    }
}
