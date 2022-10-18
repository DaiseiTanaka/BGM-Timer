//
//  PickerView.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/15.
//

import SwiftUI

struct PickerView: View {
    //TimeManagerのインスタンスを作成
    @EnvironmentObject var timeManager: TimeManager
    //デバイスのスクリーンの幅
    let screenWidth = UIScreen.main.bounds.width
    //デバイスのスクリーンの高さ
    let screenHeight = UIScreen.main.bounds.height
    //設定可能な時間単位の数値
    var hours = [Int](0..<24)
    //設定可能な分単位の数値
    var minutes = [Int](0..<60)
    //設定可能な秒単位の数値
    var seconds = [Int](0..<60)
    
    var body: some View {
        //ZStackでPickerとレイヤーで重なるようにボタンを配置
        ZStack{
            VStack {
                
                //時間、分、秒のPickerとそれぞれの単位を示すテキストをHStackで横並びに
                HStack(spacing: 0) {
                    //時間単位のPicker
                    //                Picker(selection: self.$timeManager.hourSelection, label: Text("hour")) {
                    //                    ForEach(0 ..< self.hours.count) { index in
                    //                        Text("\(self.hours[index])")
                    //                            .tag(index)
                    //                    }
                    //                }
                    //                //上下に回転するホイールスタイルを指定
                    //                .pickerStyle(WheelPickerStyle())
                    //                //ピッカーの幅をスクリーンサイズ x 0.1、高さをスクリーンサイズ x 0.4で指定
                    //                .frame(width: self.screenWidth * 0.1, height: self.screenWidth * 0.4)
                    //                //上のframeでクリップし、フレームからはみ出す部分は非表示にする
                    //                .clipped()
                    //                //時間単位を表すテキスト
                    //                Text("hour")
                    //                    .font(.headline)
                    
                    //分単位のPicker
                    Picker(selection: self.$timeManager.minSelection, label: Text("minute")) {
                        ForEach(0 ..< self.minutes.count) { index in
                            Text("\(self.minutes[index])")
                                .tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .compositingGroup()
                    .clipped(antialiased: true)
                    
                    //分単位を表すテキスト
                    Text("min")
                        .font(.headline)
                    
                    //秒単位のPicker
                    Picker(selection: self.$timeManager.secSelection, label: Text("second")) {
                        ForEach(0 ..< self.seconds.count) { index in
                            Text("\(self.seconds[index])")
                                .tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .compositingGroup()
                    .clipped(antialiased: true)
                    
                    //秒単位を表すテキスト
                    Text("sec")
                        .font(.headline)
                }
                .padding(.horizontal)
                //.frame(width: 300, height: 100, alignment: .center)
            }
        }
    }
}

// タップしてないところが動くのを防ぐ
extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric - 50, height: 160)
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
    }
}
