//
//  ProgressTabView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct ProgressTabView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var animateContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Your Progress")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.6), value: animateContent)
                
                // Language Progress Cards
                LazyVStack(spacing: 15) {
                    ForEach(Array(viewModel.userProgress.enumerated()), id: \.element.id) { index, progress in
                        if let language = Language.sampleLanguages.first(where: { $0.code == progress.languageCode }) {
                            LanguageProgressCard(
                                language: language,
                                progress: progress,
                                viewModel: viewModel
                            )
                            .scaleEffect(animateContent ? 1.0 : 0.9)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateContent)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Overall Statistics
                OverallStatsCard(viewModel: viewModel)
                    .padding(.horizontal, 20)
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateContent)
            }
            .padding(.top, 20)
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct LanguageProgressCard: View {
    let language: Language
    let progress: UserProgress
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            // Header
            HStack {
                Text(language.flag)
                    .font(.system(size: 30))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(progress.level.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "#ffbe00"))
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.selectLanguage(language)
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            // Progress to Next Level
            let nextLevelProgress = viewModel.getNextLevelProgress(for: language.code)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress to Next Level")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int((Double(nextLevelProgress.current) / Double(nextLevelProgress.required)) * 100))%")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                }
                
                ProgressView(value: Double(nextLevelProgress.current), total: Double(nextLevelProgress.required))
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#bd0e1b")))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                
                Text("\(nextLevelProgress.current) / \(nextLevelProgress.required) XP")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            // Stats Grid
            HStack {
                ProgressStatItem(
                    title: "Streak",
                    value: "\(progress.streak)",
                    unit: "days",
                    icon: "flame.fill",
                    color: "#ffbe00"
                )
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .frame(height: 50)
                
                ProgressStatItem(
                    title: "Vocabulary",
                    value: "\(progress.vocabularyMastered)",
                    unit: "words",
                    icon: "book.fill",
                    color: "#bd0e1b"
                )
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .frame(height: 50)
                
                ProgressStatItem(
                    title: "Study Time",
                    value: "\(Int(progress.totalStudyTime / 3600))",
                    unit: "hours",
                    icon: "clock.fill",
                    color: "#0a1a3b"
                )
            }
            
            // Achievements Preview
            if !progress.achievements.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recent Achievements")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(progress.achievements.prefix(3), id: \.id) { achievement in
                                AchievementBadge(achievement: achievement)
                            }
                        }
                        .padding(.horizontal, 2)
                    }
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

struct ProgressStatItem: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: color))
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(unit)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: achievement.icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#ffbe00"))
                .frame(width: 30, height: 30)
                .background(
                    Circle()
                        .fill(Color(hex: "#ffbe00").opacity(0.2))
                )
            
            Text(achievement.title)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(width: 60)
        }
    }
}

struct OverallStatsCard: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var totalXP: Int {
        viewModel.userProgress.reduce(0) { $0 + $1.experiencePoints }
    }
    
    var totalVocabulary: Int {
        viewModel.userProgress.reduce(0) { $0 + $1.vocabularyMastered }
    }
    
    var totalStudyTime: TimeInterval {
        viewModel.userProgress.reduce(0) { $0 + $1.totalStudyTime }
    }
    
    var averageStreak: Double {
        guard !viewModel.userProgress.isEmpty else { return 0 }
        let totalStreak = viewModel.userProgress.reduce(0) { $0 + $1.streak }
        return Double(totalStreak) / Double(viewModel.userProgress.count)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Overall Statistics")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#bd0e1b"))
            }
            
            // Stats Grid
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            LazyVGrid(columns: columns, spacing: 15) {
                OverallStatCard(
                    title: "Total Experience",
                    value: "\(totalXP)",
                    subtitle: "XP earned",
                    icon: "star.fill",
                    color: "#bd0e1b"
                )
                
                OverallStatCard(
                    title: "Vocabulary Mastered",
                    value: "\(totalVocabulary)",
                    subtitle: "words learned",
                    icon: "book.fill",
                    color: "#ffbe00"
                )
                
                OverallStatCard(
                    title: "Study Time",
                    value: "\(Int(totalStudyTime / 3600))",
                    subtitle: "hours invested",
                    icon: "clock.fill",
                    color: "#0a1a3b"
                )
                
                OverallStatCard(
                    title: "Average Streak",
                    value: String(format: "%.1f", averageStreak),
                    subtitle: "days per language",
                    icon: "flame.fill",
                    color: "#bd0e1b"
                )
            }
            
            // Progress Summary
            VStack(alignment: .leading, spacing: 10) {
                Text("Learning Summary")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("You're actively learning \(viewModel.userProgress.count) language\(viewModel.userProgress.count == 1 ? "" : "s") and have earned a total of \(totalXP) experience points. Keep up the great work!")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct OverallStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.3))
        )
    }
}

#Preview {
    ProgressTabView(viewModel: DashboardViewModel(dataService: DataService()))
        .background(Color(hex: "#02102b"))
}
