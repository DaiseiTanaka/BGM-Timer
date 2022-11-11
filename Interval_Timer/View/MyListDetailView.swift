//
//  MyListDetailView.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/09/24.
//

//import Foundation
//import SwiftUI
//
//
//struct MyListDetailView: View, InputViewDelegate, AddDetailToListDelegate {
//    func addTodo(task: String, time: Int, sound: String, finSound: Int, min: Int, sec: Int) {
//    }
//    
//    
//    @EnvironmentObject var timeManager: TimeManager
//    @Environment(\.presentationMode) var presentation
//    
//    @State var myListIndex: Int = 0
//    @State var listName: String
//
//    var body: some View {
//        NavigationView {
//            ZStack {
//                detailList
//            }
//            .navigationTitle("New my list")
//            .background(Color(UIColor.systemGray6))
//            .onAppear{
//                self.timeManager.myListScreenCount = 1
//            }
//        }
//        
//    }
//    
//    var detailList: some View {
//        List {
//            Section(header: Text("New mylist name:")) {
//                TextField("please input here", text: $listName)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .ignoresSafeArea()
//            }
//            
//            Section(header: Text("Interval schedule") ) {
//                ForEach(Array(self.timeManager.intervalList[myListIndex].taskList.enumerated()), id: \.offset) { index, task in
//                    HStack {
//                        Text("\(index + 1): ")
//                            .font(.subheadline)
//                            .frame(alignment: .leading)
//                            .frame(minWidth: 7)
//                        Text(task)
//                            .font(.footnote)
//                            .frame(width: 70)
//                        Spacer()
//                        VStack {
//                            HStack {
//                                if self.timeManager.intervalList[myListIndex].bgmNameList[index] != "Mute" {
//                                    Image(systemName: "speaker.2.fill")
//                                        .font(.footnote)
//                                } else {
//                                    Image(systemName: "speaker.slash.fill")
//                                        .font(.footnote)
//                                }
//                                Text("\(self.timeManager.intervalList[myListIndex].bgmNameList[index])")
//                                    .font(.footnote)
//                                Spacer()
//                            }
//                            HStack {
//                                if self.timeManager.intervalList[myListIndex].alarmIDList[index] != 0 {
//                                    Image(systemName: "bell.fill")
//                                        .font(.footnote)
//                                } else {
//                                    Image(systemName: "bell.slash.fill")
//                                        .font(.footnote)
//                                }
//                                Text("\(self.timeManager.alarms.first(where: { $0.id == timeManager.intervalList[myListIndex].alarmIDList[index] })!.soundName)")
//                                    .font(.footnote)
//                                Spacer()
//                            }
//                        }
//                        .frame(minWidth: 135)
//
//                        if self.timeManager.intervalList[myListIndex].taskList.firstIndex(of: task) != nil {
//                            Text(String(format: "%02d:%02d", self.timeManager.intervalList[myListIndex].minList[index], self.timeManager.intervalList[myListIndex].secList[index]))
//                        }
//                        
////                            if self.timeManager.timerStatus != .running {
////                                NavigationLink(destination: EditView(delegate: self, task: timeManager.taskList[index], sound: timeManager.soundList[index], alarm: timeManager.alarmList[index], min: timeManager.minList[index], sec: timeManager.secList[index], editIndex: index)) {
////                                }
////                            }
//                    }
//                }
//                .onDelete(perform: deleteList)
//                .onMove(perform: moveRow)
//            }
//            
//            //Section {
//                NavigationLink(destination: InputView(inputDelegate: self, addDetailToListDelegate: self, task: "", sound: "", min: 0, sec: 0, myListIndex: myListIndex)) {
//                    HStack {
//                        Spacer()
//                        Image(systemName: "plus.circle")
//                            .foregroundColor(Color.blue)
//                        Text("Add")
//                            .foregroundColor(Color.blue)
//                        Spacer()
//                    }
//                }
//            //}
//                        
//            Section {
////                HStack {
////                    Spacer()
////                    Image(systemName: "play.circle")
////                        .foregroundColor(Color.blue)
////                    Text("Start")
////                        .foregroundColor(Color.blue)
////                    Spacer()
////                }
////                .onTapGesture {
////                    let generator = UINotificationFeedbackGenerator()
////                    generator.notificationOccurred(.warning)
////                    setList(listName: listName, taskList: self.timeManager.intervalList[myListIndex].taskList, bgmNameList: self.timeManager.intervalList[myListIndex].bgmNameList, alarmIDList: self.timeManager.intervalList[myListIndex].alarmIDList, timeList: self.timeManager.intervalList[myListIndex].timeList, minList: self.timeManager.intervalList[myListIndex].minList, secList: self.timeManager.intervalList[myListIndex].secList)
////                    
////                    self.timeManager.reset()
////                    self.timeManager.restart()
////                    
////                    presentation.wrappedValue.dismiss()
////                }
//            //}
//            
//            //Section {
//                HStack {
//                    Spacer()
//                    Image(systemName: "checkmark.circle")
//                        .foregroundColor(Color.green)
//                    Text("Save")
//                        .foregroundColor(Color.green)
//                    Spacer()
//                }
//                .onTapGesture {
//                    let generator = UINotificationFeedbackGenerator()
//                    generator.notificationOccurred(.warning)
//                    setList(listName: listName, taskList: self.timeManager.intervalList[myListIndex].taskList, bgmNameList: self.timeManager.intervalList[myListIndex].bgmNameList, alarmIDList: self.timeManager.intervalList[myListIndex].alarmIDList, timeList: self.timeManager.intervalList[myListIndex].timeList, minList: self.timeManager.intervalList[myListIndex].minList, secList: self.timeManager.intervalList[myListIndex].secList)
//                    presentation.wrappedValue.dismiss()
//                }
//            //}
//            
//            //Section {
//                HStack {
//                    Spacer()
//                    Image(systemName: "xmark.circle")
//                        .foregroundColor(Color.red)
//                    Text("Cancel")
//                        .foregroundColor(Color.red)
//                    Spacer()
//                }
//                .onTapGesture {
//                    delete(offsets: myListIndex)
//                    let generator = UINotificationFeedbackGenerator()
//                    generator.notificationOccurred(.warning)
//                    presentation.wrappedValue.dismiss()
//                }
//            }
//        }
//    }
//    
//    func deleteList(at offsets: IndexSet) {
//        self.timeManager.intervalList[myListIndex].taskList.remove(atOffsets: offsets)
//        self.timeManager.intervalList[myListIndex].bgmNameList.remove(atOffsets: offsets)
//        self.timeManager.intervalList[myListIndex].alarmIDList.remove(atOffsets: offsets)
//        self.timeManager.intervalList[myListIndex].timeList.remove(atOffsets: offsets)
//        self.timeManager.intervalList[myListIndex].minList.remove(atOffsets: offsets)
//        self.timeManager.intervalList[myListIndex].secList.remove(atOffsets: offsets)
//
//        saveIntervalList(intervalList: self.timeManager.intervalList)
//        self.timeManager.setTimer()
//    }
//    
//    func delete(offsets: Int) {
//        self.timeManager.intervalList.remove(at: offsets)
//
//        saveIntervalList(intervalList: self.timeManager.intervalList)
//        self.timeManager.setTimer()
//    }
//    
//    func moveRow(from source: IndexSet, to destination: Int) {
//        timeManager.intervalList.move(fromOffsets: source, toOffset: destination)
//        saveIntervalList(intervalList: timeManager.intervalList)
//        timeManager.setTimer()
//    }
//    
//    func setList(listName: String, taskList: [String], bgmNameList: [String], alarmIDList: [Int], timeList: [Int], minList: [Int], secList: [Int]) {
////        self.timeManager.taskList = taskList
////        self.timeManager.soundList = bgmNameList
////        self.timeManager.alarmList = alarmIDList
////        self.timeManager.timeList = timeList
////        self.timeManager.minList = minList
////        self.timeManager.secList = secList
////        UserDefaults.standard.setValue(taskList, forKey: "TASK")
////        UserDefaults.standard.setValue(bgmNameList, forKey: "SOUND")
////        UserDefaults.standard.setValue(alarmIDList, forKey: "FINSOUND")
////        UserDefaults.standard.setValue(timeList, forKey: "TIME")
////        UserDefaults.standard.setValue(minList, forKey: "MIN")
////        UserDefaults.standard.setValue(secList, forKey: "SEC")
//        self.timeManager.intervalList[myListIndex].listName = listName
//        self.timeManager.intervalList[myListIndex].taskList = taskList
//        self.timeManager.intervalList[myListIndex].bgmNameList = bgmNameList
//        self.timeManager.intervalList[myListIndex].alarmIDList = alarmIDList
//        self.timeManager.intervalList[myListIndex].timeList = timeList
//        self.timeManager.intervalList[myListIndex].minList = minList
//        self.timeManager.intervalList[myListIndex].secList = secList
//
//        saveIntervalList(intervalList: timeManager.intervalList)
//        self.timeManager.setTimer()
//    }
//    
//    func addDetailToList(task: String, bgmName: String, alarmID: Int, time: Int, min: Int, sec: Int, myListIndex: Int) {
//        timeManager.intervalList[myListIndex].taskList.append(task)
//        timeManager.intervalList[myListIndex].bgmNameList.append(bgmName)
//        timeManager.intervalList[myListIndex].alarmIDList.append(alarmID)
//        timeManager.intervalList[myListIndex].timeList.append(time)
//        timeManager.intervalList[myListIndex].minList.append(min)
//        timeManager.intervalList[myListIndex].secList.append(sec)
//        saveIntervalList(intervalList: timeManager.intervalList)
//        self.timeManager.setTimer()
//    }
//    
//    func saveIntervalList(intervalList: [IntervalList]) {
//        let jsonEncoder = JSONEncoder()
//        guard let data = try? jsonEncoder.encode(intervalList) else {
//            return
//        }
//        UserDefaults.standard.set(data, forKey: "LIST2")
//    }
//
//}

//struct MyListDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyListDetailView(myListIndex: 0)
//            .environmentObject(TimeManager())
//    }
//}

