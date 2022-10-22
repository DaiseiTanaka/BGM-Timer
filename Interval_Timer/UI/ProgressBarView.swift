//
//  ProgressBarView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/23.
//

import SwiftUI
import Neumorphic


struct ProgressBarView: View {
    @EnvironmentObject var timeManager: TimeManager

    @State var costomHueA = 0.4
    @State var costomHueB = 0.1
    @State var costomHueRunningA = 0.4
    @State var costomHueRunningB = 0.1
    private var strokeLineWidth: CGFloat = 20
    private var strokeLineWidthPad: CGFloat = 20

    var body: some View {
        ZStack {
            if UIDevice.current.userInterfaceIdiom == .pad {
                ForEach((0 ..< self.timeManager.taskList.count), id: \.self) { num in
                    Circle()
                        .trim(from: CGFloat(self.timeManager.timeList.suffix(num).reduce(0, +)) / CGFloat(self.timeManager.timeSum) + 0.01, to: CGFloat(self.timeManager.timeList.suffix(num + 1).reduce(0, +)) / CGFloat(self.timeManager.timeSum) - 0.01)
                        .stroke(Color(.darkGray), style: StrokeStyle(lineWidth: strokeLineWidthPad, lineCap: .round, lineJoin: .round))
                        .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.height*0.8, alignment: .center)
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: -90))
                        .padding(15)
                        .opacity(0.2)
                }
                Circle()
                    .trim(from: 0.01, to: (CGFloat(self.timeManager.timeSumDuration)) / (CGFloat(self.timeManager.timeSum )) - 0.01)
                    .stroke(self.makeGradientColor(hueA: costomHueA , hueB: costomHueB), style: StrokeStyle(lineWidth: strokeLineWidthPad, lineCap: .round, lineJoin: .round))
                    .frame(width: UIScreen.main.bounds.width*0.8, height: UIScreen.main.bounds.height*0.8, alignment: .center)
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: -90))
                    .padding(15)
                    .opacity(0.37)
            } else {
                ForEach((0 ..< self.timeManager.taskList.count), id: \.self) { num in
                    Circle()
                        .trim(from: CGFloat(self.timeManager.timeList.suffix(num).reduce(0, +)) / CGFloat(self.timeManager.timeSum) + 0.01, to: CGFloat(self.timeManager.timeList.suffix(num + 1).reduce(0, +)) / CGFloat(self.timeManager.timeSum) - 0.01)
                        .stroke(Color(UIColor.systemGray), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round, lineJoin: .round))
                        .scaledToFit()
                        .rotationEffect(Angle(degrees: -90))
                        .padding(15)
                        .opacity(0.3)
                        //.animation(.easeInOut(duration: 0.20), value: self.timeManager.pageIndex)

                }
                Circle()
                    .trim(from: 0.01, to: (CGFloat(self.timeManager.timeSumDuration)) / (CGFloat(self.timeManager.timeSum )) - 0.01)
                    .stroke(self.makeGradientColor(hueA: costomHueA , hueB: costomHueB), style: StrokeStyle(lineWidth: strokeLineWidth, lineCap: .round, lineJoin: .round))
                    .scaledToFit()
                    .rotationEffect(Angle(degrees: -90))
                    .padding(15)
                    .opacity(0.37)
                    .animation(.easeInOut(duration: 0.20), value: self.timeManager.intervalCount)
                    .animation(.easeInOut(duration: 0.20), value: self.timeManager.pageIndex)
            }
        }
        //毎0.05秒ごとに発動
        .onReceive(timeManager.timer) { _ in

            if self.timeManager.timerStatus == .stopped {
//                self.costomHueA += 0.0025
//                self.costomHueB += 0.005
                self.costomHueA += 0.0050
                self.costomHueB += 0.0075
                self.costomHueRunningA = 0.0
                self.costomHueRunningB = 0.0
            } else if self.timeManager.timerStatus == .running {
                if self.timeManager.duration < 5 {
                    self.costomHueRunningA += 0.05
                    self.costomHueRunningB += 0.05
                } else {
                    self.costomHueRunningA += CGFloat( 0.05 / self.timeManager.maxValue)
                    self.costomHueRunningB += CGFloat( 0.05 / self.timeManager.maxValue)
                }
                self.costomHueA = costomHueRunningA
                self.costomHueB = costomHueRunningB
            }
            //print(costomHueA, costomHueB)
            if self.costomHueA >= 1.0 {
                self.costomHueA = 0.0
                self.costomHueRunningA = 0.0
            }
            if self.costomHueB >= 1.0 {
                self.costomHueB = 0.0
                self.costomHueRunningB = 0.0
            }
        }
    }

    
    func makeGradientColor(hueA: Double, hueB: Double) -> AngularGradient {
        let colorA = Color(hue: hueA, saturation: 0.75, brightness: 0.9)
        let colorB = Color(hue: hueB, saturation: 0.75, brightness: 0.9)
        let gradient = AngularGradient(gradient: .init(colors: [colorA, colorB, colorA]), center: .center, startAngle: .zero, endAngle: .init(degrees: 360))
        return gradient
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
    }
}
