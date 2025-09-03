//
//  ClockImageView.swift
//  Unibell
//
//  Created by hyunsuh ham on 8/6/24.
//
import SwiftUI

struct ClockImageView: View {
    @State var current_Time = Time(min: 0, sec: 0, hour: 0)
    @State var receiver = Timer.publish(every: 1, on: .current, in: .default).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let outerCircleRadius = size / 2
            let innerCircleRadius = outerCircleRadius - 30

            ZStack {
                // Clock ticks
                ForEach(0..<60, id: \.self) { i in
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 1, height: (i % 5) == 0 ? 20 : 5)
                        .offset(y: -outerCircleRadius + 15)
                        .rotationEffect(.degrees(Double(i) * 6))
                }

                // Second hand
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 1.2, height: innerCircleRadius)
                    .offset(y: -innerCircleRadius / 2)
                    .rotationEffect(.degrees(Double(current_Time.sec) * 6))
                
                // Minute hand
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 1.2, height: innerCircleRadius * 0.9)
                    .offset(y: -innerCircleRadius * 0.9 / 2)
                    .rotationEffect(.degrees(Double(current_Time.min) * 6))

                // Hour hand
                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 1.2, height: innerCircleRadius * 0.7)
                    .offset(y: -innerCircleRadius * 0.7 / 2)
                    .rotationEffect(.degrees(Double(current_Time.hour) * 30 + Double(current_Time.min) * 0.5))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear(perform: {
            updateTime()
        })
        .onReceive(receiver) { _ in
            updateTime()
        }
    }

    private func updateTime() {
        let calendar = Calendar.current
        let min = calendar.component(.minute, from: Date())
        let sec = calendar.component(.second, from: Date())
        let hour = calendar.component(.hour, from: Date()) % 12
        withAnimation(.linear(duration: 0.01)) {
            self.current_Time = Time(min: min, sec: sec, hour: hour)
        }
    }

    struct Time {
        var min: Int
        var sec: Int
        var hour: Int
    }
}
#Preview {
    ClockImageView()
}
