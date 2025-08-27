//
//  OverviewTabView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct OverviewTabView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var animateCards = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Progress Overview Card
                if let selectedLanguage = viewModel.selectedLanguage {
                    ProgressOverviewCard(
                        language: selectedLanguage,
                        viewModel: viewModel
                    )
                    .scaleEffect(animateCards ? 1.0 : 0.9)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateCards)
                }
                
                // Today's Challenges
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("Today's Challenges")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(viewModel.todaysChallenges.count) available")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.todaysChallenges.prefix(3).enumerated()), id: \.element.id) { index, challenge in
                            ChallengeRowCard(challenge: challenge, viewModel: viewModel)
                                .scaleEffect(animateCards ? 1.0 : 0.9)
                                .opacity(animateCards ? 1.0 : 0.0)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateCards)
                        }
                    }
                }
                
                // Recent Achievements
                if !viewModel.recentAchievements.isEmpty {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Recent Achievements")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.recentAchievements, id: \.id) { achievement in
                                AchievementRowCard(achievement: achievement)
                                    .scaleEffect(animateCards ? 1.0 : 0.9)
                                    .opacity(animateCards ? 1.0 : 0.0)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateCards)
                            }
                        }
                    }
                }
                
                // Quick Stats Grid
                QuickStatsGrid(viewModel: viewModel)
                    .scaleEffect(animateCards ? 1.0 : 0.9)
                    .opacity(animateCards ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateCards)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .onAppear {
            animateCards = true
        }
    }
}

struct ProgressOverviewCard: View {
    let language: Language
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Text(language.flag)
                    .font(.system(size: 30))
                
                VStack(alignment: .leading) {
                    Text("\(language.name) Progress")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    if let progress = viewModel.getCurrentProgress(for: language.code) {
                        Text(progress.level.rawValue)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#ffbe00"))
                    }
                }
                
                Spacer()
                
                // XP Badge
                VStack {
                    Text(viewModel.getExperienceText(for: language.code))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                    
                    Text("Experience")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            
            // Progress Bar
            let progressData = viewModel.getNextLevelProgress(for: language.code)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress to Next Level")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(progressData.current)/\(progressData.required) XP")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                ProgressView(value: Double(progressData.current), total: Double(progressData.required))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#bd0e1b")))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
            
            // Stats Row
            HStack {
                StatColumn(
                    title: "Streak",
                    value: viewModel.getStreakText(for: language.code),
                    icon: "flame.fill",
                    color: "#ffbe00"
                )
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .frame(height: 40)
                
                StatColumn(
                    title: "Vocabulary",
                    value: viewModel.getVocabularyText(for: language.code),
                    icon: "book.fill",
                    color: "#bd0e1b"
                )
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .frame(height: 40)
                
                StatColumn(
                    title: "Study Time",
                    value: viewModel.getTotalStudyTime(for: language.code),
                    icon: "clock.fill",
                    color: "#0a1a3b"
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct StatColumn: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ChallengeRowCard: View {
    let challenge: Challenge
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        Button(action: {
            viewModel.startChallenge(challenge)
        }) {
            HStack(spacing: 15) {
                // Challenge Icon
                Image(systemName: viewModel.getChallengeIcon(challenge.difficulty))
                    .font(.system(size: 20))
                    .foregroundColor(viewModel.getDifficultyColor(challenge.difficulty))
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(viewModel.getDifficultyColor(challenge.difficulty).opacity(0.2))
                    )
                
                // Challenge Info
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(challenge.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    
                    HStack {
                        Text(challenge.difficulty.rawValue)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(viewModel.getDifficultyColor(challenge.difficulty))
                        
                        Spacer()
                        
                        Text("+\(challenge.experienceReward) XP")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(Color(hex: "#ffbe00"))
                    }
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.3))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AchievementRowCard: View {
    let achievement: Achievement
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#ffbe00"))
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(Color(hex: "#ffbe00").opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(achievement.description)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text("+\(achievement.experienceReward) XP")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color(hex: "#bd0e1b"))
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.2))
        )
    }
}

struct QuickStatsGrid: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Stats")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            LazyVGrid(columns: columns, spacing: 12) {
                QuickStatCard(
                    title: "Languages Learning",
                    value: "\(viewModel.userProgress.count)",
                    icon: "globe.americas.fill",
                    color: "#bd0e1b"
                )
                
                QuickStatCard(
                    title: "Total Achievements",
                    value: "\(viewModel.recentAchievements.count)",
                    icon: "trophy.fill",
                    color: "#ffbe00"
                )
                
                QuickStatCard(
                    title: "Challenges Completed",
                    value: "12", // This would come from actual data
                    icon: "checkmark.circle.fill",
                    color: "#0a1a3b"
                )
                
                QuickStatCard(
                    title: "Study Streak",
                    value: viewModel.selectedLanguage != nil ? viewModel.getStreakText(for: viewModel.selectedLanguage!.code) : "0 days",
                    icon: "flame.fill",
                    color: "#bd0e1b"
                )
            }
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

#Preview {
    OverviewTabView(viewModel: DashboardViewModel(dataService: DataService()))
        .background(Color(hex: "#02102b"))
}
