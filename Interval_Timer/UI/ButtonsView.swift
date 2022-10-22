//
//  ButtonsView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/18.
//

import SwiftUI
import Neumorphic


struct ButtonsView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    @Environment(\.colorScheme) var colorScheme  //ダークモードかライトモードか検出
    
    var body: some View {
        HStack {
            Button(action: {
                self.timeManager.reset()
                self.timeManager.setTimer()
                self.timeManager.show = false
            }) {
                Image(systemName: "stop.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .opacity((self.timeManager.timerStatus == .stopped && self.timeManager.intervalCount == 0 && self.timeManager.show != true) ? 0.1 : 1)
            }.softButtonStyle(Circle(), darkShadowColor: colorScheme == .light ? Color.gray.opacity(0.3) : Color.black.opacity(0.2), lightShadowColor: colorScheme == .light ?  Color.white : Color.black.opacity(0.1), pressedEffect: .hard)
                .padding(.leading, 15)

//            Image(systemName: "stop.circle")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 65, height: 65)
//                .padding(.leading, 20)
//                .opacity((self.timeManager.timerStatus == .stopped && self.timeManager.intervalCount == 0 && self.timeManager.show != true) ? 0.1 : 1)
//                .onTapGesture {
//                    print(self.timeManager.timerStatus)
//                    self.timeManager.reset()
//                    self.timeManager.setTimer()
//                    self.timeManager.show = false
//                }
            
            Spacer()
            
            Button(action: {
                if self.timeManager.timeSumDuration > 0.1 {
                    print("ButtonsView", self.timeManager.timerStatus)
                    if timeManager.duration != 0 {
                        if timeManager.timerStatus == .stopped && timeManager.intervalCount == 0 {
                            self.timeManager.restart()
                        }
                        else if timeManager.duration != 0 && timeManager.timerStatus != .running {
                            self.timeManager.start()
                        }
                        else if timeManager.timerStatus == .running {
                            self.timeManager.pause()
                        }
                    }
                }
            }) {
                Image(systemName: self.timeManager.timerStatus == .running ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 35, height: 35)
                    .padding(.leading, self.timeManager.timerStatus == .running ? 0 : 5)
                    .opacity(self.timeManager.timerStatus == .stopped && self.timeManager.timeSumDuration < 0.1 ? 0.1 : 1)
            }.softButtonStyle(Circle(), darkShadowColor: colorScheme == .light ? Color.gray.opacity(0.3) : Color.black.opacity(0.2), lightShadowColor: colorScheme == .light ?  Color.white : Color.black.opacity(0.1), pressedEffect: .hard)
                .padding(.trailing, 15)
            
            
            
//            Image(systemName: self.timeManager.timerStatus == .running ? "pause.circle" : "play.circle")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 65, height: 65)
//                .padding(.trailing, 20)
//                .opacity(self.timeManager.timerStatus == .stopped && self.timeManager.timeSumDuration < 0.1 ? 0.1 : 1)
//                .onTapGesture {
//                    if self.timeManager.timeSumDuration > 0.1 {
//                        print("ButtonsView", self.timeManager.timerStatus)
//                        if timeManager.duration != 0 {
//                            if timeManager.timerStatus == .stopped && timeManager.intervalCount == 0 {
//                                self.timeManager.restart()
//                            }
//                            else if timeManager.duration != 0 && timeManager.timerStatus != .running {
//                                self.timeManager.start()
//                            }
//                            else if timeManager.timerStatus == .running {
//                                self.timeManager.pause()
//                            }
//                        }
//                    }
//                }
            
        }
        .animation(.default, value: self.timeManager.timerStatus)

    }
}

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimeManager())
//        ButtonsView()
//            .environmentObject(TimeManager())
//            .previewLayout(.sizeThatFits)
    }
}
