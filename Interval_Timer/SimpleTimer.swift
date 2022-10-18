//
//  Qiita_TimerApp.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/15.
//

import SwiftUI

@main
struct SimpleTimer: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        
        WindowGroup {
            ContentView().environmentObject(TimeManager())
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct SimpleTimer_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(TimeManager())
        }
    }
}
