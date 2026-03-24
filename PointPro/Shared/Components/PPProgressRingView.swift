//
//  PPProgressRingView.swift
//  PointPro
//
//  Created by Carlos Suarez on 24/6/25.
//

import SwiftUI

struct PPProgressRingView: View {
    var progress: Double? = nil
    var actual: Int? = nil
    var total: Int? = nil
    
    private var computedProgress: Double {
        if let progress = progress {
            return min(max(progress, 0), 1)
        }
        if let actual = actual, let total = total, total > 0 {
            return Double(actual) / Double(total)
        }
        return 0
    }
    
    private var progressText: String {
        if let progress = progress, (actual == nil || total == nil) {
            let percent = Int(min(max(progress, 0), 1) * 100)
            return "\(percent)%"
        }
        if let actual = actual, let total = total, total > 0 {
            return "\(actual)/\(total)"
        }
        return ""
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.ppBlue.opacity(0.5), lineWidth: 8)

            Circle()
                .trim(from: 0, to: computedProgress)
                .stroke(
                    Color.ppGreenBall,
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.8), value: computedProgress)

            Text(progressText)
                .font(.system(size:30, weight: .bold, design: .rounded))
                .foregroundColor(.ppBlue)
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    PPProgressRingView()
        .frame(height: 120)

}
