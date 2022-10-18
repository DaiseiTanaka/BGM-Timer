//
//  Scale.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/28.
//

import Foundation
import SwiftUI

//struct SizePreferenceKey: PreferenceKey {
//    typealias Value = [SizePreferenceData]
//    static var defaultValue: [SizePreferenceData] = []
//    static func reduce(value: inout [SizePreferenceData], nextValue: () -> [SizePreferenceData]) {
//        value.append(contentsOf: nextValue())
//    }
//}
//
//struct SizePreferenceSetter: View {
//    let sizeName: String
//    var body: some View {
//        GeometryReader { geom in
//            Color.clear
//                .preference(key: SizePreferenceKey.self, value: [SizePreferenceData(name: sizeName, size: geom.size)])
//        }
//    }
//}
//
//struct Scale: ViewModifier {
//    let size: CGSize
//    
//    @State var horizontalScale: CGFloat = 1.0
//    @State var verticallScale: CGFloat = 1.0
//
//    public init(_ width: CGFloat = -1,_ height: CGFloat = -1) {
//        self.size = CGSize(width: width, height: height)
//    }
//    
//    func body(content: Content) -> some View {
//        content
//            .background(SizePreferenceSetter(sizeName: "targetSize"))
//            .scaleEffect(CGSize(width: min(1.0, horizontalScale), height: min(1.0, verticallScale)))
//            .onPreferenceChange(SizePreferenceKey.self, perform: { prefs in
//                for pref in prefs {
//                    if pref.name == "targetSize" {
//                        self.horizontalScale = self.size.width == -1 ? 1.0 : self.size.width / pref.size.width
//                        self.verticallScale = self.size.height == -1 ? 1.0 : self.size.height / pref.size.height
//                    }
//                }
//            })
//    }
//}
