////
////  FlatGlassView.swift
////  Interval_Timer
////
////  Created by 田中大誓 on 2022/10/21.
////
//
//import Foundation
//import SwiftUI
//
//struct FlatGlassView : ViewModifier {
//    func body(content: Content) -> some View {
//        if #available(iOS 15.0, *) {
//            content
//                .padding()
//                .frame(height: 50)
//                .background(.ultraThinMaterial)
//                .cornerRadius(14)
//        } else {
//            // Fallback on earlier versions
//            content
//                .padding()
//                .frame(height: 50)
//                .cornerRadius(14)
//        }
//    }
//}
//
//extension UICollectionReusableView {
//    override open var backgroundColor: UIColor? {
//        get { .clear }
//        set { }
//    }
//}
//
//struct FlatSignUpView: View {
//    @EnvironmentObject var timeManager: TimeManager
//    @Environment(\.presentationMode) var presentation
//    
//    @State private var show: Bool = false
//    @State var editMode: EditMode = .inactive
//    
//    @State var email = ""
//    @State var password = ""
//    @State var passwordAgain = ""
//    
////    init() {
////        UITableView.appearance().backgroundColor = .clear
////        UITableViewCell.appearance().backgroundColor = .clear
////        UIView.appearance().backgroundColor = .clear
////        UICollectionView.appearance().backgroundColor = .clear //好きな色
////    }
//    
//    var body: some View {
//        if #available(iOS 15.0, *) {
//            VStack{
//                Text("My List")
//                    .font(.largeTitle)
//                    .bold()
//                    .frame(maxWidth : .infinity, alignment: .leading)
//                    .padding(.top)
//                    .foregroundColor(Color.primary.opacity(0.4))
//                
//                Text("Create a new account")
//                    .font(.callout)
//                    .frame(maxWidth : .infinity, alignment: .leading)
//                
//                Divider().padding()
//                
//                List {
//                    ForEach(Array(timeManager.intervalList.enumerated()), id: \.offset) { index, list in
//                        ZStack {
//                            Text(list.listName)
//                                .bold()
//                                .frame(minHeight: 50)
//                                .frame(maxWidth: .infinity, maxHeight: 60)
//                                .background(.ultraThickMaterial)
//                                .cornerRadius(14)
//                        }
//                        .padding(.bottom, 8)
//                        //.listRowBackground(self.timeManager.pageIndex == index && self.timeManager.intervalList.count > 1 ? Color.thickMaterial : Color.thinMaterial)
//                        //.background(self.timeManager.pageIndex == index && self.timeManager.intervalList.count > 1 ? .thickMaterial : .thinMaterial)
//                        .onTapGesture {
//                            self.timeManager.pageIndex = index
//                        }
//                    }
//                    .onDelete(perform: deleteList)
//                    .onMove(perform: moveRow)
//                    //.background(.ultraThinMaterial)
//                }
//                //.background(.ultraThinMaterial)
//                .frame(height: UIScreen.main.bounds.height * 0.3)
//                //.frame(maxWidth: .infinity)
//                .listStyle(.plain)
//                //.padding()
//                
//                Divider().padding()
//                
//                Text("By signing up you accept the **Terms of Service** and **Privacy Policy**")
//                    .font(.footnote)
//                
//                Button {
//                    //TODO:- add action
//                } label: {
//                    ZStack {
//                        Text("SIGN UP")
//                            .bold()
//                            .frame(maxWidth: .infinity, maxHeight: 50)
//                            .background(.thickMaterial)
//                            .cornerRadius(14)
//                            .padding(.bottom, 8)
//                    }
//                }
//                
//            }
//            .padding()
//            .background(.ultraThinMaterial)
//            .foregroundColor(Color.primary.opacity(0.35))
//            .foregroundStyle(.ultraThinMaterial)
//            .cornerRadius(35)
//            .padding()
//        } else {
//            // Fallback on earlier versions
//            VStack {
//                
//            }
//        }
//    }
//    
//    func returnMyListName() -> [String] {
//        var myList: [String] = []
//        for num in 0..<self.timeManager.intervalList.count {
//            myList.append(self.timeManager.intervalList[num].listName)
//        }
//        return myList
//    }
//    
//    func addList() {
//        self.timeManager.intervalList.append(contentsOf: [IntervalList(listName: "My List" + String(self.timeManager.intervalList.count + 1), taskList: ["Timer1"], bgmNameList: ["Mute"], alarmIDList: [0], timeList: [90], minList: [1], secList: [30])])
//        self.timeManager.myListNameList = returnMyListName()
//        saveIntervalList(intervalList: timeManager.intervalList)
//        self.timeManager.setTimer()
//        
//    }
//    
//    func addListFirst() {
//        self.timeManager.intervalList.append(contentsOf: [IntervalList(listName: "My List \(self.timeManager.intervalList.count)", taskList: ["Timer1"], bgmNameList: ["Mute"], alarmIDList: [0], timeList: [90], minList: [1], secList: [30])])
//        self.timeManager.myListNameList = returnMyListName()
//        saveIntervalList(intervalList: timeManager.intervalList)
//        self.timeManager.setTimer()
//    }
//    
//    func deleteList(at offsets: IndexSet) {
//        if self.timeManager.intervalList.count == 1 {
//            print("A")
//            addListFirst()
//            timeManager.intervalList.remove(atOffsets: offsets)
//            saveIntervalList(intervalList: timeManager.intervalList)
//            timeManager.reset()
//            timeManager.setTimer()
//        } else {
//            for index in offsets {
//                if index == 0 {
//                    print("B")
//                    timeManager.intervalList.remove(atOffsets: offsets)
//                    timeManager.pageIndex = 0
//                    saveIntervalList(intervalList: timeManager.intervalList)
//                    timeManager.reset()
//                    timeManager.setTimer()
//                } else if self.timeManager.pageIndex == self.timeManager.intervalList.count - 1 {
//                    print("D")
//                    timeManager.pageIndex -= 1
//                    timeManager.intervalList.remove(atOffsets: offsets)
//                    saveIntervalList(intervalList: timeManager.intervalList)
//                    timeManager.reset()
//                    timeManager.setTimer()
//                } else {
//                    print("C")
//                    timeManager.intervalList.remove(atOffsets: offsets)
//                    saveIntervalList(intervalList: timeManager.intervalList)
//                    timeManager.setTimer()
//                }
//                
//            }
//        }
//        
//    }
//    
//    func moveRow(from source: IndexSet, to destination: Int) {
//        timeManager.intervalList.move(fromOffsets: source, toOffset: destination)
//        saveIntervalList(intervalList: timeManager.intervalList)
//        timeManager.setTimer()
//    }
//    
//    func saveIntervalList(intervalList: [IntervalList]) {
//        let jsonEncoder = JSONEncoder()
//        guard let data = try? jsonEncoder.encode(intervalList) else {
//            return
//        }
//        UserDefaults.standard.set(data, forKey: "LIST2")
//    }
//}
