//
//  SettingButton.swift
//  Qiita_Timer
//
//  Created by masanao on 2020/10/22.
//

import SwiftUI

struct SettingButtonView: View {
    @EnvironmentObject var timeManager: TimeManager
    
    var body: some View {
        Image(systemName: "ellipsis.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .onTapGesture {
                self.timeManager.isSetting = true
                //debug
                print(self.timeManager.isSetting)
            }
    }
}

struct SettingButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingButtonView()
            .environmentObject(TimeManager())
            .previewLayout(.sizeThatFits)
    }
}
