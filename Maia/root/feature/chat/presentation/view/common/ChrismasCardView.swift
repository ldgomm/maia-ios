//
//  ChrismasCardView.swift
//  Maia
//
//  Created by José Ruiz on 25/11/24.
//

import SwiftUI

struct ChrismasCardView: View {
    @State private var isAnimating = false
    let symbols = ["gift.fill", "snowflake", "bell.fill", "snowflake", "star.fill", "snowflake", "cloud.snow.fill", "snowflake"]
    let colors: [Color] = [.red, .green, .blue, .pink, .indigo, .cyan]
    
    var body: some View {
        ZStack {
            ForEach(0 ..< 30, id: \.self) { index in
                FallingSymbolView(
                    symbol: symbols.randomElement() ?? "snowflake",
                    color: colors.randomElement() ?? .red,
                    duration: Double.random(in: 7...11),
                    delay: Double.random(in: 0...5),
                    scale: CGFloat.random(in: 0.1...0.7)
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 11))
        .padding(.horizontal)
        .onAppear {
            isAnimating = true
        }
    }
}

struct FallingSymbolView: View {
    let symbol: String
    let color: Color
    let duration: Double
    let delay: Double
    let scale: CGFloat // Added scale property
    @State private var opacity: Double = 0
    @State private var positionY: CGFloat = -100
    
    var body: some View {
        Image(systemName: symbol)
            .resizable()
            .scaledToFit()
            .frame(width: 40 * scale, height: 40 * scale) // Apply scale
            .foregroundColor(symbol == "snowflake" ? .gray.opacity(0.5) : color)
            .opacity(opacity)
            .position(x: CGFloat.random(in: 0 ... UIScreen.main.bounds.width), y: positionY)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: duration).repeatForever(autoreverses: false).delay(delay)) {
                    opacity = 5
                    positionY = UIScreen.main.bounds.height + 50
                }
            }
    }
}

#Preview {
    ChrismasCardView()
}

