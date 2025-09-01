//
//  UserProgress.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation
import CoreLocation

struct UserProgress: Identifiable, Codable {
    let id = UUID()
    var languageCode: String
    var level: ProficiencyLevel
    var experiencePoints: Int
    var streak: Int
    var completedChallenges: [String]
    var achievements: [Achievement]
    var lastStudyDate: Date
    var totalStudyTime: TimeInterval
    var vocabularyMastered: Int
    var currentLocation: LocationData?
    
    enum ProficiencyLevel: String, CaseIterable, Codable {
        case a1 = "A1 - Beginner"
        case a2 = "A2 - Elementary"
        case b1 = "B1 - Intermediate"
        case b2 = "B2 - Upper Intermediate"
        case c1 = "C1 - Advanced"
        case c2 = "C2 - Proficient"
        
        var progress: Double {
            switch self {
            case .a1: return 0.16
            case .a2: return 0.33
            case .b1: return 0.50
            case .b2: return 0.66
            case .c1: return 0.83
            case .c2: return 1.0
            }
        }
        
        var nextLevel: ProficiencyLevel? {
            switch self {
            case .a1: return .a2
            case .a2: return .b1
            case .b1: return .b2
            case .b2: return .c1
            case .c1: return .c2
            case .c2: return nil
            }
        }
    }
}

struct Achievement: Identifiable, Codable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let unlockedDate: Date
    let experienceReward: Int
    let category: AchievementCategory
    
    enum AchievementCategory: String, CaseIterable, Codable {
        case vocabulary = "Vocabulary"
        case streak = "Streak"
        case challenge = "Challenge"
        case financial = "Financial"
        case location = "Location"
        case social = "Social"
    }
}

struct LocationData: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    let country: String
    let city: String
    let timestamp: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let difficulty: ChallengeDifficulty
    let experienceReward: Int
    let timeLimit: TimeInterval?
    let questions: [ChallengeQuestion]
    let requiredLocation: LocationData?
    
    enum ChallengeDifficulty: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        case expert = "Expert"
        
        var multiplier: Double {
            switch self {
            case .easy: return 1.0
            case .medium: return 1.5
            case .hard: return 2.0
            case .expert: return 3.0
            }
        }
    }
}

struct ChallengeQuestion: Identifiable, Codable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
    let audioURL: String?
}

extension UserProgress {
    static let sampleProgress: [UserProgress] = [
        UserProgress(
            languageCode: "es",
            level: .b1,
            experiencePoints: 2500,
            streak: 15,
            completedChallenges: ["basic_greetings", "restaurant_vocab", "travel_phrases"],
            achievements: [
                Achievement(
                    title: "First Steps",
                    description: "Complete your first language lesson",
                    icon: "star.fill",
                    unlockedDate: Date().addingTimeInterval(-86400 * 10),
                    experienceReward: 100,
                    category: .vocabulary
                ),
                Achievement(
                    title: "Week Warrior",
                    description: "Maintain a 7-day study streak",
                    icon: "flame.fill",
                    unlockedDate: Date().addingTimeInterval(-86400 * 3),
                    experienceReward: 250,
                    category: .streak
                )
            ],
            lastStudyDate: Date(),
            totalStudyTime: 3600 * 25,
            vocabularyMastered: 450,
            currentLocation: LocationData(
                latitude: 40.7128,
                longitude: -74.0060,
                country: "United States",
                city: "New York",
                timestamp: Date()
            )
        )
    ]
}

