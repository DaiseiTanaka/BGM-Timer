//
//  IntervalListView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/08.
//

import SwiftUI
import AudioToolbox
import Neumorphic
import MusicKit

struct IntervalListView: View, InputViewDelegate, EditViewDelegate, AddDetailToListDelegate {
    @EnvironmentObject var timeManager: TimeManager
    @Environment(\.presentationMode) var presentation
    @Environment(\.colorScheme) var colorScheme  //ダークモードかライトモードか検出

    @State var viewHeight: CGFloat = UIScreen.main.bounds.height
    @State var viewWidth: CGFloat = UIScreen.main.bounds.width

    // Modal view height
    let minHeight: CGFloat = UIScreen.main.bounds.height * 0.10
    let middleHeight: CGFloat = UIScreen.main.bounds.height * 0.38
    let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.9

    // My list view
    @State private var showMyListView: Bool = false

    // Input or Edit View index
    @State private var showEditView: Bool = false
    @State private var editIndex: Int = 0
    @State private var showAddView: Bool = false

    // Alart
    @State private var presentAlert = false
    @State private var editting = false
    @FocusState  var isActive:Bool

    // Side menu
    @State private var sideMenuOffset = CGFloat.zero
    @State private var closeOffset = CGFloat.zero
    @State private var openOffset = CGFloat.zero

    // Edit Mode
    @State var editMode: EditMode = .inactive
    //@Environment(\.editMode) var editMode
    @State var refresh = UUID()


//    init() {
//        // Large Title Text Color
//        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
//        UITableView.appearance().backgroundColor = UIColor.clear
//        UITableView.appearance().separatorStyle = .singleLine
//        UITableView.appearance().separatorColor = UIColor.white.withAlphaComponent(0.6)
//        UITableViewCell.appearance().backgroundColor = .clear
//
//        UITableView.appearance().isScrollEnabled = false
//    }

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    VStack {
                        if self.timeManager.curHeight > middleHeight {
                            myListSegmentView
                                .padding(.top, 45)
                                .opacity(CGFloat(1-(maxHeight-self.timeManager.curHeight)/(maxHeight-middleHeight-200)))
                                .animation(.easeInOut, value: self.timeManager.curHeight)

                            timeScheduleList
                        } else {
                            timeScheduleListMiddle
                                .animation(.easeInOut, value: self.timeManager.timerStatus)
                        }

                        Spacer()
                    }
                    .animation(.easeInOut, value: self.timeManager.curHeight)
                    .simultaneousGesture(isActive == true ? TapGesture().onEnded {
                        self.timeManager.setTimer()
                        UIApplication.shared.closeKeyboard()
                    } : nil)
                    .ignoresSafeArea()


                    if self.timeManager.sideMenuOffset != self.closeOffset {
                        if colorScheme == .light {
                            Color.gray.opacity(
                                Double((self.closeOffset - self.timeManager.sideMenuOffset)/self.closeOffset) - 0.4
                            )
                            .onTapGesture {
                                self.timeManager.sideMenuOffset = self.closeOffset
                            }
                        } else {
                            Color.black.opacity(
                                Double((self.closeOffset - self.timeManager.sideMenuOffset)/self.closeOffset) - 0.4
                            )
                            .onTapGesture {
                                self.timeManager.sideMenuOffset = self.closeOffset
                            }
                        }
                    }

                    if self.timeManager.curHeight > middleHeight {
                        plusButton
                            .opacity(CGFloat(1-(maxHeight-self.timeManager.curHeight)/(maxHeight-middleHeight)))
                    }

                    MyListView()
                        //.backgroundClearSheet()
                        //.background(.ultraThinMaterial)
                        .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.7)
                        .onAppear(perform: {
                            self.timeManager.sideMenuOffset = UIScreen.main.bounds.width * -1
                            self.closeOffset = self.timeManager.sideMenuOffset
                            self.openOffset = .zero
                        })
                        .offset(x: self.timeManager.sideMenuOffset)
                        //MARK: - Animation
                        .animation(.easeInOut, value: self.timeManager.sideMenuOffset)

                }
                .animation(.easeInOut, value: editMode)  // editボタンを押したときのアニメーション
                .background(Color(UIColor.systemGray6))
                .sheet(isPresented: self.$showEditView) {
                    EditView(delegate: self, task: self.timeManager.intervalList[self.timeManager.pageIndex].taskList[self.editIndex], sound: self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList[self.editIndex], alarm: self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList[self.editIndex], min: self.timeManager.intervalList[self.timeManager.pageIndex].minList[self.editIndex], sec: self.timeManager.intervalList[self.timeManager.pageIndex].secList[self.editIndex], editIndex: self.editIndex, appleMusic: self.timeManager.intervalList[self.timeManager.pageIndex].appleMusicSoundList[self.editIndex])
                }
                .onAppear {
                    //MARK: - リセット
                    //RESET_INTERVAL()
                    self.timeManager.myListScreenCount = 0
                }
            }
            .navigationBarItems(
                leading:
                    self.timeManager.curHeight > middleHeight ? navigationItem.opacity(CGFloat(1-(maxHeight-self.timeManager.curHeight)/(maxHeight-middleHeight))) : nil
                ,
                trailing:
                    self.timeManager.sideMenuOffset == closeOffset ?
                    HStack {
                        editAndQuestionButton

                        Button.init(action: { self.editMode = self.editMode.isEditing ? .inactive : .active }, label: {
                            if self.editMode.isEditing {
                                Image.init(systemName: "checkmark")
                            } else {
                                Image.init(systemName: "square.and.pencil")
                            }
                        })
                    } : nil
            )
            .navigationBarHidden(self.timeManager.curHeight >= maxHeight ? false : true)
            .navigationTitle("Interval Schedule")
            .navigationBarTitleDisplayMode(.inline)

        }
        .navigationViewStyle(.stack)
    }

    var myListSegmentView: some View {
        Picker("Select color", selection: self.$timeManager.pageIndex) {
            ForEach(Array(self.timeManager.myListNameList.enumerated()), id: \.offset) { index, element in
                Text("\(element)")
                    .tag(index)
                    .onTapGesture {
                        self.timeManager.reset()
                        self.timeManager.setTimer()
                        self.timeManager.pageIndex = index
                    }
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }

    var nowState: some View {
        Section(header:
                    Text("Now:")
            .font(.subheadline)
            .foregroundColor(Color(UIColor.systemGray))
        ) {
            HStack {
                Text("Time left: \(self.timeManager.displayTotalTime())")
                    .padding(.trailing, 3)
                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)))
                Text("(\(Int(100*(Double(self.timeManager.timeSumDuration) / Double(self.timeManager.timeSum))))%)")
                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)))
                Spacer()

                if self.timeManager.soundList[self.timeManager.intervalCount] != "Mute" {
                    Image(systemName: "speaker.2.fill")
                        .font(.subheadline)
                } else {
                    Image(systemName: "speaker.slash.fill")
                        .font(.subheadline)
                }
                Text("\(self.timeManager.soundList[self.timeManager.intervalCount])")
                    .font(.subheadline)
            }
            .listRowBackground(colorScheme == .light ? .white : Color(UIColor.systemGray5))
        }
    }

    var timeScheduleListMiddle: some View {
        TabView(selection: $timeManager.pageIndex) {
            ForEach(Array(self.timeManager.intervalList.enumerated()), id: \.offset) { myListIndex, tasks in
                List {
                    if self.timeManager.timerStatus != .stopped && self.timeManager.timeSumDuration > 0.1 {
                        nowState
                    }
                        ForEach(Array(self.timeManager.intervalList[myListIndex].taskList.enumerated()), id: \.offset) { index, task in
                            HStack {
//                                Text("\(index + 1): ")
//                                    .font(.subheadline)
//                                    .frame(alignment: .leading)
//                                    .frame(minWidth: 7)
                                if self.timeManager.intervalCount == index && self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count > 1 {
                                    Image(systemName: "chevron.forward")
                                        .foregroundColor(Color(UIColor.gray))
                                }
                                Text(task)
                                    .font(.footnote)
                                    .frame(width: 70)
                                Spacer()
                                VStack {
                                    HStack {
                                        if self.timeManager.intervalList[myListIndex].bgmNameList[index] != "Mute" {
                                            Image(systemName: "speaker.2.fill")
                                                .font(.footnote)
                                        } else {
                                            Image(systemName: "speaker.slash.fill")
                                                .font(.footnote)
                                        }
                                        Text("\(self.timeManager.intervalList[myListIndex].bgmNameList[index])")
                                            .font(.footnote)
                                        Spacer()
                                    }
                                    HStack {
                                        if self.timeManager.intervalList[myListIndex].alarmIDList[index] != 0 {
                                            Image(systemName: "bell.fill")
                                                .font(.footnote)
                                        } else {
                                            Image(systemName: "bell.slash.fill")
                                                .font(.footnote)
                                        }
                                        Text("\(self.timeManager.alarms.first(where: { $0.id == timeManager.intervalList[myListIndex].alarmIDList[index] })!.soundName)")
                                            .font(.footnote)
                                        Spacer()
                                    }
                                }
                                .frame(minWidth: 95)

                                if self.timeManager.intervalList[myListIndex].taskList.firstIndex(of: task) != nil {
                                    Text(String(format: "%02d:%02d", self.timeManager.intervalList[myListIndex].minList[index], self.timeManager.intervalList[myListIndex].secList[index]))
                                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)))
                                }
                            }
                            .frame(height: 29)
                            .contentShape(Rectangle())
                            .tag(myListIndex)
                            //.listRowBackground(self.timeManager.intervalCount == index && self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count > 1 ? Color(UIColor.systemGray3) : Color(UIColor.systemGray5))
                            .listRowBackground(colorScheme == .light ? .white : Color(UIColor.systemGray5))
                        }
                }
                .navigationBarItems(trailing: self.timeManager.curHeight == maxHeight ? EditButton() : nil)
                .onAppear {
                    //print("Card is changed Appear")
                    //self.timeManager.setTimer()
                }
                .onDisappear {
                    //print("Card is changed Disappear")
                    if self.timeManager.pageIndex != self.timeManager.prevMyListAppearingIndex {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                        self.timeManager.reset()
                        self.timeManager.setTimer()
                    }
                    if self.timeManager.curHeight != minHeight {
                        self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
                    }
                    self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
                }
            }

        }
        .navigationBarHidden(true)
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .frame(width: UIScreen.main.bounds.width, height: middleHeight - 90 )
        //.background(Color(UIColor.secondarySystemFill))
    }

    var timeScheduleListMiddle2: some View {
        TabView(selection: $timeManager.pageIndex) {

            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(Color(UIColor.systemGray6)).softOuterShadow()

                List {
                    Text("Hello")
                        .listRowBackground(Color(UIColor.systemGray6))
                    Text("Hello")
                        .listRowBackground(Color(UIColor.systemGray6))
                    Text("Hello")
                        .listRowBackground(Color(UIColor.systemGray6))
                    Text("Hello")
                        .listRowBackground(Color(UIColor.systemGray6))
                }
                .listStyle(.inset)
                .cornerRadius(20)
                //.background(Color(UIColor.systemGray6))

                //.padding()
            }
            //.cornerRadius(20)
            .padding()

        }
        .frame(height: middleHeight - 90)
        .background(Color(UIColor.systemGray6))
        .navigationBarHidden(true)
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//        TabView(selection: $timeManager.pageIndex) {
//            ForEach(Array(self.timeManager.intervalList.enumerated()), id: \.offset) { myListIndex, tasks in
//                ZStack {
//                    List {
//                        if self.timeManager.timerStatus != .stopped && self.timeManager.timeSumDuration > 0.1 {
//                            nowState
//                        }
//                            ForEach(Array(self.timeManager.intervalList[myListIndex].taskList.enumerated()), id: \.offset) { index, task in
//                                HStack {
//    //                                Text("\(index + 1): ")
//    //                                    .font(.subheadline)
//    //                                    .frame(alignment: .leading)
//    //                                    .frame(minWidth: 7)
//                                    Text(task)
//                                        .font(.footnote)
//                                        .frame(width: 70)
//                                    Spacer()
//                                    VStack {
//                                        HStack {
//                                            if self.timeManager.intervalList[myListIndex].bgmNameList[index] != "Mute" {
//                                                Image(systemName: "speaker.2.fill")
//                                                    .font(.footnote)
//                                            } else {
//                                                Image(systemName: "speaker.slash.fill")
//                                                    .font(.footnote)
//                                            }
//                                            Text("\(self.timeManager.intervalList[myListIndex].bgmNameList[index])")
//                                                .font(.footnote)
//                                            Spacer()
//                                        }
//                                        HStack {
//                                            if self.timeManager.intervalList[myListIndex].alarmIDList[index] != 0 {
//                                                Image(systemName: "bell.fill")
//                                                    .font(.footnote)
//                                            } else {
//                                                Image(systemName: "bell.slash.fill")
//                                                    .font(.footnote)
//                                            }
//                                            Text("\(self.timeManager.alarms.first(where: { $0.id == timeManager.intervalList[myListIndex].alarmIDList[index] })!.soundName)")
//                                                .font(.footnote)
//                                            Spacer()
//                                        }
//                                    }
//                                    .frame(minWidth: 95)
//
//                                    if self.timeManager.intervalList[myListIndex].taskList.firstIndex(of: task) != nil {
//                                        Text(String(format: "%02d:%02d", self.timeManager.intervalList[myListIndex].minList[index], self.timeManager.intervalList[myListIndex].secList[index]))
//                                            .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)))
//                                    }
//                                }
//                                .frame(height: 29)
//                                .contentShape(Rectangle())
//                                .tag(myListIndex)
//                                .listRowBackground(self.timeManager.intervalCount == index && self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count > 1 ? Color(UIColor.systemGray3) : Color(UIColor.systemBackground))
//                            }
//                    }
//                    .listStyle(.inset)
//                    .navigationBarItems(trailing: self.timeManager.curHeight == maxHeight ? EditButton() : nil)
//                    .onAppear {
//                        print("Card is changed Appear")
//                        //self.timeManager.setTimer()
//                    }
//                    .onDisappear {
//                        print("Card is changed Disappear")
//                        if self.timeManager.pageIndex != self.timeManager.prevMyListAppearingIndex {
//                            let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
//                            impactHeavy.impactOccurred()
//                            self.timeManager.reset()
//                            self.timeManager.setTimer()
//                        }
//                        if self.timeManager.curHeight != minHeight {
//                            self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
//                        }
//                        self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
//                    }
//
//                    }
//                    .shadow(color: .white, radius: 2, x: -3, y: -3)
//                    .shadow(color: .black, radius: 2, x: 3, y: 3)
//                    .cornerRadius(16)
//                    .padding()
//            }
//
//        }
//        .navigationBarHidden(true)
//        .tabViewStyle(.page)
//        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
//        .frame(width: UIScreen.main.bounds.width, height: middleHeight - 90 )
//        .background(Color(UIColor.white))
//        //.background(Color(UIColor.secondarySystemFill))

    }

    var timeScheduleList: some View {
        TabView(selection: $timeManager.pageIndex) {
            ForEach(Array(self.timeManager.intervalList.enumerated()), id: \.offset) { myListIndex, tasks in
                List {
                    if self.timeManager.timerStatus != .stopped && self.timeManager.timeSumDuration > 0.1 {
                        nowState
                    }

                    //if self.timeManager.curHeight > middleHeight {
                    if self.timeManager.curHeight >= maxHeight {
                        listNameTextField
                    }

                    Section (
                        footer:
                            HStack {
                                Spacer()
                                Text("Total: \(self.timeManager.displaySumTime())")
                            }
                    ){
                        ForEach(Array(self.timeManager.intervalList[myListIndex].taskList.enumerated()), id: \.offset) { index, task in
                            HStack {
                                if self.timeManager.intervalCount == index && self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count > 1 && !self.editMode.isEditing {
                                    Image(systemName: "chevron.forward")
                                        .foregroundColor(Color(UIColor.gray))
                                }

                                Text(task)
                                    .font(.subheadline)
                                    .frame(width: 90)
                                Spacer()
                                if !self.editMode.isEditing {
                                    VStack {
                                        HStack {
                                            if self.timeManager.intervalList[myListIndex].bgmNameList[index] != "Mute" {
                                                Image(systemName: "speaker.2.fill")
                                            } else {
                                                Image(systemName: "speaker.slash.fill")
                                            }
                                            Text("\(self.timeManager.intervalList[myListIndex].bgmNameList[index])")
                                            Spacer()
                                        }
                                        HStack {
                                            if self.timeManager.intervalList[myListIndex].alarmIDList[index] != 0 {
                                                Image(systemName: "bell.fill")
                                            } else {
                                                Image(systemName: "bell.slash.fill")
                                            }
                                            Text("\(self.timeManager.alarms.first(where: { $0.id == timeManager.intervalList[myListIndex].alarmIDList[index] })!.soundName)")
                                            Spacer()
                                        }
                                    }
                                    .font(.footnote)
                                    .frame(minWidth: 95)
                                }

                                if self.timeManager.intervalList[myListIndex].taskList.firstIndex(of: task) != nil {
                                    Text(String(format: "%02d:%02d", self.timeManager.intervalList[myListIndex].minList[index], self.timeManager.intervalList[myListIndex].secList[index]))
                                        .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .regular)))  // 等間隔表示
                                        .opacity(0.5)
                                }
                            }
                            .frame(height: 29)
                            .contentShape(Rectangle())
                            .tag(myListIndex)
                            .listRowBackground(colorScheme == .light ? .white : Color(UIColor.systemGray5))
                            .onTapGesture{
                                if isActive == false && self.timeManager.curHeight == maxHeight {
                                    print(self.timeManager.intervalList[self.timeManager.pageIndex].taskList)

                                    timeManager.editScreenCount = 0
                                    self.editIndex = index
                                    //self.timeManager.setTimer()
                                    print("Edit Tapped1!: \(self.timeManager.intervalList[self.timeManager.pageIndex].taskList) \(index)" )
                                    if index < self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count && self.timeManager.timerStatus != .running && self.timeManager.curHeight == maxHeight {
                                        self.showEditView = true
                                    }
                                }
                            }
                            .contextMenu(self.timeManager.curHeight == maxHeight ? ContextMenu(menuItems: {
                                Button(action: {
                                    if index != self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count-1 {
                                        self.timeManager.intervalList[self.timeManager.pageIndex].taskList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].timeList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].minList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].secList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].appleMusicSoundList.remove(at: index)
                                    } else {
                                        self.timeManager.reset()
                                        self.timeManager.setTimer()
                                        self.timeManager.intervalList[self.timeManager.pageIndex].taskList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].timeList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].minList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].secList.remove(at: index)
                                        self.timeManager.intervalList[self.timeManager.pageIndex].appleMusicSoundList.remove(at: index)
                                    }
                                    saveIntervalList(intervalList: self.timeManager.intervalList)
                                    self.timeManager.setTimer()
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                                Divider()
                                Button(action: {
                                    timeManager.editScreenCount = 0
                                    self.editIndex = index
                                    //self.timeManager.setTimer()
                                    print("Edit Tapped1!: \(self.timeManager.intervalList[self.timeManager.pageIndex].taskList)" )
                                    if index < self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count && self.timeManager.timerStatus != .running && self.timeManager.curHeight == maxHeight {
                                        self.showEditView = true
                                    }
                                }) {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }

                            }) : nil)

                        }
                        .onDelete(perform: delete)
                        .onMove(perform: moveRow)

                    }
                }
//                .id(refresh)
                //.listStyle(.inset)
                .environment(\.editMode, self.$editMode)
                .onAppear {
                    print("Card is changed Appear")
                    timeManager.editScreenCount = 0
                }
                .onDisappear {
                    print("Card is changed Disappear")
                    if self.timeManager.pageIndex != self.timeManager.prevMyListAppearingIndex {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                        self.timeManager.reset()
                        self.timeManager.setTimer()
                    }
                    if self.timeManager.curHeight != minHeight {
                        self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
                    }
                    self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.78 ) // segment追加前
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.68 ) // segment追加後
        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.59 ) // new TextField 追加後

//        .frame(width: viewWidth, height: self.timeManager.curHeight > 100 ? self.timeManager.curHeight - 100 : 0)
        //.background(Color(UIColor.secondarySystemFill))

    }

    var timeScheduleList2: some View {
        TabView(selection: $timeManager.pageIndex) {
            ForEach(Array(self.timeManager.intervalList.enumerated()), id: \.offset) { myListIndex, tasks in
                VStack {
                    if self.timeManager.timerStatus != .stopped && self.timeManager.timeSumDuration > 0.1 {
                        nowState
                    }
                    if self.timeManager.curHeight >= maxHeight {
                        listNameTextField
                    }
                    ForEach(Array(self.timeManager.intervalList[myListIndex].taskList.enumerated()), id: \.offset) { index, task in
                        HStack {
                            Text(task)
                                .font(.subheadline)
                                .frame(width: 90)
                            Spacer()
                            if !self.editMode.isEditing {
                                VStack {
                                    HStack {
                                        if self.timeManager.intervalList[myListIndex].bgmNameList[index] != "Mute" {
                                            Image(systemName: "speaker.2.fill")
                                        } else {
                                            Image(systemName: "speaker.slash.fill")
                                        }
                                        Text("\(self.timeManager.intervalList[myListIndex].bgmNameList[index])")
                                        Spacer()
                                    }
                                    HStack {
                                        if self.timeManager.intervalList[myListIndex].alarmIDList[index] != 0 {
                                            Image(systemName: "bell.fill")
                                        } else {
                                            Image(systemName: "bell.slash.fill")
                                        }
                                        Text("\(self.timeManager.alarms.first(where: { $0.id == timeManager.intervalList[myListIndex].alarmIDList[index] })!.soundName)")
                                        Spacer()
                                    }
                                }
                                .font(.footnote)
                                .frame(minWidth: 95)
                            }

                            if self.timeManager.intervalList[myListIndex].taskList.firstIndex(of: task) != nil {
                                Text(String(format: "%02d:%02d", self.timeManager.intervalList[myListIndex].minList[index], self.timeManager.intervalList[myListIndex].secList[index]))
                                    .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 18, weight: .regular)))  // 等間隔表示
                                    .opacity(0.5)
                            }
                        }
                        .padding()
                        .frame(height: 29)
                        .contentShape(Rectangle())
                        .tag(myListIndex)
                        .listRowBackground(self.timeManager.intervalCount == index && self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count > 1 && !self.editMode.isEditing ? Color(UIColor.systemGray4) : Color(UIColor.systemBackground))
                        .onTapGesture{
                            if isActive == false && self.timeManager.curHeight == maxHeight {
                                print(self.timeManager.intervalList[self.timeManager.pageIndex].taskList)

                                timeManager.editScreenCount = 0
                                self.editIndex = index
                                //self.timeManager.setTimer()
                                print("Edit Tapped1!: \(self.timeManager.intervalList[self.timeManager.pageIndex].taskList) \(index)" )
                                if index < self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count && self.timeManager.timerStatus != .running && self.timeManager.curHeight == maxHeight {
                                    self.showEditView = true
                                }
                            }
                        }
                        // 長押しした時のアクション
                        .contextMenu(self.timeManager.curHeight == maxHeight ? ContextMenu(menuItems: {
                            Button(action: {
                                if index != self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count-1 {
                                    self.timeManager.intervalList[self.timeManager.pageIndex].taskList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].timeList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].minList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].secList.remove(at: index)
                                } else {
                                    self.timeManager.reset()
                                    self.timeManager.setTimer()
                                    self.timeManager.intervalList[self.timeManager.pageIndex].taskList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].timeList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].minList.remove(at: index)
                                    self.timeManager.intervalList[self.timeManager.pageIndex].secList.remove(at: index)
                                }
                                saveIntervalList(intervalList: self.timeManager.intervalList)
                                self.timeManager.setTimer()
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            Divider()
                            Button(action: {
                                timeManager.editScreenCount = 0
                                self.editIndex = index
                                //self.timeManager.setTimer()
                                print("Edit Tapped1!: \(self.timeManager.intervalList[self.timeManager.pageIndex].taskList)" )
                                if index < self.timeManager.intervalList[self.timeManager.pageIndex].taskList.count && self.timeManager.timerStatus != .running && self.timeManager.curHeight == maxHeight {
                                    self.showEditView = true
                                }
                            }) {
                                Text("Edit")
                                Image(systemName: "pencil")
                            }

                        }) : nil)
                    }
                    .onDelete(perform: delete)
                    //.onDelete(perform: editMode == .active ? delete : nil)
                    .onMove(perform: moveRow)

                    Spacer()
                }
                .onAppear {
                    print("Card is changed Appear")
                    timeManager.editScreenCount = 0
                }
                .onDisappear {
                    print("Card is changed Disappear")
                    if self.timeManager.pageIndex != self.timeManager.prevMyListAppearingIndex {
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                        self.timeManager.reset()
                        self.timeManager.setTimer()
                    }
                    if self.timeManager.curHeight != minHeight {
                        self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
                    }
                    self.timeManager.prevMyListAppearingIndex = self.timeManager.pageIndex
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.78 ) // segment追加前
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.68 ) // segment追加後
        //.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.59 ) // new TextField 追加後

//        .frame(width: viewWidth, height: self.timeManager.curHeight > 100 ? self.timeManager.curHeight - 100 : 0)
        //.background(Color(UIColor.secondarySystemFill))

    }

    var editAndQuestionButton: some View {
        HStack {
            Image(systemName: "questionmark.circle")
                .onTapGesture {
                    let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                    impactHeavy.impactOccurred()
                    self.timeManager.showHintView = true
                }
                .foregroundColor(.blue)
                .opacity(CGFloat(1-(maxHeight-self.timeManager.curHeight)/(maxHeight-middleHeight)))

            //EditButton()
            //MyEditButton()
        }
    }

    var plusButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    if self.timeManager.timerStatus != .running {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.warning)
                        self.showAddView = true
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        //.shadow(color: Color(UIColor.systemGray), radius: 3, x: 3, y: 3)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 3, y: 3)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: -3, y: -3)
                        .opacity(self.timeManager.timerStatus != .running ? 0.75 : 0)
                }
                .sheet(isPresented: self.$showAddView) {
                    InputView(inputDelegate: self, addDetailToListDelegate: self, task: "", sound: "", min: 0, sec: 0, myListIndex: self.timeManager.pageIndex, appleMusic: nil)
                }
                Spacer()
            }
            .padding(.bottom, 140)
        }
    }

    var listNameTextField: some View {
        HStack {
            Image(systemName:"pencil")
                .foregroundColor(isActive ? Color.blue : Color(UIColor.darkGray))
                .font(Font.body.weight(.bold))
                .onTapGesture {
                    isActive.toggle()
                }

            TextField("This list Name", text: self.$timeManager.intervalList[self.timeManager.pageIndex].listName,
                      onEditingChanged: { begin in
                if begin {
                    self.editting = true    // 編集フラグをオン
                } else {
                    self.editting = false   // 編集フラグをオフ
                }
            },onCommit: {
                self.timeManager.setTimer()
                saveIntervalList(intervalList: self.timeManager.intervalList)
            })
            //.textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
            //.shadow(color: editting ? .blue : .clear, radius: 5)
            .onChange(of: self.timeManager.intervalList[self.timeManager.pageIndex].listName) { _ in
                saveIntervalList(intervalList: self.timeManager.intervalList)
            }
            .focused($isActive)
            //.frame(width: UIScreen.main.bounds.width - 45, height: 29)
        }
        .listRowBackground(colorScheme == .light ? .white : Color(UIColor.systemGray5))
    }

    var listNameTextField2: some View {
        VStack {
          HStack {
            Image(systemName:"pencil")
                  .foregroundColor(isActive ? Color.blue : Color(UIColor.darkGray))
             .font(Font.body.weight(.bold))
             .onTapGesture {
                 isActive.toggle()
             }

              TextField("This list Name", text: self.$timeManager.intervalList[self.timeManager.pageIndex].listName,
                        onEditingChanged: { begin in
                  /// 入力開始処理
                  if begin {
                      self.editting = true    // 編集フラグをオン
                      /// 入力終了処理
                  } else {
                      self.editting = false   // 編集フラグをオフ

                  }
              },onCommit: {
                  self.timeManager.setTimer()
                  saveIntervalList(intervalList: self.timeManager.intervalList)
              })
              //.textFieldStyle(RoundedBorderTextFieldStyle()) // 入力域を枠で囲む
              //.shadow(color: editting ? .blue : .clear, radius: 3)
              .onChange(of: self.timeManager.intervalList[self.timeManager.pageIndex].listName) { _ in
                  saveIntervalList(intervalList: self.timeManager.intervalList)
              }
              .focused($isActive)
              .frame(height: 29)
          }
          .padding(.horizontal)
          .padding(.vertical, 10)
          .background(
             RoundedRectangle(cornerRadius: 30)
                .fill(Color(UIColor.systemGray6))
              .softInnerShadow(RoundedRectangle(cornerRadius: 30), darkShadow: .gray, lightShadow: .white, spread: 0.05, radius: 2)
           )
        }
        .padding(.horizontal)
        .padding(.top, 10)

    }

    var downButton: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "arrow.down.to.line.circle.fill")
                    .font(.largeTitle)
                    .padding(.leading)
                    .padding(.bottom)
                    .foregroundColor(.blue)
                    .opacity(0.75)
                    .onTapGesture {
                        timeManager.curHeight = minHeight
                    }
                Spacer()
            }
        }
    }

    var navigationItem: some View {
        HStack {
            Button(action: {
                //self.show.toggle()
                let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                impactHeavy.impactOccurred()

                if self.timeManager.sideMenuOffset == self.openOffset {
                    self.timeManager.sideMenuOffset = self.closeOffset

                } else if self.timeManager.sideMenuOffset == self.closeOffset {
                    self.timeManager.sideMenuOffset = self.openOffset
                }
                self.timeManager.showMyListView = true
            }) {
                Image(systemName: "sidebar.left")
            }
//            .sheet(isPresented: self.$showMyListView) {
//                // trueになれば下からふわっと表示
//                MyListView()
//            }
        }
    }

    func saveIntervalList(intervalList: [IntervalList]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(intervalList) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "LIST2")
    }

    func delete(at offsets: IndexSet) {
        self.timeManager.reset()
        self.timeManager.setTimer()
        self.timeManager.intervalList[self.timeManager.pageIndex].taskList.remove(atOffsets: offsets)
        self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList.remove(atOffsets: offsets)
        self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList.remove(atOffsets: offsets)
        self.timeManager.intervalList[self.timeManager.pageIndex].timeList.remove(atOffsets: offsets)
        self.timeManager.intervalList[self.timeManager.pageIndex].minList.remove(atOffsets: offsets)
        self.timeManager.intervalList[self.timeManager.pageIndex].secList.remove(atOffsets: offsets)
        self.timeManager.intervalList[self.timeManager.pageIndex].appleMusicSoundList.remove(atOffsets: offsets)
        
        saveIntervalList(intervalList: self.timeManager.intervalList)
        self.timeManager.setTimer()
        //self.timeManager.start()
    }

    func addTodo(task: String, time: Int, sound: String, finSound: Int, min: Int, sec: Int, appleMusic: Song?) {
        self.timeManager.intervalList[self.timeManager.pageIndex].taskList.append(task)
        self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList.append(sound)
        self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList.append(finSound)
        self.timeManager.intervalList[self.timeManager.pageIndex].timeList.append(time)
        self.timeManager.intervalList[self.timeManager.pageIndex].minList.append(min)
        self.timeManager.intervalList[self.timeManager.pageIndex].secList.append(sec)
        self.timeManager.intervalList[self.timeManager.pageIndex].appleMusicSoundList.append(appleMusic)
        
        saveIntervalList(intervalList: self.timeManager.intervalList)
        self.timeManager.setTimer()
    }

    func addListFirst() {
        self.timeManager.intervalList.append(contentsOf: [IntervalList(listName: "My List \(self.timeManager.intervalList.count)", taskList: ["Timer1"], bgmNameList: ["Mute"], alarmIDList: [0], timeList: [90], minList: [1], secList: [30], appleMusicSoundList: [nil])])
        self.timeManager.myListNameList = returnMyListName()
        saveIntervalList(intervalList: timeManager.intervalList)
        self.timeManager.setTimer()
    }

    func returnMyListName() -> [String] {
        var myList: [String] = []
        for num in 0..<self.timeManager.intervalList.count {
            myList.append(self.timeManager.intervalList[num].listName)
        }
        return myList
    }


    func moveRow(from source: IndexSet, to destination: Int) {
        self.timeManager.intervalList[self.timeManager.pageIndex].taskList.move(fromOffsets: source, toOffset: destination)
        self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList.move(fromOffsets: source, toOffset: destination)
        self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList.move(fromOffsets: source, toOffset: destination)
        self.timeManager.intervalList[self.timeManager.pageIndex].timeList.move(fromOffsets: source, toOffset: destination)
        self.timeManager.intervalList[self.timeManager.pageIndex].minList.move(fromOffsets: source, toOffset: destination)
        self.timeManager.intervalList[self.timeManager.pageIndex].secList.move(fromOffsets: source, toOffset: destination)
        self.timeManager.intervalList[self.timeManager.pageIndex].appleMusicSoundList.move(fromOffsets: source, toOffset: destination)

        saveIntervalList(intervalList: self.timeManager.intervalList)
        self.timeManager.reset()
        //self.timeManager.setTimer()
        //self.timeManager.start()
    }

    func editTodo(task: String, time: Int, sound: String, finSound: Int, min: Int, sec: Int, editIndex: Int, appleMusic: Song?) {
        self.timeManager.intervalList[self.timeManager.pageIndex].taskList[editIndex] = task
        self.timeManager.intervalList[self.timeManager.pageIndex].bgmNameList[editIndex] = sound
        self.timeManager.intervalList[self.timeManager.pageIndex].alarmIDList[editIndex] = finSound
        self.timeManager.intervalList[self.timeManager.pageIndex].timeList[editIndex] = time
        self.timeManager.intervalList[self.timeManager.pageIndex].minList[editIndex] = min
        self.timeManager.intervalList[self.timeManager.pageIndex].secList[editIndex] = sec
        self.timeManager.intervalList[self.timeManager.pageIndex].appleMusicSoundList[editIndex] = appleMusic
        
        saveIntervalList(intervalList: self.timeManager.intervalList)
        self.timeManager.setTimer()
    }

    func addToList(listName: String, taskList: [String], bgmList: [String], alarmList: [Int], timeList: [Int], minList: [Int], secList: [Int], appleMusic: [Song?]) {
        self.timeManager.intervalList.append(IntervalList(listName: listName, taskList: taskList, bgmNameList: bgmList, alarmIDList: alarmList, timeList: timeList, minList: minList, secList: secList, appleMusicSoundList: appleMusic))

        saveIntervalList(intervalList: timeManager.intervalList)
        self.timeManager.setTimer()

    }

    func addDetailToList(task: String, bgmName: String, alarmID: Int, time: Int, min: Int, sec: Int, myListIndex: Int, appleMusic: Song?) {
        self.timeManager.intervalList[myListIndex].taskList.append(task)
        self.timeManager.intervalList[myListIndex].bgmNameList.append(bgmName)
        self.timeManager.intervalList[myListIndex].alarmIDList.append(alarmID)
        self.timeManager.intervalList[myListIndex].timeList.append(time)
        self.timeManager.intervalList[myListIndex].minList.append(min)
        self.timeManager.intervalList[myListIndex].secList.append(sec)
        self.timeManager.intervalList[myListIndex].appleMusicSoundList.append(appleMusic)

        saveIntervalList(intervalList: timeManager.intervalList)
        self.timeManager.setTimer()
    }

    func RESET_INTERVAL() {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        self.timeManager.intervalList = [IntervalList(listName: "", taskList: [""], bgmNameList: ["Mute"], alarmIDList: [0], timeList: [0], minList: [0], secList: [0], appleMusicSoundList: [nil])]
        saveIntervalList(intervalList: timeManager.intervalList)
        self.timeManager.setTimer()

    }
}

/// オリジナルEditButton
struct MyEditButton: View {
    @Environment(\.editMode) var editMode

    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Image(systemName: "checkmark")
            } else {
                Image.init(systemName: "square.and.pencil")
            }
        }
    }
}

protocol InputViewDelegate {
    func addTodo(task: String, time: Int, sound: String, finSound: Int, min: Int, sec: Int, appleMusic: Song?)
}

protocol EditViewDelegate {
    func editTodo(task: String, time: Int, sound: String, finSound: Int, min: Int, sec: Int, editIndex: Int, appleMusic: Song?)
}

protocol AddDetailToListDelegate {
    func addDetailToList(task: String, bgmName: String, alarmID: Int, time: Int, min: Int, sec: Int, myListIndex: Int, appleMusic: Song?)
}

// ② : TextField() を下げる(閉じる)
extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct IntervalListView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TimeManager())
    }
}

