//
//  ContentView.swift
//  PraktoTracker3000
//
//  Created by ANTON ZVERKOV on 26.02.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = PraktoViewModel()
    let payments = Payments()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .all)
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Super-Duper\nUltra-Mega\nPrakto-Tracker")
                        .foregroundStyle(.orange)
                        .font(.largeTitle)
                        .bold()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Today: \(Date().toString)")
                                .font(.headline)
                            Text("Days of iOS study: \(viewModel.daysOfStudy) (of \(viewModel.daysTotal))")
                                .font(.footnote)
                            Text("Days until iOS Valhalla: \(viewModel.daysTotal - viewModel.daysOfStudy)")
                                .font(.footnote)
                        }
                        VStack(alignment: .trailing) {
                            Text("\(viewModel.isExtendedCourse ? "extended" : "basic") course")
                                .font(.caption)
                            Toggle(isOn: $viewModel.isExtendedCourse) { }
                                .tint(Color.orange)
                                .onChange(of: viewModel.isExtendedCourse) { _, newValue in
                                    viewModel.refresh(for: newValue ? .extended : .basic)
                                }
                        }
                    }
                    
                    if let nextPayment = viewModel.getNextPaymentDate(payments: viewModel.isExtendedCourse ? payments.extended : payments.basic) {
                        Text("Next payment: \(nextPayment)")
                            .font(.headline)
                            .foregroundStyle(.orange)
                    }
                    Text("now:")
                        .foregroundStyle(.white)
                    Divider()
                    ForEach(viewModel.getCurrentEvents()) { event in
                        EventView(event: event)
                    }
                    Divider()
                    Text("next 5 events:")
                        .foregroundStyle(.white)
                }
                .padding()
                ZStack {
                    Color.white.opacity(0.5)
                    VStack(alignment: .leading) {
                        ForEach(viewModel.getNextEvents()) { event in
                            Text(event.startDate.toString)
                                .font(.footnote)
                            
                            EventView(event: event)
                        }
                    }
                    .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Total Progress:")
                    .foregroundStyle(.white)
                    .padding()
                CircleView(missionProgress: viewModel.progress)
                Button {
                    viewModel.refresh(for: viewModel.isExtendedCourse ? .extended : .basic)
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Refresh")
                    }
                        .padding()
                }
                .buttonStyle(.bordered)
                .foregroundStyle(.white)
                .padding()
            }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
                    .padding()
            }
            if let errorMessage = viewModel.errorMessage {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white.opacity(0.9))
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.purple)
                            .padding()
                        Text(errorMessage)
                            .foregroundColor(.purple)
                        Button {
                            viewModel.refresh(for: viewModel.isExtendedCourse ? .extended : .basic)
                        } label: {
                            Text("Try again!")
                        }
                        .padding()
                    }
                }
                .frame(width: 320, height: 150)
                
                
            }
        }
        .onAppear {
//            viewModel.isExtendedCourse = UserDefaults.standard.bool(forKey: "isExtendedCourse")
            withAnimation {
                viewModel.refresh(for: viewModel.isExtendedCourse ? .extended : .basic)
            }
        }
    }
}

#Preview {
    ContentView()
}
