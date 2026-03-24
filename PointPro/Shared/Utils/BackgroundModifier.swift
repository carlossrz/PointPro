//
//  BackgroundModifier.swift
//  PointPro
//
//  Created by Carlos Suarez on 10/6/25.
//
import SwiftUI

enum BackgroundVersion {
    case watchOS
    case iOS
}

struct BackgroundModifier: ViewModifier {
    var color: Color = .ppBlue
    var backgroundVersion : BackgroundVersion = .watchOS
    
    func body(content: Content) -> some View {
        switch backgroundVersion {
        case .watchOS:
            ZStack {
                color
                    .ignoresSafeArea()
                
                Rectangle()
                    .frame(width: 3, height: 300)
                    .foregroundColor(.white)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 3)
                    .padding(.bottom, 170)
                    .foregroundColor(.white)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 3)
                    .padding(.top, 170)
                    .foregroundColor(.white)
                
                content
            }
        case .iOS:
            ZStack(alignment: .top) {
                Color.gray.opacity(0.4).ignoresSafeArea()
                CurvedHeader(color: color)
                    .ignoresSafeArea(edges: .top)
                content
            }
        default:
           content
        }
    }
    
    struct CurvedHeader: View {
        var color: Color = .ppBlue
        @State private var randomShape = RandomCurvedShape(
            control1Y: CGFloat.random(in: 50...200),
            control2Y: CGFloat.random(in: 50...200),
            endY: CGFloat.random(in: 0...100)
        )

        var body: some View {
            ZStack {
                randomShape
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.8), color],
                            startPoint: .leading,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 400)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            randomShape = CurvedHeader.generateRandomShape()
                        }
                    }
            }
        }

        static func generateRandomShape() -> RandomCurvedShape {
            RandomCurvedShape(
                control1Y: CGFloat.random(in: 50...200),
                control2Y: CGFloat.random(in: 50...200),
                endY: CGFloat.random(in: 0...100)
            )
        }
    }
    
    struct RandomCurvedShape: Shape {
        var control1Y: CGFloat
        var control2Y: CGFloat
        var endY: CGFloat

        var animatableData: AnimatablePair<CGFloat, AnimatablePair<CGFloat, CGFloat>> {
            get { AnimatablePair(control1Y, AnimatablePair(control2Y, endY)) }
            set {
                control1Y = newValue.first
                control2Y = newValue.second.first
                endY = newValue.second.second
            }
        }

        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: .zero)
            path.addLine(to: CGPoint(x: 0, y: rect.height - 90))
            path.addCurve(
                to: CGPoint(x: rect.width, y: rect.height - endY),
                control1: CGPoint(x: rect.width * 0.25, y: rect.height - control1Y),
                control2: CGPoint(x: rect.width * 0.75, y: rect.height - control2Y)
            )
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.closeSubpath()
            
            return path
        }
    }

}
