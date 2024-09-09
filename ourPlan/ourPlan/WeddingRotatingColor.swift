import Foundation
import SwiftUI

struct RotatingColorModifierTwo: ViewModifier {
    private let gradient: Gradient
    private let lineWidth: CGFloat = 4
    private let animationDuration: Double = 3.5
    
    @Binding var selectedColor: UIColor
    @State private var rotation: Double = 0
    
    init(selectedColor: Binding<UIColor>) {
        self._selectedColor = selectedColor
        self.gradient = Gradient(colors: [
            Color(hex: "#ffffff"),
            Color(selectedColor.wrappedValue),
            Color(selectedColor.wrappedValue),
            Color(hex: "#ffffff")
        ])
    }
    
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
            )
            .onAppear {
                rotation = 360
            }
    }
}

extension View {
    func rotatingGradientBorderTwo(selectedColor: Binding<UIColor>) -> some View {
        self.modifier(RotatingColorModifierTwo(selectedColor: selectedColor))
    }
}


