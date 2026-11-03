//
//  HomeSecurityPanelApp.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//
import SwiftUI

@main
struct HomeSecurityPanelApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

// Add this preview block at the bottom of the file:
#Preview {
    MainTabView()
}
