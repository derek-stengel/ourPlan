//
//  HomeScreenGradient.swift
//  ourPlan
//
//  Created by Derek Stengel on 9/9/24.
//

import Foundation
import SwiftUI

struct HomeScreenGradient: ViewModifier {
    private let gradient = Gradient(colors: [Color(hex: "#FF0000"), Color(hex: "#000000"), Color(hex: "#FF0000"), Color(hex: "#000000"), Color(hex: "#FF0000")])
    private let lineWidth: CGFloat = 3.5
    private let animationDuration: Double = 2
    
    @Binding var selectedColor: UIColor
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
    func rotatingGradientBorderHome(selectedColor: Binding<UIColor>) -> some View {
        self.modifier(HomeScreenGradient(selectedColor: selectedColor))
    }
}

