//
//  CardViewTest.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/26.
//

import SwiftUI

struct PhotosView<T: View>: View {
    private let width: CGFloat
    private let height: CGFloat
    private let content: () -> T

    init(width: CGFloat, height: CGFloat, @ViewBuilder content: @escaping () -> T) {
        self.width = width
        self.height = height
        self.content = content
    }
    var body: some View {
        TabView {
            content()
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .interactive))
        .frame(width: width, height: height)
        .background(Color(UIColor.secondarySystemFill))
    }
}

struct Content1View: View {
    var body: some View {
        PhotosView(width: 350, height: 250) {
            ForEach(0..<3) { index in
                Text("\(index)")
                    //.resizable()
                    //.scaledToFit()
            }
        }
        .cornerRadius(10)
    }
}

struct Content1View_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Content1View()
        }
    }
}
