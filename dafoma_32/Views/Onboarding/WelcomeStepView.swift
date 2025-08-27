//
//  WelcomeStepView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct WelcomeStepView: View {
    @State private var animateTitle = false
    @State private var animateSubtitle = false
    @State private var animateFeatures = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Icon/Logo
            Image(systemName: "globe.americas.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "#bd0e1b"))
                .scaleEffect(animateTitle ? 1.0 : 0.5)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateTitle)
            
            // Title
            Text("LinguaEducate Kan")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .opacity(animateTitle ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateTitle)
            
            // Subtitle
            Text("Master Languages, Maximize Earnings")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(hex: "#ffbe00"))
                .opacity(animateSubtitle ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.6), value: animateSubtitle)
            
            Spacer()
            
            // Features
            VStack(spacing: 20) {
                FeatureRow(
                    icon: "map.fill",
                    title: "Location-Based Learning",
                    description: "Challenges adapt to your geographic location"
                )
                .opacity(animateFeatures ? 1.0 : 0.0)
                .offset(x: animateFeatures ? 0 : -50)
                .animation(.easeInOut(duration: 0.6).delay(0.9), value: animateFeatures)
                
                FeatureRow(
                    icon: "dollarsign.circle.fill",
                    title: "Financial Impact Calculator",
                    description: "See how languages boost your earning potential"
                )
                .opacity(animateFeatures ? 1.0 : 0.0)
                .offset(x: animateFeatures ? 0 : 50)
                .animation(.easeInOut(duration: 0.6).delay(1.1), value: animateFeatures)
                
                FeatureRow(
                    icon: "gamecontroller.fill",
                    title: "Gamified Learning",
                    description: "Earn XP, unlock achievements, track progress"
                )
                .opacity(animateFeatures ? 1.0 : 0.0)
                .offset(x: animateFeatures ? 0 : -50)
                .animation(.easeInOut(duration: 0.6).delay(1.3), value: animateFeatures)
                
                FeatureRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Proficiency Mapping",
                    description: "Visualize your skills across global markets"
                )
                .opacity(animateFeatures ? 1.0 : 0.0)
                .offset(x: animateFeatures ? 0 : 50)
                .animation(.easeInOut(duration: 0.6).delay(1.5), value: animateFeatures)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .onAppear {
            animateTitle = true
            animateSubtitle = true
            animateFeatures = true
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "#bd0e1b"))
                .frame(width: 40, height: 40)
                .background(Color(hex: "#0a1a3b"))
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

#Preview {
    WelcomeStepView()
        .background(Color(hex: "#02102b"))
}
