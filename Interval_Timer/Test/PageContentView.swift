//
//  PageContentView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/10/01.
//
import SwiftUI

struct PageContentView: View {

    @Binding var selection: Int
    let items: [String]

    var body: some View {
        TabView(selection: $selection) {
            ForEach(items.indices, id: \.self) { index in
                Text(items.reversed()[index])
                    .tag(index)
            }
        }
        .background(Color.gray.opacity(0.1))
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.linear(duration: 0.3))   // Tab タップされたときもページングさせたい
        .onAppear {
            selection = items.count - 1
        }
    }
}
