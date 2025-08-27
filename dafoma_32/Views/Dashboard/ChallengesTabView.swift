//
//  ChallengesTabView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct ChallengesTabView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var selectedDifficulty: Challenge.ChallengeDifficulty? = nil
    @State private var animateContent = false
    
    var filteredChallenges: [Challenge] {
        if let difficulty = selectedDifficulty {
            return viewModel.todaysChallenges.filter { $0.difficulty == difficulty }
        }
        return viewModel.todaysChallenges
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Challenges")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(filteredChallenges.count) available")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                // Difficulty Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        DifficultyFilterButton(
                            title: "All",
                            isSelected: selectedDifficulty == nil,
                            color: "#bd0e1b"
                        ) {
                            selectedDifficulty = nil
                        }
                        
                        ForEach(Challenge.ChallengeDifficulty.allCases, id: \.self) { difficulty in
                            DifficultyFilterButton(
                                title: difficulty.rawValue,
                                isSelected: selectedDifficulty == difficulty,
                                color: getDifficultyColor(difficulty)
                            ) {
                                selectedDifficulty = difficulty
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.6), value: animateContent)
            
            // Challenges List
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(Array(filteredChallenges.enumerated()), id: \.element.id) { index, challenge in
                        ChallengeCard(challenge: challenge, viewModel: viewModel)
                            .scaleEffect(animateContent ? 1.0 : 0.9)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateContent)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.top, 20)
        .onAppear {
            animateContent = true
        }
    }
    
    private func getDifficultyColor(_ difficulty: Challenge.ChallengeDifficulty) -> String {
        switch difficulty {
        case .easy: return "#ffbe00"
        case .medium: return "#bd0e1b"
        case .hard: return "#0a1a3b"
        case .expert: return "#ffffff"
        }
    }
}

struct DifficultyFilterButton: View {
    let title: String
    let isSelected: Bool
    let color: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : Color(hex: color))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(hex: color) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: color), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        Button(action: {
            viewModel.startChallenge(challenge)
        }) {
            VStack(alignment: .leading, spacing: 15) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(challenge.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text(challenge.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    // Challenge Icon
                    Image(systemName: viewModel.getChallengeIcon(challenge.difficulty))
                        .font(.system(size: 24))
                        .foregroundColor(viewModel.getDifficultyColor(challenge.difficulty))
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(viewModel.getDifficultyColor(challenge.difficulty).opacity(0.2))
                        )
                }
                
                // Challenge Details
                HStack {
                    // Difficulty Badge
                    HStack(spacing: 5) {
                        Circle()
                            .fill(viewModel.getDifficultyColor(challenge.difficulty))
                            .frame(width: 8, height: 8)
                        
                        Text(challenge.difficulty.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(viewModel.getDifficultyColor(challenge.difficulty))
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.getDifficultyColor(challenge.difficulty).opacity(0.1))
                    )
                    
                    Spacer()
                    
                    // Time Limit
                    if let timeLimit = challenge.timeLimit {
                        HStack(spacing: 5) {
                            Image(systemName: "clock")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                            
                            Text("\(Int(timeLimit / 60)) min")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Experience Reward
                    HStack(spacing: 5) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: "#ffbe00"))
                        
                        Text("+\(challenge.experienceReward) XP")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: "#ffbe00"))
                    }
                }
                
                // Progress Bar (if challenge has been started)
                if challenge.questions.count > 0 {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("Questions")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("\(challenge.questions.count) questions")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        ProgressView(value: 0.0, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#bd0e1b")))
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    }
                }
                
                // Location requirement (if any)
                if let location = challenge.requiredLocation {
                    HStack(spacing: 8) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#bd0e1b"))
                        
                        Text("Location-based challenge: \(location.city)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#bd0e1b"))
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(hex: "#bd0e1b").opacity(0.1))
                    )
                }
                
                // Start Button
                HStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 12))
                        
                        Text("Start Challenge")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#bd0e1b"))
                    )
                    
                    Spacer()
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "#0a1a3b"))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ChallengesTabView(viewModel: DashboardViewModel(dataService: DataService()))
        .background(Color(hex: "#02102b"))
}
