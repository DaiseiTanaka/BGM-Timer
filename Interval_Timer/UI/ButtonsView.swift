//
//  ButtonsView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/18.
//

import SwiftUI

struct ButtonsView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    var body: some View {
        HStack {
            Image(systemName: "stop.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 65, height: 65)
                .padding(.leading, 20)
                .opacity((self.timeManager.timerStatus == .stopped && self.timeManager.intervalCount == 0 && self.timeManager.show != true) ? 0.1 : 1)
                .onTapGesture {
                    print(self.timeManager.timerStatus)
                    self.timeManager.reset()
                    self.timeManager.setTimer()
                    self.timeManager.show = false
                }
            
            Spacer()
            
            Image(systemName: self.timeManager.timerStatus == .running ? "pause.circle" : "play.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 65, height: 65)
                .padding(.trailing, 20)
                .opacity(self.timeManager.timerStatus == .stopped && self.timeManager.timeSumDuration < 0.1 ? 0.1 : 1)
                .onTapGesture {
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
                }
        }
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
