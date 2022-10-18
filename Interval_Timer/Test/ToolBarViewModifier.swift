//
//  ToolBarViewModifier.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/10/01.
//

import SwiftUI

struct ToolBarViewModifier: ViewModifier {
    
    @Binding var selection: Int
    let items: [String]
    private let tabButtonSize: CGSize = CGSize(width: 100.0, height: 44.0)
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                    } label: {
                        Image(systemName: "line.horizontal.3.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width:24.0, height: 32.0)
                            .foregroundColor(.gray)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24.0, height: 24.0)
                            .foregroundColor(.gray)
                    }
                }
                ToolbarItem(placement: .principal) {
                    GeometryReader { geometryProxy in
                        ScrollViewReader { scrollProxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: .zero) {
                                    Spacer()
                                        .frame(width: spacerWidth(geometryProxy.frame(in: .global).origin.x))
                                    ForEach(items.reversed().indices, id: \.self) { index in
                                        Button {
                                            selection = index
                                            withAnimation {
                                                scrollProxy.scrollTo(selection, anchor: .center)
                                            }
                                        } label: {
                                            if index == items.count - 1 {
                                                Image("02_Marunouchi")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 30.0, height: 30.0)
                                            } else {
                                                Text(items.reversed()[index])
                                                    .font(.subheadline)
                                                    .fontWeight(selection == index ? .semibold: .regular)
                                                    .foregroundColor(selection == index ? .primary: .gray)
                                                    .id(index)
                                            }
                                        }
                                        .frame(width: tabButtonSize.width, height: tabButtonSize.height)
                                    }
                                    Spacer()
                                        .frame(width: spacerWidth(geometryProxy.frame(in: .global).origin.x))
                                }
                                .onChange(of: selection) { _ in
                                    withAnimation {
                                        scrollProxy.scrollTo(selection, anchor: .center)
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
    }
    
    private func spacerWidth(_ viewOriginX: CGFloat) -> CGFloat {
        return (UIScreen.main.bounds.width - (viewOriginX * 2) - tabButtonSize.width) / 2
    }
}

