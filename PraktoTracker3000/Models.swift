//
//  Models.swift
//  PraktoTracker
//
//  Created by ANTON ZVERKOV on 26.02.2025.
//

import Foundation

enum EventType {
    case long
    case short
    case day
}

enum CourseType {
    case basic
    case extended
}

struct Event: Identifiable {
    let id: UUID = UUID()
    let title: String
    let startDate: Date
    let endDate: Date
    let description: String?
    
    var type: EventType {
        let length = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return switch length {
        case ..<1: .short
        case 1: .day
        default: .long
        }
    }
    var betterTitle: String {
        let pattern = "(\\S+)\\s+когорта\\s+\\S+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let modifiedString = regex.stringByReplacingMatches(in: title, options: [], range: NSRange(location: 0, length: title.count), withTemplate: "")
        return modifiedString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var timeInterval: String {
        return switch type {
        case .short: "\(startDate.toTime) - \(endDate.toTime)"
        case .long, .day: "\(startDate.toString) - \(endDate.toString)"
        }
    }
    var daysLeft: String? {
        guard type == .long else { return nil }
        let components = Calendar.current.dateComponents([.day], from: Date(), to: endDate)
        let i = components.day ?? 0
        return String(i)
    }
}

struct Payments {
    let all: [String] = [
        "05.02.2025",
        "07.03.2025",
        "06.04.2025",
        "06.05.2025",
        "05.06.2025",
        "05.07.2025",
        "04.08.2025",
        "03.09.2025",
        "03.10.2025", // - last normal
        "02.11.2025",
        "02.12.2025",
        "01.01.2026", // - last extended
    ]
    var basic: [String] { Array(all.prefix(upTo: 9)) }
    var extended: [String] { self.all }
}
