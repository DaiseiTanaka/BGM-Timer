//
//  NotificationModel.swift
//  Interval_Timer
//
//  Created by 田中大誓 on 2022/10/17.
//
import SwiftUI
import UserNotifications

class NotificationModel: ObservableObject {
    @EnvironmentObject var timeManager: TimeManager

    @State var notificationIdentifier = "NotificationTest"

    func setNotification(){

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted {
                //許可
                self.makeNotification()
            }else{
                //非許可
            }
        }

    }

    func makeNotification(){
        //日時
        for num in 0..<self.timeManager.intervalList[self.timeManager.pageIndex].timeList.count {
            
            notificationIdentifier = self.timeManager.taskList[num]
            let notificationDate = Date().addingTimeInterval(num == 0 ? TimeInterval(self.timeManager.duration) : TimeInterval(self.timeManager.intervalList[self.timeManager.pageIndex].timeList[num]))
            let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)

            //日時でトリガー指定
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)

            //通知内容
            let content = UNMutableNotificationContent()
            content.title = "\(self.timeManager.intervalList[self.timeManager.pageIndex].taskList[num])"
            content.body = "Timer Finished"
            content.sound = UNNotificationSound.default

            //リクエスト作成
            let request = UNNotificationRequest(identifier: self.notificationIdentifier, content: content, trigger: trigger)

            //通知をセット
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }

    func removeNotification(){
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.notificationIdentifier])
    }
}
