//
//  DashboardViewModel.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var userProgress: [UserProgress] = []
    @Published var todaysChallenges: [Challenge] = []
    @Published var recentAchievements: [Achievement] = []
    @Published var selectedLanguage: Language?
    @Published var isShowingChallengeDetail = false
    @Published var selectedChallenge: Challenge?
    
    private let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
        loadDashboardData()
    }
    
    func loadDashboardData() {
        userProgress = dataService.userProgress
        todaysChallenges = dataService.challenges
        recentAchievements = Array(dataService.achievements.suffix(3))
        
        if let firstProgress = userProgress.first {
            selectedLanguage = Language.sampleLanguages.first { $0.code == firstProgress.languageCode }
        }
    }
    
    func selectLanguage(_ language: Language) {
        selectedLanguage = language
    }
    
    func startChallenge(_ challenge: Challenge) {
        selectedChallenge = challenge
        isShowingChallengeDetail = true
    }
    
    func completeChallenge(_ challenge: Challenge, score: Double) {
        dataService.completeChallenge(challenge, score: score)
        loadDashboardData() // Refresh data
    }
    
    func getCurrentProgress(for languageCode: String) -> UserProgress? {
        return userProgress.first { $0.languageCode == languageCode }
    }
    
    func getProgressPercentage(for languageCode: String) -> Double {
        guard let progress = getCurrentProgress(for: languageCode) else { return 0 }
        return progress.level.progress
    }
    
    func getStreakText(for languageCode: String) -> String {
        guard let progress = getCurrentProgress(for: languageCode) else { return "0 days" }
        return "\(progress.streak) day\(progress.streak == 1 ? "" : "s")"
    }
    
    func getExperienceText(for languageCode: String) -> String {
        guard let progress = getCurrentProgress(for: languageCode) else { return "0 XP" }
        return "\(progress.experiencePoints) XP"
    }
    
    func getVocabularyText(for languageCode: String) -> String {
        guard let progress = getCurrentProgress(for: languageCode) else { return "0 words" }
        return "\(progress.vocabularyMastered) words mastered"
    }
    
    func getTotalStudyTime(for languageCode: String) -> String {
        guard let progress = getCurrentProgress(for: languageCode) else { return "0h 0m" }
        let hours = Int(progress.totalStudyTime) / 3600
        let minutes = (Int(progress.totalStudyTime) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    func getNextLevelProgress(for languageCode: String) -> (current: Int, required: Int) {
        guard let progress = getCurrentProgress(for: languageCode) else { return (0, 1000) }
        
        let requiredXP = getRequiredXPForNextLevel(progress.level)
        return (progress.experiencePoints, requiredXP)
    }
    
    private func getRequiredXPForNextLevel(_ level: UserProgress.ProficiencyLevel) -> Int {
        switch level {
        case .a1: return 1000
        case .a2: return 2500
        case .b1: return 5000
        case .b2: return 8000
        case .c1: return 12000
        case .c2: return 20000
        }
    }
    
    func getDifficultyColor(_ difficulty: Challenge.ChallengeDifficulty) -> Color {
        switch difficulty {
        case .easy: return Color(hex: "#ffbe00")
        case .medium: return Color(hex: "#bd0e1b")
        case .hard: return Color(hex: "#0a1a3b")
        case .expert: return Color.white
        }
    }
    
    func getChallengeIcon(_ difficulty: Challenge.ChallengeDifficulty) -> String {
        switch difficulty {
        case .easy: return "star.fill"
        case .medium: return "star.leadinghalf.filled"
        case .hard: return "flame.fill"
        case .expert: return "crown.fill"
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
