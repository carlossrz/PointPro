//
//  SidePerformaceChart.swift
//  PointPro
//
//  Created by Carlos Suarez on 18/6/25.
//

import SwiftUI
import Charts

struct PositionStat: Identifiable {
    var id = UUID()
    var side: String
    var result: String
    var count: Int
}

struct SidePerformanceChart: View {
    var data: [PositionStat]
    
    var body: some View {
        Chart(data) { stat in
            BarMark(
                x: .value("", stat.side),
                y: .value("", stat.count)
            )
            .foregroundStyle(by: .value("", stat.result))
            .position(by: .value("", stat.result))
            .annotation(position: .top) {
                Text("\(stat.count)")
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .chartXAxis{
            AxisMarks(preset: .aligned) { _ in
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks() { _ in
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartForegroundStyleScale([
            "text.wins".localizedValue: .ppGreenBall.opacity(0.8),
            "text.losses".localizedValue: .ppBlue.opacity(0.8)
        ])
        .chartLegend(position: .top)
        .frame(height: 150)
    }
}


#Preview {
    SidePerformanceChart(data: [
        PositionStat(side: "left".localizedValue, result: "text.wins".localizedValue, count: 10),
        PositionStat(side: "right".localizedValue, result: "text.losses".localizedValue, count: 15),
        PositionStat(side: "rigth".localizedValue, result: "text.wins".localizedValue, count: 7),
        PositionStat(side: "left".localizedValue, result: "text.losses".localizedValue, count: 5)
    ])
}
