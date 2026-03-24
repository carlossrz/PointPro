//
//  PPButtonSlider.swift
//  PointWatch Watch App
//
//  Created by Carlos Suarez on 7/5/25.
//

import SwiftUI

struct PPButtonSlider: View {
    @State var text: String = "start".localizedValue
    @State var offset: CGFloat = .zero
    @State var widthOfSlide: CGFloat = .zero
    @State var userDragging: Bool = false

    var action: () -> Void = {}
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation {
                    offset = max(0, value.translation.width)
                    userDragging = true
                }
            }
            .onEnded { value in
                withAnimation {
                    userDragging = false
                    if value.translation.width >= (widthOfSlide * 0.7) {
                        offset = widthOfSlide - 10
                        action()
                        offset = .zero
                    } else {
                        offset = .zero
                    }
                }
            }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack(alignment: .center) {
                    HStack {
                        ZStack{
                            Text("🎾")
                                .font(.system(size: 40, weight: .bold, design: .monospaced))
                                .padding(.horizontal, 10)
                            Image(systemName: "chevron.right")
                                .resizable()
                                .frame(width: 15, height: 20)
                                .foregroundColor(.black)
                        }.offset(x: offset)
                         .gesture(drag)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.ppBlue)
                    .clipShape(.capsule)
                    .scaleEffect(userDragging ? 0.99 : 1.0)
                    .onTapGesture {
                        withAnimation {
                            userDragging = true
                            offset = 20
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation {
                                userDragging = false
                                offset = .zero
                            }
                        }
                    }
                    
                    Text(text.localizedValue)
                        .opacity(userDragging ? 0.5 : 1.0)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                        .font(.title3)
                }
                .onAppear {
                    widthOfSlide = geometry.size.width - 50 - 10
                }
            }
        }
        .padding(.horizontal)
    }
}


#Preview {
    PPButtonSlider()
}
