//
//  MainTabView.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var securityManager = SecurityManager()

    var body: some View {
        TabView {
            ZoneListView()
                .tabItem {
                    Label("Zones", systemImage: "shield.checkered")
                }
            
            EventHistoryView()
                .tabItem {
                    Label("Events", systemImage: "clock.arrow.circlepath")
                }
        }
        .environment(securityManager)
    }
}

#Preview {
    MainTabView()
}
