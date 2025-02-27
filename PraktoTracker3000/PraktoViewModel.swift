//
//  PraktoViewModel.swift
//  PraktoTracker3000
//
//  Created by ANTON ZVERKOV on 27.02.2025.
//

import Foundation

class PraktoViewModel: ObservableObject {
    
    @Published var allEvents: [Event] = []
    @Published var currentEvents: [Event] = []
    @Published var nextEvents: [Event] = []
    @Published var daysOfStudy: Int = 0
    @Published var daysTotal: Int = 0
    @Published var progress: Double = 0
    
    @Published var isLoading: Bool = true
    @Published var errorMessage: String?
    
    @Published var isExtendedCourse: Bool { didSet { saveIsExtendedCourse() } }
    
    init() {
        self.isExtendedCourse = UserDefaults.standard.bool(forKey: "isExtendedCourse")
    }
    
    let loader = Loader()
    
    func getCurrentEvents() -> [Event] {
        let today = Calendar.current.startOfDay(for: Date())
//        let todayTest: Date = Calendar.current.date(from: DateComponents(year: 2025, month: 3, day: 5))!
        return allEvents.filter { ($0.startDate <= today && $0.endDate >= today) || (Calendar.current.isDate($0.startDate, inSameDayAs: today))}
    }
    
    func getNextEvents() -> [Event] {
        let currentDate = Date()
        let upcomingEvents: [Event] = allEvents.filter { $0.startDate > currentDate }
        return Array(upcomingEvents.prefix(5))
    }
    
    func getTotalDays() -> Int {
        let firstDay = allEvents.first?.startDate ?? Date()
        let lastDay = allEvents.last?.endDate ?? Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: firstDay, to: lastDay)
        return dateComponents.day ?? 0
    }
    
    func getDaysOfStudy() -> Int {
        let firstDay = allEvents.first?.startDate ?? Date()
        let currentDate = Date()
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.day], from: firstDay, to: currentDate)
        return dateComponents.day ?? 0
    }
    
    func getNextPaymentDate(payments: [String]) -> String? {
        let paymentsDate: [Date] = payments.compactMap(\.toDate)
        return paymentsDate.first(where: { $0 > Date() })?.toString ?? "No future payments"
    }
    
    func refresh(for courseType: CourseType) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let icsString = try await loader.fetchICSThingy(for: courseType)
                let parsedEvents: [Event] = try loader.parseICS(icsString: icsString)
                await MainActor.run {
                    self.allEvents = parsedEvents
                    self.currentEvents = self.getCurrentEvents()
                    self.nextEvents = self.getNextEvents()
                    self.daysOfStudy = self.getDaysOfStudy()
                    self.daysTotal = self.getTotalDays()
                    self.progress = Double(daysOfStudy) / Double(daysTotal)
                    self.isLoading = false
                }
                
            } catch PraktoError.invalidURL {
                errorMessage = "URL problem"
            } catch PraktoError.decodingError {
                errorMessage = "Decoding error"
            } catch PraktoError.missingDataError {
                errorMessage = "Missing data for some reason"
            } catch PraktoError.serverError {
                errorMessage = "Server is very bad today"
            } catch {
                errorMessage = "I dunno what went wrong"
            }
            
        }
    }
    func saveIsExtendedCourse() {
        UserDefaults.standard.set(isExtendedCourse, forKey: "isExtendedCourse")
    }
}
