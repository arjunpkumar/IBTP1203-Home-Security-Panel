//
//  SecurityManager.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//
import SwiftUI

@Observable
class SecurityManager {
    private let zonesKey = "saved_security_zones"
    private let eventsKey = "saved_security_events"

    var zones: [SecurityZoneModel] {
        didSet { saveZones() }
    }
    
    var events: [SecurityEventModel] {
        didSet { saveEvents() }
    }

    init() {
        // Load saved zones or fallback to default mock data if none exist
        if let savedData = UserDefaults.standard.data(forKey: zonesKey),
           let decodedZones = try? JSONDecoder().decode([SecurityZoneModel].self, from: savedData) {
            self.zones = decodedZones
        } else {
            self.zones = [
                SecurityZoneModel(id: UUID(), name: "Front Door Entry", isArmed: true, batteryLevel: 92, sensorStatus: "Secure", iconName: "shield.fill"),
                SecurityZoneModel(id: UUID(), name: "Living Room Motion", isArmed: true, batteryLevel: 85, sensorStatus: "Secure", iconName: "eye.fill"),
                SecurityZoneModel(id: UUID(), name: "Backyard Perimeter", isArmed: false, batteryLevel: 74, sensorStatus: "Attention", iconName: "lock.shield.fill"),
                SecurityZoneModel(id: UUID(), name: "Garage Access", isArmed: true, batteryLevel: 98, sensorStatus: "Secure", iconName: "door.garage.closed")
            ]
        }

        // Load saved events or fallback to default mock data
        if let savedData = UserDefaults.standard.data(forKey: eventsKey),
           let decodedEvents = try? JSONDecoder().decode([SecurityEventModel].self, from: savedData) {
            self.events = decodedEvents
        } else {
            self.events = [
                SecurityEventModel(id: UUID(), title: "System Initialized", timestamp: "10:42 AM", severity: .info)
            ]
        }
    }

    func toggleZone(_ zone: SecurityZoneModel) {
        if let index = zones.firstIndex(where: { $0.id == zone.id }) {
            zones[index].isArmed.toggle()
            let newState = zones[index].isArmed
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            let currentTime = formatter.string(from: Date())
            
            let eventTitle = "\(zones[index].name) \(newState ? "Armed" : "Disarmed")"
            let severity: SecurityEventModel.EventSeverity = newState ? .info : .warning
            
            let newEvent = SecurityEventModel(
                id: UUID(),
                title: eventTitle,
                timestamp: currentTime,
                severity: severity
            )
            
            events.insert(newEvent, at: 0)
        }
    }

    private func saveZones() {
        if let encoded = try? JSONEncoder().encode(zones) {
            UserDefaults.standard.set(encoded, forKey: zonesKey)
        }
    }

    private func saveEvents() {
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: eventsKey)
        }
    }
}
