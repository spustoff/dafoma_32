//
//  AchievementsTabView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct AchievementsTabView: View {
    @ObservedObject var viewModel: DashboardViewModel
    @State private var selectedCategory: Achievement.AchievementCategory? = nil
    @State private var animateContent = false
    
    var filteredAchievements: [Achievement] {
        let allAchievements = viewModel.recentAchievements
        if let category = selectedCategory {
            return allAchievements.filter { $0.category == category }
        }
        return allAchievements
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Achievements")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(filteredAchievements.count) unlocked")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        CategoryFilterButton(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            color: "#bd0e1b"
                        ) {
                            selectedCategory = nil
                        }
                        
                        ForEach(Achievement.AchievementCategory.allCases, id: \.self) { category in
                            CategoryFilterButton(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                color: getCategoryColor(category)
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.horizontal, 20)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.6), value: animateContent)
            
            // Achievements Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    ForEach(Array(filteredAchievements.enumerated()), id: \.element.id) { index, achievement in
                        AchievementCard(achievement: achievement)
                            .scaleEffect(animateContent ? 1.0 : 0.9)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.05), value: animateContent)
                    }
                }
                .padding(.horizontal, 20)
                
                // Achievement Stats
                AchievementStatsCard(viewModel: viewModel)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateContent)
            }
        }
        .padding(.top, 20)
        .onAppear {
            animateContent = true
        }
    }
    
    private func getCategoryColor(_ category: Achievement.AchievementCategory) -> String {
        switch category {
        case .vocabulary: return "#ffbe00"
        case .streak: return "#bd0e1b"
        case .challenge: return "#0a1a3b"
        case .financial: return "#bd0e1b"
        case .location: return "#ffbe00"
        case .social: return "#0a1a3b"
        }
    }
}

struct CategoryFilterButton: View {
    let title: String
    let isSelected: Bool
    let color: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : Color(hex: color))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isSelected ? Color(hex: color) : Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(hex: color), lineWidth: 1)
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Achievement Icon
            Image(systemName: achievement.icon)
                .font(.system(size: 30))
                .foregroundColor(Color(hex: "#ffbe00"))
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(Color(hex: "#ffbe00").opacity(0.2))
                        .overlay(
                            Circle()
                                .stroke(Color(hex: "#ffbe00"), lineWidth: 2)
                        )
                )
            
            // Achievement Info
            VStack(spacing: 6) {
                Text(achievement.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(achievement.description)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            
            // Category Badge
            Text(achievement.category.rawValue)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(getCategoryColor(achievement.category))
                )
            
            // XP Reward
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#bd0e1b"))
                
                Text("+\(achievement.experienceReward) XP")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "#bd0e1b"))
            }
            
            // Unlock Date
            Text(formatDate(achievement.unlockedDate))
                .font(.system(size: 9))
                .foregroundColor(.gray)
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(hex: "#ffbe00").opacity(0.3), lineWidth: 1)
                )
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation {
                isPressed = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isPressed = false
                }
            }
        }
    }
    
    private func getCategoryColor(_ category: Achievement.AchievementCategory) -> Color {
        switch category {
        case .vocabulary: return Color(hex: "#ffbe00")
        case .streak: return Color(hex: "#bd0e1b")
        case .challenge: return Color(hex: "#0a1a3b")
        case .financial: return Color(hex: "#bd0e1b")
        case .location: return Color(hex: "#ffbe00")
        case .social: return Color(hex: "#0a1a3b")
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct AchievementStatsCard: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var achievementsByCategory: [Achievement.AchievementCategory: Int] {
        var counts: [Achievement.AchievementCategory: Int] = [:]
        for category in Achievement.AchievementCategory.allCases {
            counts[category] = viewModel.recentAchievements.filter { $0.category == category }.count
        }
        return counts
    }
    
    var totalXPFromAchievements: Int {
        viewModel.recentAchievements.reduce(0) { $0 + $1.experienceReward }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Achievement Statistics")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            
            // Overall Stats
            HStack {
                AchievementStatItem(
                    title: "Total Unlocked",
                    value: "\(viewModel.recentAchievements.count)",
                    icon: "trophy.fill",
                    color: "#ffbe00"
                )
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .frame(height: 40)
                
                AchievementStatItem(
                    title: "XP Earned",
                    value: "\(totalXPFromAchievements)",
                    icon: "star.fill",
                    color: "#bd0e1b"
                )
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .frame(height: 40)
                
                AchievementStatItem(
                    title: "Categories",
                    value: "\(achievementsByCategory.values.filter { $0 > 0 }.count)",
                    icon: "folder.fill",
                    color: "#0a1a3b"
                )
            }
            
            // Category Breakdown
            VStack(alignment: .leading, spacing: 10) {
                Text("By Category")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    ForEach(Achievement.AchievementCategory.allCases, id: \.self) { category in
                        CategoryStatItem(
                            category: category,
                            count: achievementsByCategory[category] ?? 0
                        )
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

struct AchievementStatItem: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct CategoryStatItem: View {
    let category: Achievement.AchievementCategory
    let count: Int
    
    var body: some View {
        VStack(spacing: 6) {
            Text(getCategoryIcon(category))
                .font(.system(size: 16))
            
            Text("\(count)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
            
            Text(category.rawValue)
                .font(.system(size: 8))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.3))
        )
    }
    
    private func getCategoryIcon(_ category: Achievement.AchievementCategory) -> String {
        switch category {
        case .vocabulary: return "📚"
        case .streak: return "🔥"
        case .challenge: return "🎯"
        case .financial: return "💰"
        case .location: return "📍"
        case .social: return "👥"
        }
    }
}

#Preview {
    AchievementsTabView(viewModel: DashboardViewModel(dataService: DataService()))
        .background(Color(hex: "#02102b"))
}
