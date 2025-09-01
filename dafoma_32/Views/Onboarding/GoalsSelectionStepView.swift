//
//  GoalsSelectionStepView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct GoalsSelectionStepView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    let goalIcons: [UserProfile.LearningGoal: String] = [
        .career: "briefcase.fill",
        .travel: "airplane",
        .culture: "globe.americas.fill",
        .business: "building.2.fill",
        .academic: "graduationcap.fill",
        .personal: "heart.fill"
    ]
    
    let goalColors: [UserProfile.LearningGoal: String] = [
        .career: "#bd0e1b",
        .travel: "#ffbe00",
        .culture: "#0a1a3b",
        .business: "#bd0e1b",
        .academic: "#ffbe00",
        .personal: "#0a1a3b"
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 10) {
                Text("What Are Your Goals?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Select your language learning objectives")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 50)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8), value: animateContent)
            
            // Goals Grid
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(Array(UserProfile.LearningGoal.allCases.enumerated()), id: \.element) { index, goal in
                        GoalCard(
                            goal: goal,
                            icon: goalIcons[goal] ?? "star.fill",
                            color: goalColors[goal] ?? "#bd0e1b",
                            isSelected: viewModel.selectedGoals.contains(goal)
                        ) {
                            withAnimation(.spring()) {
                                viewModel.toggleGoal(goal)
                            }
                        }
                        .scaleEffect(animateContent ? 1.0 : 0.8)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateContent)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            // Selected Goals Summary
            if !viewModel.selectedGoals.isEmpty {
                VStack(spacing: 10) {
                    Text("Your Learning Goals:")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(viewModel.selectedGoals, id: \.self) { goal in
                                HStack(spacing: 5) {
                                    Image(systemName: goalIcons[goal] ?? "star.fill")
                                        .font(.system(size: 12))
                                    Text(goal.rawValue)
                                        .font(.system(size: 12, weight: .medium))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(hex: goalColors[goal] ?? "#bd0e1b"))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            Spacer()
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct GoalCard: View {
    let goal: UserProfile.LearningGoal
    let icon: String
    let color: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 15) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(Color(hex: color))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color(hex: color).opacity(0.2))
                    )
                
                // Goal Title
                Text(goal.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                // Description
                Text(getGoalDescription(goal))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "#0a1a3b"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? Color(hex: color) : Color.clear, lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getGoalDescription(_ goal: UserProfile.LearningGoal) -> String {
        switch goal {
        case .career:
            return "Advance your professional opportunities"
        case .travel:
            return "Communicate while exploring the world"
        case .culture:
            return "Understand different cultures deeply"
        case .business:
            return "Improve international business skills"
        case .academic:
            return "Support your educational pursuits"
        case .personal:
            return "Learn for personal satisfaction"
        }
    }
}

#Preview {
    GoalsSelectionStepView(viewModel: OnboardingViewModel())
        .background(Color(hex: "#02102b"))
}

