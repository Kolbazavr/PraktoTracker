//
//  EventView.swift
//  PraktoTracker3000
//
//  Created by ANTON ZVERKOV on 27.02.2025.
//

import SwiftUI

struct EventView: View {
    
    var event: Event
    
    func trimURL(url: String) -> String {
        if let lastSlashRange = url.range(of: "/", options: .backwards) {
            let trimmedURL = url[..<lastSlashRange.lowerBound]
            return String(trimmedURL)
        }
        return url
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.betterTitle)
                .font(event.type == .long ? .title : .headline)
                .foregroundStyle(event.type == .long ? .purple : .secondary)
                .bold(event.type == .long ? true : false)
            Text(event.timeInterval)
                .foregroundStyle(event.type == .long ? .purple : .secondary)
            if let description = event.description {
                if let url = URL(string: description), UIApplication.shared.canOpenURL(url) {
                    Link(destination: url) {
                        Text(trimURL(url: description))
                    }
                } else {
                    Text("\(description)")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            if let daysLeft = event.daysLeft {
                if event.startDate < Date() {
                    Divider()
                    Text("days left: \(daysLeft)")
                        .foregroundStyle(.purple)
                        .font(.title)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
        .shadow(color: .gray.opacity(0.3), radius: 30, x: 0, y: 30)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.linearGradient(colors: [.white.opacity(0.8), .white.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)))
    }
}

#Preview {
    EventView(event: Event(title: "Sprint 1", startDate: Date() - 200000, endDate: Date() + 200000, description: "Sprint description"))
    EventView(event: Event(title: "Zoom meeting", startDate: Date(), endDate: Date() + 10000, description: "https://example.com/zoom"))
}
