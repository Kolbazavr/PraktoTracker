//
//  Loader.swift
//  PraktoTracker3000
//
//  Created by ANTON ZVERKOV on 26.02.2025.
//

import Foundation

class Loader {
    
    func parseDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "MSK")
        return dateFormatter.date(from: dateString)
    }
    func parseDateTZ(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "MSK")
        return dateFormatter.date(from: dateString)
    }
    func parseICS(icsString: String) throws -> [Event] {
        
        var events: [Event] = []
            let lines = icsString.components(separatedBy: .newlines)
            var currentEvent: [String: Any] = [:]
            
            for line in lines {
                if line.hasPrefix("BEGIN:VEVENT") {
                    currentEvent = [:]
                } else if line.hasPrefix("END:VEVENT") {
                    if let title = currentEvent["title"] as? String,
                       let startDate = currentEvent["startDate"] as? Date,
                       let endDate = currentEvent["endDate"] as? Date {
                        let newEvent = Event(
                            title: title,
                            startDate: startDate,
                            endDate: endDate,
                            description: currentEvent["description"] as? String
                        )
                        events.append(newEvent)
                    }
                } else if line.hasPrefix("SUMMARY:") {
                    currentEvent["title"] = String(line.dropFirst("SUMMARY:".count))
                } else if line.hasPrefix("DTSTART;VALUE=DATE:") {
                    let dateString = String(line.dropFirst("DTSTART;VALUE=DATE:".count))
                    if let date = parseDate(from: dateString) {
                        currentEvent["startDate"] = date
                    }
                } else if line.hasPrefix("DTSTART;TZID=Europe/Moscow:") {
                    let dateString = String(line.dropFirst("DTSTART;TZID=Europe/Moscow:".count))
                    if let date = parseDateTZ(from: dateString) {
                        currentEvent["startDate"] = date
                    }
                } else if line.hasPrefix("DTEND;VALUE=DATE:") {
                    let dateString = String(line.dropFirst("DTEND;VALUE=DATE:".count))
                    if let date = parseDate(from: dateString) {
                        currentEvent["endDate"] = date
                    }
                } else if line.hasPrefix("DTEND;TZID=Europe/Moscow:") {
                    let dateString = String(line.dropFirst("DTEND;TZID=Europe/Moscow:".count))
                    if let date = parseDateTZ(from: dateString) {
                        currentEvent["endDate"] = date
                    }
                } else if line.hasPrefix("DESCRIPTION:") {
                    currentEvent["description"] = String(line.dropFirst("DESCRIPTION:".count))
                }
            }

            events.sort { $0.startDate < $1.startDate }
        if events.isEmpty {
            print("no Events found after parsing")
            throw PraktoError.missingDataError
        }
            
        print("parseICS finished")
        return events
    }
    
    func calendarUrl(urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else {
            throw PraktoError.invalidURL
        }
        return url
    }
    
    func fetchICSThingy(for courseType: CourseType) async throws -> String {
        let calendarUrl = try self.calendarUrl(urlString: courseType == .basic ? pachkaBasicURLString : pachkaExtendedURLString)
        
        let (data, response) = try await URLSession.shared.data(from: calendarUrl)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw PraktoError.serverError
        }
        if let stringData = String(data: data, encoding: .utf8) {
            print("fetched some string...")
            return stringData
        } else {
            throw PraktoError.missingDataError
        }
    }
}
