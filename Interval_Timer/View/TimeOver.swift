//
//  TimeOver.swift
//  Qiita_Timer
//
//  Created by 田中大誓 on 2022/08/18.
//

import SwiftUI
import UIKit
import AudioToolbox
import AVFoundation

struct TimeOverView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    @State var costomHueA = 0.4
    @State var costomHueB = 0.1
    @State var costomHueRunningA = 0.4
    @State var costomHueRunningB = 0.1
    
    var body: some View {
        ZStack {
//            Image("fire3")
//                .resizable()
            
//            if UIDevice.current.userInterfaceIdiom == .pad {
////                Image("bang2")
////                    .resizable()
////                    .clipShape(Circle())
////                    .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.height*0.8, alignment: .center)
////                    .padding(15)
//                Circle()
//                    .stroke(self.makeGradientColor(hueA: costomHueA , hueB: costomHueB), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
//                    .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.height*0.8, alignment: .center)
//                    .padding(15)
//            } else {
////                Image("bang2")
////                    .resizable()
////                    .clipShape(Circle())
////                    .padding(15)
//                Circle()
//                    .stroke(self.makeGradientColor(hueA: costomHueA , hueB: costomHueB), style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
//                    .scaledToFit()
//                    .padding(15)
//            }
            
            VStack {
                //Image("fire")
                Spacer()
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Text("Finish!")
                        .font(.system(size: 100, weight: .black, design: .default))
                        //.foregroundColor(Color.black)
                        .fontWeight(.heavy)
                } else {
                    Text("Finish!")
                        .font(.system(size: 80, weight: .black, design: .default))
                        //.foregroundColor(Color.black)
                        .fontWeight(.heavy)
                }
                
                
                //Spacer(minLength: UIScreen.main.bounds.height * 0.5)

                Spacer()
            }
        }
        .onDisappear {
            self.timeManager.show = false
        }
        //毎0.05秒ごとに発動
//        .onReceive(timeManager.timer) { _ in
//            if self.timeManager.timerStatus == .stopped {
//                self.costomHueA += 0.0025
//                self.costomHueB += 0.005
//                self.costomHueRunningA = 0.0
//                self.costomHueRunningB = 0.0
//            } else {
//                if self.timeManager.duration < 5 {
//                    self.costomHueRunningA += 0.05
//                    self.costomHueRunningB += 0.05
//                } else {
//                    self.costomHueRunningA += CGFloat( 0.05 / self.timeManager.maxValue)
//                    self.costomHueRunningB += CGFloat( 0.05 / self.timeManager.maxValue)
//                }
//                self.costomHueA = costomHueRunningA
//                self.costomHueB = costomHueRunningB
//            }
//            //print(costomHueA, costomHueB)
//            if self.costomHueA >= 1.0 {
//                self.costomHueA = 0.0
//                self.costomHueRunningA = 0.0
//            }
//            if self.costomHueB >= 1.0 {
//                self.costomHueB = 0.0
//                self.costomHueRunningB = 0.0
//            }
//        }
    }
//    func makeGradientColor(hueA: Double, hueB: Double) -> AngularGradient {
//        let colorA = Color(hue: hueA, saturation: 0.75, brightness: 0.9)
//        let colorB = Color(hue: hueB, saturation: 0.75, brightness: 0.9)
//        let gradient = AngularGradient(gradient: .init(colors: [colorA, colorB, colorA]), center: .center, startAngle: .zero, endAngle: .init(degrees: 360))
//        return gradient
//    }
    
}

struct TimeOverViewPrevios: PreviewProvider {
    static var previews: some View {
        TimeOverView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
        
    }
}
