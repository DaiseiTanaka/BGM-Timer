//
//  TimerView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/16.
//

import SwiftUI

struct TimerView: View {

    @EnvironmentObject var timeManager: TimeManager
    @State var costomHueA = 0.4
    @State var costomHueB = 0.1
    @State var costomHueRunningA = 0.4
    @State var costomHueRunningB = 0.1

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            //時間表示形式が時間、分、秒によって、タイマーの文字サイズを条件分岐させる
            //表示形式が"時間"の場合
            if self.timeManager.displayedTimeFormat == .hr {
                Text(self.timeManager.displayTimer())
                //文字サイズをスクリーンサイズ x 0.15に指定
                    .font(.system(size: self.screenWidth * 0.15, weight: .thin, design: .monospaced))
                //念の為、行数を1行に指定
                    .lineLimit(1)
                //デフォルトの余白を追加
                    .padding()
                
                //表示形式が"分"の場合
            } else if self.timeManager.displayedTimeFormat == .min && self.timeManager.duration > 59 {
                let m =  self.screenWidth * 0.23 + 25 * (Double(self.timeManager.duration).truncatingRemainder(dividingBy: 1))
                if self.timeManager.duration > 10 {
                    Text(self.timeManager.displayTimer())
                        //.font(.custom("DBLCDTempBlack", size: self.screenWidth * 0.23))
                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: self.screenWidth * 0.23, weight: .regular)))
                        //.font(.system(size:self.screenWidth * 0.23))
                        .lineLimit(1)
                        .padding()
                        .foregroundColor(Color(UIColor.systemGray))
                } else {
                    Text(self.timeManager.displayTimer())
                        //.font(.custom("DBLCDTempBlack", size: m))
                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: m, weight: .regular)))
                        //.font(.system(size: m))
                        .lineLimit(1)
                        .padding()
                        .foregroundColor(Color.red)
                }
                
                //表示形式が"秒"の場合
            } else {
                let s =  self.screenWidth * 0.4 + 25 * (Double(self.timeManager.duration).truncatingRemainder(dividingBy: 1))

                if self.timeManager.duration > 10 {
                    Text(self.timeManager.displayTimer())
//                        .font(.system(size: self.screenWidth * 0.5, weight: .thin, design: .monospaced))
                        //.font(.custom("DBLCDTempBlack", size: self.screenWidth * 0.4))
                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: self.screenWidth * 0.4, weight: .regular)))
                        //.font(.system(size: self.screenWidth * 0.4))
                        //.fontWeight(.thin)
                        .lineLimit(1)
                        .padding()
                        .foregroundColor(Color(UIColor.systemGray))
                } else {
                    Text(self.timeManager.displayTimer())
//                        .font(.system(size: self.screenWidth * 0.5 + 80 * (Double(self.timeManager.duration).truncatingRemainder(dividingBy: 1)), weight: .thin, design: .monospaced))
                        //.font(.custom("DBLCDTempBlack", size: s))
                        //.font(.system(size: s))
                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: s, weight: .regular)))
                        //.fontWeight(.thin)
                        .lineLimit(1)
                        .padding()
                        .foregroundColor(Color.red)
                    //.opacity(Double(13 * self.timeManager.duration / self.timeManager.maxValue).truncatingRemainder(dividingBy: 1) + 0.1)
                }
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
    }
}

