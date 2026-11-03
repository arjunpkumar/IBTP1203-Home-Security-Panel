//
//  EventHistoryView.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//

import SwiftUI

import SwiftUI

struct EventHistoryView: View {
    @Environment(SecurityManager.self) private var securityManager
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            List(securityManager.events) { event in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(event.severity.color)
                        .frame(width: 10, height: 10)
                        .padding(.top, 6)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title)
                            .font(.subheadline)
                            .bold()
                        Text(event.timestamp)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Event History")
            .refreshable {
                await fetchNewEvents()
            }
        }
    }
    
    func fetchNewEvents() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

#Preview {
    EventHistoryView()
        .environment(SecurityManager())
}
