//
//  CircleView.swift
//  PraktoTracker3000
//
//  Created by ANTON ZVERKOV on 27.02.2025.
//

import SwiftUI

struct CircleView: View {
    
    var missionProgress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.5), lineWidth: 3)
                .opacity(0.3)
            Circle()
                .trim(from: 0, to: CGFloat(missionProgress))
                .stroke(.purple, lineWidth: 5)
                .rotationEffect(.degrees(-90))
            Text("\(Int(missionProgress * 100))%")
                .foregroundStyle(.purple)
                .font(.title2)
//                .bold()
        }
        .frame(width: 200, height: 200)
    }
}

#Preview {
    ZStack {
        Color.orange
        CircleView(missionProgress: 0.33)
    }
}
