//
//  SecurityEventModel.swift
//  HomeSecurityPanel
//
//  Created by thinkpalm on 02/11/26.
//
import SwiftUI

struct SecurityEventModel: Identifiable, Codable {
    let id: UUID
    let title: String
    let timestamp: String
    let severity: EventSeverity
    
    enum EventSeverity: String, Codable {
        case info, warning, critical
        var color: Color {
            switch self {
            case .info: return .blue
            case .warning: return .orange
            case .critical: return .red
            }
        }
    }
}
