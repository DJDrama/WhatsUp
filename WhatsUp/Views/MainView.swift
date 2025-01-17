//
//  MainView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            GroupListContainerView()
                .tabItem{
                    Label("Chats", systemImage: "message.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainView()
}
