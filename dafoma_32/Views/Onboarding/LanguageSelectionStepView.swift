//
//  LanguageSelectionStepView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct LanguageSelectionStepView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateCards = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 10) {
                Text("Choose Your Languages")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Select the languages you want to learn")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 50)
            
            // Language Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(Array(Language.sampleLanguages.enumerated()), id: \.element.id) { index, language in
                        LanguageCard(
                            language: language,
                            isSelected: viewModel.selectedLanguages.contains(language)
                        ) {
                            withAnimation(.spring()) {
                                viewModel.selectLanguage(language)
                            }
                        }
                        .scaleEffect(animateCards ? 1.0 : 0.8)
                        .opacity(animateCards ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateCards)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Selection Info
            if !viewModel.selectedLanguages.isEmpty {
                VStack(spacing: 10) {
                    Text("Selected Languages:")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack {
                        ForEach(viewModel.selectedLanguages, id: \.id) { language in
                            HStack(spacing: 5) {
                                Text(language.flag)
                                Text(language.name)
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#bd0e1b"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
        }
        .onAppear {
            animateCards = true
        }
    }
}

struct LanguageCard: View {
    let language: Language
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Flag
                Text(language.flag)
                    .font(.system(size: 40))
                
                // Language Name
                Text(language.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                // Difficulty Badge
                Text(language.difficulty.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(hex: language.difficulty.color))
                    .cornerRadius(8)
                
                // Economic Impact
                VStack(spacing: 2) {
                    Text("Avg. Salary Boost")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Text(formatCurrency(language.economicImpact.averageSalaryIncrease))
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#ffbe00"))
                }
                
                // Speakers
                Text("\(formatNumber(language.speakers)) speakers")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "#0a1a3b"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? Color(hex: "#bd0e1b") : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        if amount >= 1000 {
            return String(format: "$%.0fK", amount / 1000)
        } else {
            return String(format: "$%.0f", amount)
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000000 {
            return String(format: "%.1fB", Double(number) / 1000000000)
        } else if number >= 1000000 {
            return String(format: "%.0fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.0fK", Double(number) / 1000)
        } else {
            return String(number)
        }
    }
}

#Preview {
    LanguageSelectionStepView(viewModel: OnboardingViewModel())
        .background(Color(hex: "#02102b"))
}
