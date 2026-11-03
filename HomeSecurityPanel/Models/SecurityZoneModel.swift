//
//  SecurityZoneModel.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//

import Foundation

struct SecurityZoneModel: Identifiable, Codable {
    let id: UUID
    let name: String
    var isArmed: Bool
    let batteryLevel: Int
    let sensorStatus: String
    let iconName: String
}
