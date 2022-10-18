//
//  ModalView.swift
//  My_Interval
//
//  Created by 田中大誓 on 2022/09/08.
//

import SwiftUI

struct ModalView: View {
    @EnvironmentObject var timeManager: TimeManager
    @Binding var isShowing: Bool
    
    @State private var isDragging = false
    //@State private var curHeight: CGFloat = UIScreen.main.bounds.height * 0.16
    let minHeight: CGFloat = UIScreen.main.bounds.height * 0.12
    let minHeightPad: CGFloat = UIScreen.main.bounds.height * 0.09
    let middleHeight: CGFloat = UIScreen.main.bounds.height * 0.38
    let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.9
    
    @State var viewHeight: CGFloat = UIScreen.main.bounds.height
    @State var viewWidth: CGFloat = UIScreen.main.bounds.width
    
    @State private var sideMenuOffset = CGFloat.zero
    @State private var closeOffset = CGFloat.zero
    @State private var openOffset = CGFloat.zero
    
    var body: some View {
        //GeometryReader { _ in
            ZStack(alignment: .bottom) {
                //VStack {
                if isShowing {
                    Color.black
                        .opacity(self.timeManager.curHeight > middleHeight ? CGFloat((self.timeManager.curHeight - middleHeight)/UIScreen.main.bounds.height) : 0.00000001)
                        .ignoresSafeArea()
                        .gesture(dragGesture)
                        //.animation(.easeInOut, value: self.timeManager.curHeight)
                                        
                    mainView
                        .transition(.move(edge: .bottom))

                }
            }
            .onAppear{
                timeManager.curHeight = minHeight
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea()
            //MARK: - Animation
            .animation(.easeInOut(duration: 0.20))
            //.animation(isDragging ? nil : .easeInOut(duration: 0.20), value: self.timeManager.curHeight)  // modal viewの上下のアニメーション速度
       // }
    }
    
    var mainView: some View {
        ZStack(alignment: .topLeading) {
                VStack {
                        
                        ZStack {
                            HStack {
                                Button(action: {
                                    if self.timeManager.intervalCount != 0 {
                                        self.timeManager.intervalCount -= 1
                                        self.timeManager.setTimer()
                                    }
                                }) {
                                    VStack {
                                        Image(systemName: self.timeManager.curHeight < maxHeight ? "chevron.backward.circle" : "chevron.up.circle")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .opacity(self.timeManager.intervalCount == 0 ? 0.1 : 1)
                                    }
                                    .frame(width: 70, height: 65)
                                }
                                
                                VStack {
                                    Capsule()
                                        .frame(width: 60, height: 3)
                                        .foregroundColor(Color(UIColor.systemGray3))
                                        .padding(.top, 10)
                                    Spacer()
                                }
                                
                                Button(action: {
                                    if self.timeManager.intervalCount != self.timeManager.taskList.count - 1 || self.timeManager.taskList.count == 0 {
                                        self.timeManager.intervalCount += 1
                                        self.timeManager.setTimer()
                                    }
                                    
                                }) {
                                    VStack {
                                        Image(systemName: self.timeManager.curHeight < maxHeight ? "chevron.forward.circle" : "chevron.down.circle")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .opacity(self.timeManager.intervalCount == self.timeManager.taskList.count - 1 || self.timeManager.taskList.count == 0 ? 0.1 : 1)
                                    }
                                    .frame(width: 70, height: 65)
                                }
                                .cornerRadius(10)
                            }
                            
                            if UIDevice.current.orientation.isPortrait && UIDevice.current.userInterfaceIdiom == .pad {
                                ButtonsView()
                            } else {
                                ButtonsView()
                            }
                        }
                        .frame(height: 90)
                        .frame(maxWidth: .infinity)

                        IntervalListView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: timeManager.curHeight)
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .shadow(color: Color(UIColor.gray).opacity(0.5), radius: 3, x: 0, y: -0.5)
                        //                    Rectangle()
                        //                        .frame(height: 40)
                        //                        .ignoresSafeArea()
                        //                        .background(Color(UIColor.systemGray6))
                    }
                        .gesture(dragGesture)
                        .foregroundColor(Color(UIColor.systemGray6))
                    
                )
                //MARK: - Animation
                //.animation(isDragging ? nil : .easeInOut(duration: 0.15), value: self.timeManager.curHeight)
                //.animation(isDragging ? nil : .easeInOut(duration: 0.20), value: self.timeManager.curHeight)  // modal viewの上下のアニメーション速度
        }
    }
    
    @State private var prevDragTranslation = CGSize.zero
    @State private var prevStableHeight = CGFloat.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    isDragging = true
                }
                let dragAmount = val.translation.height - prevDragTranslation.height
                if timeManager.curHeight > maxHeight {
                    timeManager.curHeight -= dragAmount / 6
                } else if timeManager.curHeight < minHeight {
                    timeManager.curHeight -= dragAmount / 20
                } else {
                    timeManager.curHeight -= dragAmount
                }
                
                prevDragTranslation = val.translation
            }
            .onEnded { val in
                prevDragTranslation = .zero
                isDragging = false
                
                if timeManager.curHeight != minHeight && timeManager.curHeight != middleHeight && timeManager.curHeight != maxHeight {
                    if prevStableHeight == minHeight {
                        if timeManager.curHeight > minHeight {
                            timeManager.curHeight = middleHeight
                        }
                    } else if prevStableHeight == middleHeight {
                        if timeManager.curHeight < middleHeight {
                            timeManager.curHeight = minHeight
                        } else if timeManager.curHeight >= middleHeight {
                            timeManager.curHeight = maxHeight
                        }
                    } else if prevStableHeight == maxHeight {
                        if timeManager.curHeight < maxHeight {
                            timeManager.curHeight = middleHeight
                        }
                    }
                    
                    if timeManager.curHeight > maxHeight || timeManager.curHeight > (maxHeight + middleHeight) / 2 {
                        timeManager.curHeight = maxHeight
                    }
                    else if timeManager.curHeight < minHeight || timeManager.curHeight < (minHeight + middleHeight) / 2{
                        timeManager.curHeight = minHeight
                    }
                    else if timeManager.curHeight <= (maxHeight + middleHeight) / 2 || timeManager.curHeight >= (minHeight + middleHeight) / 2 {
                        timeManager.curHeight = middleHeight
                    }
                    
                }
                else {
                    if timeManager.curHeight == minHeight {
                        timeManager.curHeight = maxHeight
                    } else {
                        timeManager.curHeight = minHeight
                    }
                }
                
                prevStableHeight = timeManager.curHeight
            }
    }
}

struct ModalView_PreviewProVider: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TimeManager())
        //ModalView(isShowing: .constant(true))
    }
}
