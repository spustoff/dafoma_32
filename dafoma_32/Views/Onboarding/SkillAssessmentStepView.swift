//
//  SkillAssessmentStepView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct SkillAssessmentStepView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 10) {
                Text("Assess Your Skills")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Rate your current proficiency in each language")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 50)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8), value: animateContent)
            
            // Assessment Cards
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(Array(viewModel.selectedLanguages.enumerated()), id: \.element.id) { index, language in
                        SkillAssessmentCard(
                            language: language,
                            selectedLevel: viewModel.assessmentResults[language.code],
                            onLevelSelected: { level in
                                viewModel.setAssessmentResult(for: language.code, level: level)
                            }
                        )
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 50)
                        .animation(.easeInOut(duration: 0.6).delay(Double(index) * 0.2), value: animateContent)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct SkillAssessmentCard: View {
    let language: Language
    let selectedLevel: UserProgress.ProficiencyLevel?
    let onLevelSelected: (UserProgress.ProficiencyLevel) -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Language Header
            HStack {
                Text(language.flag)
                    .font(.system(size: 30))
                
                VStack(alignment: .leading) {
                    Text(language.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Select your current level")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            // Proficiency Levels
            VStack(spacing: 10) {
                ForEach(UserProgress.ProficiencyLevel.allCases, id: \.self) { level in
                    ProficiencyLevelButton(
                        level: level,
                        isSelected: selectedLevel == level,
                        onTap: { onLevelSelected(level) }
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct ProficiencyLevelButton: View {
    let level: UserProgress.ProficiencyLevel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // Level indicator
                Circle()
                    .fill(isSelected ? Color(hex: "#bd0e1b") : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
                
                // Level text
                Text(level.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Progress bar
                ProgressView(value: level.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#ffbe00")))
                    .frame(width: 80)
                
                // Percentage
                Text("\(Int(level.progress * 100))%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "#ffbe00"))
                    .frame(width: 35)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color(hex: "#bd0e1b").opacity(0.2) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color(hex: "#bd0e1b") : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SkillAssessmentStepView(viewModel: {
        let vm = OnboardingViewModel()
        vm.selectedLanguages = Array(Language.sampleLanguages.prefix(2))
        return vm
    }())
    .background(Color(hex: "#02102b"))
}
