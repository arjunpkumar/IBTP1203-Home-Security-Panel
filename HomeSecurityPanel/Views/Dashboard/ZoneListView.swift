//
//  ZoneListView.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//
import SwiftUI

import SwiftUI

struct ZoneListView: View {
    @Environment(SecurityManager.self) private var securityManager

    var body: some View {
        NavigationStack {
            List {
                ForEach(securityManager.zones) { zone in
                    HStack(spacing: 16) {
                        Image(systemName: zone.iconName)
                            .font(.title2)
                            .foregroundColor(zone.isArmed ? .blue : .orange)
                            .frame(width: 32)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(zone.name)
                                .font(.headline)
                            Text("Battery: \(zone.batteryLevel)% • Status: \(zone.sensorStatus)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { zone.isArmed },
                            set: { _ in securityManager.toggleZone(zone) }
                        ))
                        .labelsHidden()
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Security Zones")
        }
    }
}

#Preview {
    ZoneListView()
        .environment(SecurityManager())
}
