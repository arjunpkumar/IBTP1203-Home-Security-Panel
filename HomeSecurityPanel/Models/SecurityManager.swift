//
//  SecurityManager.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//
import SwiftUI
import UIKit

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
        if let savedData = UserDefaults.standard.data(forKey: zonesKey),
           let decodedZones = try? JSONDecoder().decode([SecurityZoneModel].self, from: savedData) {
            self.zones = decodedZones
        } else {
            self.zones = [
                SecurityZoneModel(id: UUID(), name: "Front Door Entry", isArmed: true, batteryLevel: 92, sensorStatus: "Secure", iconName: "shield.fill"),
                SecurityZoneModel(id: UUID(), name: "Living Room Motion", isArmed: true, batteryLevel: 85, sensorStatus: "Secure", iconName: "eye.fill"),
                SecurityZoneModel(id: UUID(), name: "Backyard Perimeter", isArmed: false, batteryLevel: 74, sensorStatus: "Attention", iconName: "lock.shield.fill"),
                SecurityZoneModel(id: UUID(), name: "Garage Access", isArmed: true, batteryLevel: 98, sensorStatus: "Secure", iconName: "door.garage.closed"),
                SecurityZoneModel(id: UUID(), name: "Master Bedroom Windows", isArmed: true, batteryLevel: 91, sensorStatus: "Secure", iconName: "window.casement.closed"),
                SecurityZoneModel(id: UUID(), name: "Upstairs Hallway", isArmed: true, batteryLevel: 88, sensorStatus: "Secure", iconName: "figure.walk.motion"),
                SecurityZoneModel(id: UUID(), name: "Back Patio Sliding Door", isArmed: false, batteryLevel: 65, sensorStatus: "Attention", iconName: "shield.fill"),
                SecurityZoneModel(id: UUID(), name: "Basement Storage", isArmed: true, batteryLevel: 95, sensorStatus: "Secure", iconName: "stairs")
            ]
        }

        if let savedData = UserDefaults.standard.data(forKey: eventsKey),
           let decodedEvents = try? JSONDecoder().decode([SecurityEventModel].self, from: savedData) {
            self.events = decodedEvents
        } else {
            self.events = [
                SecurityEventModel(id: UUID(), title: "System Initialized", timestamp: "10:42 AM", severity: .info)
            ]
        }
    }

    // Toggle individual zone with haptic feedback
    func toggleZone(_ zone: SecurityZoneModel) {
        if let index = zones.firstIndex(where: { $0.id == zone.id }) {
            zones[index].isArmed.toggle()
            let newState = zones[index].isArmed
            
            triggerHaptic(style: newState ? .medium : .light)
            
            let currentTime = getCurrentTimestamp()
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

    // New Feature: Master Lockdown (Arm/Disarm All Zones)
    func setAllZones(armed: Bool) {
        for index in zones.indices {
            zones[index].isArmed = armed
        }
        
        triggerHaptic(style: .heavy)
        
        let currentTime = getCurrentTimestamp()
        let eventTitle = armed ? "🚨 Master Lockdown: All Zones Armed" : "⚠️ System Wide Disarm Executed"
        let severity: SecurityEventModel.EventSeverity = armed ? .critical : .warning
        
        let newEvent = SecurityEventModel(
            id: UUID(),
            title: eventTitle,
            timestamp: currentTime,
            severity: severity
        )
        
        events.insert(newEvent, at: 0)
    }

    private func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: Date())
    }

    private func triggerHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
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
    
    // Clear all event history logs
        func clearHistory() {
            events.removeAll()
            let currentTime = getCurrentTimestamp()
            let resetEvent = SecurityEventModel(
                id: UUID(),
                title: "Event History Cleared",
                timestamp: currentTime,
                severity: .info
            )
            events.append(resetEvent)
            triggerHaptic(style: .medium)
        }
}
