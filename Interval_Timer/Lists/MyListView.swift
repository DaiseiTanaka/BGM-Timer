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
    
    @State private var show: Bool = false
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        ZStack {
            List {
                Section(header:
                            HStack {
                    Text("My Lists")
                        .padding(.leading, 10)
                        .font(.title)
                        .foregroundColor(Color(UIColor.systemGray))
                    Spacer()
                    Button.init(action: { self.editMode = self.editMode.isEditing ? .inactive : .active }, label: {
                        if self.editMode.isEditing {
                            Image.init(systemName: "checkmark")
                        } else {
                            Image.init(systemName: "square.and.pencil")
                        }
                    })
                }
                    .onTapGesture{
                        self.timeManager.sideMenuOffset = -1 * UIScreen.main.bounds.width
                    })
                {
                    ForEach(Array(timeManager.intervalList.enumerated()), id: \.offset) { index, list in
                        HStack {
                            Text("\(index + 1): ")
                                .font(.subheadline)
                                .frame(alignment: .leading)
                                .frame(minWidth: 7)
                            
                            Text(list.listName)
                                .font(.footnote)
                            
                            Spacer()
                            
                            Text("(\(list.taskList.count))")
                            
                        }
                        .contentShape(Rectangle())
                        .listRowBackground(self.timeManager.pageIndex == index && self.timeManager.intervalList.count > 1 ? Color(UIColor.systemGray3) : Color(UIColor.systemBackground))
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
                            .shadow(color: .gray, radius: 3, x: 3, y: 3)
                            .opacity(0.75)
                    }
                Spacer()
            }
            .padding(.bottom, self.timeManager.intervalList.count < 5 ? 200 : 100)
        }
        
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
