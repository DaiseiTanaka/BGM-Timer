//
//  ListView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/23.
//

import Foundation
import SwiftUI


struct MyListView: View {
    @EnvironmentObject var timeManager: TimeManager
    @Environment(\.presentationMode) var presentation
    @Environment(\.colorScheme) var colorScheme  //ダークモードかライトモードか検出

    @State private var show: Bool = false
    @State var editMode: EditMode = .inactive
    
    init() {
        //UITableView.appearance().backgroundColor = .orange
        //UIView.appearance().backgroundColor = .green
        UICollectionView.appearance().backgroundColor = UIColor.systemGray6 //好きな色
    }

    var body: some View {
        ZStack {
            List {
                Section(header:
                            HStack {
                    Text("My Lists")
                        .padding(.leading, 10)
                        //.font(.title)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(UIColor.systemGray))
                    Spacer()
                    Button.init(action: { self.editMode = self.editMode.isEditing ? .inactive : .active }, label: {
                        if self.editMode.isEditing {
                            Image.init(systemName: "checkmark")
                                .resizable()
                                .frame(width: 20, height: 20)
                        } else {
                            Image.init(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    })
                }
                    .onTapGesture{
                        //self.timeManager.sideMenuOffset = -1 * UIScreen.main.bounds.width
                        self.show = true
                    })
                {
                    ForEach(Array(timeManager.intervalList.enumerated()), id: \.offset) { index, list in
                        HStack {
                            if self.timeManager.pageIndex == index && self.timeManager.intervalList.count > 1 && !self.editMode.isEditing {
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(Color(UIColor.gray))
                            }
                            Text(list.listName)
                                .font(.footnote)
                                .lineLimit(1)
                            
                            Spacer()
                            
                            if !self.editMode.isEditing {
                                Text("(\(list.taskList.count))")
                            }
                        }
                        //.id(UUID())
                        .contentShape(Rectangle())
                        //.listRowBackground(self.timeManager.pageIndex == index && self.timeManager.intervalList.count > 1 ? Color(UIColor.systemGray3) : Color(UIColor.systemGray5))
                        .listRowBackground(colorScheme == .light ? .white : Color(UIColor.systemGray5))
                        .onTapGesture {
                            self.timeManager.pageIndex = index
                        }
                        .contextMenu(ContextMenu(menuItems: {
                            Button(action: {
                                if self.timeManager.intervalList.count == 1 {
                                    print("A")
                                    addListFirst()
                                    timeManager.intervalList.remove(at: index)
                                    saveIntervalList(intervalList: timeManager.intervalList)
                                    timeManager.reset()
                                    timeManager.setTimer()
                                } else {
                                    if index == 0 {
                                        print("B")
                                        timeManager.intervalList.remove(at: index)
                                        timeManager.pageIndex = 0
                                        saveIntervalList(intervalList: timeManager.intervalList)
                                        timeManager.reset()
                                        timeManager.setTimer()
                                    } else if self.timeManager.pageIndex == self.timeManager.intervalList.count - 1 {
                                        print("D")
                                        timeManager.pageIndex -= 1
                                        timeManager.intervalList.remove(at: index)
                                        saveIntervalList(intervalList: timeManager.intervalList)
                                        timeManager.reset()
                                        timeManager.setTimer()
                                    } else {
                                        print("C")
                                        timeManager.intervalList.remove(at: index)
                                        saveIntervalList(intervalList: timeManager.intervalList)
                                        timeManager.setTimer()
                                    }
                                }
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                            Divider()
                            ForEach(Array(self.timeManager.intervalList[index].taskList.enumerated()), id: \.offset) { iindex, task in
                                Text("\(iindex + 1):  \(task)      \(String(format: "%02d:%02d", self.timeManager.intervalList[index].minList[iindex], self.timeManager.intervalList[index].secList[iindex]))")
                                    .lineLimit(1)
                            }
                        }))
                    }
                    .onDelete(perform: deleteList)
                    .onMove(perform: moveRow)
                }
            }
            
            addListButton
            
        }
        //.background(Color(UIColor.systemGray6))
        .environment(\.editMode, self.$editMode)
        .animation(.easeInOut, value: editMode)  // editボタンを押したときのアニメーション
        .sheet(isPresented: $show) {
           HalfSheet {
               List {
                   ForEach(0..<100) { num in
                       Text("\(num)")
                   }
                   .onDelete(perform: deleteList)
                   .onMove(perform: moveRow)
               }
               
           }
        }
        
    }
    
    
    var addListButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(
                    action: {
                        addList()
                        self.timeManager.pageIndex = self.timeManager.intervalList.count - 1
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                        //.shadow(color: .gray, radius: 3, x: 3, y: 3)
                            .shadow(color: .black.opacity(0.4), radius: 5, x: 3, y: 3)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -3, y: -3)
                            .opacity(0.75)
                    }
                Spacer()
            }
            .padding(.bottom, self.timeManager.intervalList.count < 5 ? 250 : 200)
        }
        .background(Color(UIColor.clear))
        
    }
    
    func returnMyListName() -> [String] {
        var myList: [String] = []
        for num in 0..<self.timeManager.intervalList.count {
            myList.append(self.timeManager.intervalList[num].listName)
        }
        return myList
    }
    
    func addList() {
        self.timeManager.intervalList.append(contentsOf: [IntervalList(listName: "My List" + String(self.timeManager.intervalList.count + 1), taskList: ["Timer1"], bgmNameList: ["Mute"], alarmIDList: [0], timeList: [90], minList: [1], secList: [30])])
        self.timeManager.myListNameList = returnMyListName()
        saveIntervalList(intervalList: timeManager.intervalList)
        self.timeManager.setTimer()
        
    }
    
    func addListFirst() {
        self.timeManager.intervalList.append(contentsOf: [IntervalList(listName: "My List \(self.timeManager.intervalList.count)", taskList: ["Timer1"], bgmNameList: ["Mute"], alarmIDList: [0], timeList: [90], minList: [1], secList: [30])])
        self.timeManager.myListNameList = returnMyListName()
        saveIntervalList(intervalList: timeManager.intervalList)
        self.timeManager.setTimer()
    }
    
    func deleteList(at offsets: IndexSet) {
        if self.timeManager.intervalList.count == 1 {
            print("A")
            addListFirst()
            timeManager.intervalList.remove(atOffsets: offsets)
            saveIntervalList(intervalList: timeManager.intervalList)
            timeManager.reset()
            timeManager.setTimer()
        } else {
            for index in offsets {
                if index == 0 {
                    print("B")
                    timeManager.intervalList.remove(atOffsets: offsets)
                    timeManager.pageIndex = 0
                    saveIntervalList(intervalList: timeManager.intervalList)
                    timeManager.reset()
                    timeManager.setTimer()
                } else if self.timeManager.pageIndex == self.timeManager.intervalList.count - 1 {
                    print("D")
                    timeManager.pageIndex -= 1
                    timeManager.intervalList.remove(atOffsets: offsets)
                    saveIntervalList(intervalList: timeManager.intervalList)
                    timeManager.reset()
                    timeManager.setTimer()
                } else {
                    print("C")
                    timeManager.intervalList.remove(atOffsets: offsets)
                    saveIntervalList(intervalList: timeManager.intervalList)
                    timeManager.setTimer()
                }
                
            }
        }
        
    }
    
    func moveRow(from source: IndexSet, to destination: Int) {
        timeManager.intervalList.move(fromOffsets: source, toOffset: destination)
        saveIntervalList(intervalList: timeManager.intervalList)
        timeManager.setTimer()
    }
    
    func saveIntervalList(intervalList: [IntervalList]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(intervalList) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "LIST2")
    }
    
}

struct MyListView_Previews: PreviewProvider {
    static var previews: some View {
        MyListView()
            .environmentObject(TimeManager())
    }
}

//struct BackgroundClearView: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        Task {
//            view.superview?.superview?.backgroundColor = .clear
//        }
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}
//
//extension View {
//
//    func backgroundClearSheet() -> some View {
//        background(BackgroundClearView())
//    }
//}
//
extension UICollectionReusableView {
    override open var backgroundColor: UIColor? {
        get { .clear }
        set { }
    }
}
