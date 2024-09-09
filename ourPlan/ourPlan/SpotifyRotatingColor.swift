//
//  RotatingColor.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/3/24.
//

import Foundation
import SwiftUI

struct RotatingColorModifier: ViewModifier {
    private let gradient = Gradient(colors: [Color(hex: "#00bb3e"), Color(hex: "#ffffff"), Color(hex: "#62f1a3"), Color(hex: "#000000"), Color(hex: "#00bb3e")])
    private let lineWidth: CGFloat = 3.5
    private let animationDuration: Double = 2
    
    @State private var rotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        AngularGradient(
                            gradient: gradient,
                            center: .center,
                            startAngle: .degrees(rotation),
                            endAngle: .degrees(rotation + 360)
                        ),
                        lineWidth: lineWidth
                    )
                    .animation(
                        Animation.linear(duration: animationDuration)
                            .repeatForever(autoreverses: false),
                        value: rotation
                    )
//                    .opacity(0.8) // uncomment this line if you want opacity functionality
            )
            .onAppear {
                rotation = 360
            }
    }
}


extension View {
    func rotatingGradientBorder() -> some View {
        self.modifier(RotatingColorModifier())
    }
}
