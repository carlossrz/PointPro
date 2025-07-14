//
//  PPCountDown.swift
//  PointPro
//
//  Created by Carlos Suarez on 11/7/25.
//

import SwiftUI
import WatchKit

struct PPCountDown: View {
    let initialCount: Int
    var onFinished: () -> Void
    
    @State private var countdown: Int
    @State private var started = false
    @State private var timer: Timer? = nil
    @State private var progress: Double = 0.0
    
    init(initialCount: Int, onFinished: @escaping () -> Void) {
        self.initialCount = initialCount
        self.onFinished = onFinished
        _countdown = State(initialValue: initialCount)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.2)
                .foregroundColor(.ppGreenBall)
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .foregroundColor(.ppGreenBall)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
            
            if countdown > 0 {
                Text("\(countdown)")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.ppGreenBall)
                    .onAppear {
                        startCountdown()
                    }
            } else {
                Text("text.ready".localizedValue)
                    .font(.system(size: 25))
                    .foregroundColor(.ppGreenBall)
                    .onAppear {
                        WKInterfaceDevice.current().play(.start)
                    }
            }
        }
        .frame(width: 140, height: 140)
    }
    
    private func startCountdown() {
        guard !started else { return }
        started = true
        
        WKInterfaceDevice.current().play(.click)
        updateProgress()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { t in
            if countdown > 1 {
                countdown -= 1
                updateProgress()
                WKInterfaceDevice.current().play(.click)
            } else {
                countdown = 0
                updateProgress()
                t.invalidate()
                onFinished()
            }
        }
    }
    
    private func updateProgress() {
        let completed = Double(initialCount - countdown + 1)
        progress = max(0, min(1, completed / Double(initialCount)))
    }
}

#Preview {
    PPCountDown(initialCount: 2){}
}
