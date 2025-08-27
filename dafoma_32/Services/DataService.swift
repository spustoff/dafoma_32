//
//  DataService.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation

class DataService: ObservableObject {
    @Published var languages: [Language] = []
    @Published var userProgress: [UserProgress] = []
    @Published var achievements: [Achievement] = []
    @Published var challenges: [Challenge] = []
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadData()
    }
    
    // MARK: - Data Loading
    func loadData() {
        loadLanguages()
        loadUserProgress()
        loadAchievements()
        loadChallenges()
    }
    
    private func loadLanguages() {
        if let data = userDefaults.data(forKey: "saved_languages"),
           let savedLanguages = try? JSONDecoder().decode([Language].self, from: data) {
            languages = savedLanguages
        } else {
            languages = Language.sampleLanguages
            saveLanguages()
        }
    }
    
    private func loadUserProgress() {
        if let data = userDefaults.data(forKey: "user_progress"),
           let savedProgress = try? JSONDecoder().decode([UserProgress].self, from: data) {
            userProgress = savedProgress
        } else {
            userProgress = UserProgress.sampleProgress
            saveUserProgress()
        }
    }
    
    private func loadAchievements() {
        if let data = userDefaults.data(forKey: "achievements"),
           let savedAchievements = try? JSONDecoder().decode([Achievement].self, from: data) {
            achievements = savedAchievements
        }
    }
    
    private func loadChallenges() {
        challenges = generateDailyChallenges()
    }
    
    // MARK: - Data Saving
    func saveLanguages() {
        if let data = try? JSONEncoder().encode(languages) {
            userDefaults.set(data, forKey: "saved_languages")
        }
    }
    
    func saveUserProgress() {
        if let data = try? JSONEncoder().encode(userProgress) {
            userDefaults.set(data, forKey: "user_progress")
        }
    }
    
    func saveAchievements() {
        if let data = try? JSONEncoder().encode(achievements) {
            userDefaults.set(data, forKey: "achievements")
        }
    }
    
    // MARK: - User Progress Management
    func updateProgress(for languageCode: String, experienceGained: Int) {
        if let index = userProgress.firstIndex(where: { $0.languageCode == languageCode }) {
            userProgress[index].experiencePoints += experienceGained
            userProgress[index].lastStudyDate = Date()
            
            // Check for level up
            checkForLevelUp(at: index)
            
            // Update streak
            updateStreak(at: index)
            
            saveUserProgress()
        }
    }
    
    private func checkForLevelUp(at index: Int) {
        let progress = userProgress[index]
        let requiredXP = getRequiredXPForNextLevel(progress.level)
        
        if progress.experiencePoints >= requiredXP, let nextLevel = progress.level.nextLevel {
            userProgress[index].level = nextLevel
            
            // Award achievement for level up
            let achievement = Achievement(
                title: "Level Up!",
                description: "Reached \(nextLevel.rawValue)",
                icon: "arrow.up.circle.fill",
                unlockedDate: Date(),
                experienceReward: 500,
                category: .vocabulary
            )
            
            addAchievement(achievement)
        }
    }
    
    private func updateStreak(at index: Int) {
        let calendar = Calendar.current
        let lastStudyDate = userProgress[index].lastStudyDate
        let today = Date()
        
        if calendar.isDate(lastStudyDate, inSameDayAs: today) {
            // Already studied today, don't change streak
            return
        } else if calendar.isDate(lastStudyDate, inSameDayAs: calendar.date(byAdding: .day, value: -1, to: today)!) {
            // Studied yesterday, increment streak
            userProgress[index].streak += 1
            
            // Check for streak achievements
            checkStreakAchievements(streak: userProgress[index].streak)
        } else {
            // Broke the streak
            userProgress[index].streak = 1
        }
    }
    
    private func checkStreakAchievements(streak: Int) {
        let streakMilestones = [7, 14, 30, 60, 100]
        
        if streakMilestones.contains(streak) {
            let achievement = Achievement(
                title: "\(streak) Day Streak!",
                description: "Maintained a \(streak)-day study streak",
                icon: "flame.fill",
                unlockedDate: Date(),
                experienceReward: streak * 10,
                category: .streak
            )
            
            addAchievement(achievement)
        }
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
    
    // MARK: - Achievement Management
    func addAchievement(_ achievement: Achievement) {
        // Check if achievement already exists
        if !achievements.contains(where: { $0.title == achievement.title }) {
            achievements.append(achievement)
            saveAchievements()
        }
    }
    
    func completeChallenge(_ challenge: Challenge, score: Double) {
        let experienceGained = Int(Double(challenge.experienceReward) * score)
        
        // Find the language for this challenge (assuming it's based on current learning language)
        if let currentProgress = userProgress.first {
            updateProgress(for: currentProgress.languageCode, experienceGained: experienceGained)
            
            // Mark challenge as completed
            if let index = userProgress.firstIndex(where: { $0.languageCode == currentProgress.languageCode }) {
                userProgress[index].completedChallenges.append(challenge.id.uuidString)
            }
            
            // Award challenge completion achievement
            if score >= 0.8 {
                let achievement = Achievement(
                    title: "Challenge Master",
                    description: "Completed '\(challenge.title)' with excellent score",
                    icon: "star.fill",
                    unlockedDate: Date(),
                    experienceReward: 200,
                    category: .challenge
                )
                
                addAchievement(achievement)
            }
        }
    }
    
    // MARK: - Challenge Generation
    private func generateDailyChallenges() -> [Challenge] {
        var challenges: [Challenge] = []
        
        // Generate vocabulary challenges
        challenges.append(Challenge(
            title: "Daily Vocabulary",
            description: "Learn 10 new words in your target language",
            difficulty: .easy,
            experienceReward: 100,
            timeLimit: 600,
            questions: generateVocabularyQuestions(),
            requiredLocation: nil
        ))
        
        // Generate grammar challenges
        challenges.append(Challenge(
            title: "Grammar Focus",
            description: "Master verb conjugations",
            difficulty: .medium,
            experienceReward: 200,
            timeLimit: 900,
            questions: generateGrammarQuestions(),
            requiredLocation: nil
        ))
        
        // Generate listening challenges
        challenges.append(Challenge(
            title: "Listening Practice",
            description: "Improve your listening comprehension",
            difficulty: .hard,
            experienceReward: 300,
            timeLimit: 1200,
            questions: generateListeningQuestions(),
            requiredLocation: nil
        ))
        
        return challenges
    }
    
    private func generateVocabularyQuestions() -> [ChallengeQuestion] {
        return [
            ChallengeQuestion(
                question: "What does 'Hola' mean in English?",
                options: ["Goodbye", "Hello", "Please", "Thank you"],
                correctAnswer: 1,
                explanation: "Hola is the Spanish greeting meaning 'Hello'",
                audioURL: nil
            ),
            ChallengeQuestion(
                question: "How do you say 'Water' in Spanish?",
                options: ["Agua", "Fuego", "Tierra", "Aire"],
                correctAnswer: 0,
                explanation: "Agua is the Spanish word for water",
                audioURL: nil
            )
        ]
    }
    
    private func generateGrammarQuestions() -> [ChallengeQuestion] {
        return [
            ChallengeQuestion(
                question: "Choose the correct conjugation: 'Yo _____ español'",
                options: ["habla", "hablas", "hablo", "hablan"],
                correctAnswer: 2,
                explanation: "For 'yo' (I), the correct conjugation is 'hablo'",
                audioURL: nil
            )
        ]
    }
    
    private func generateListeningQuestions() -> [ChallengeQuestion] {
        return [
            ChallengeQuestion(
                question: "Listen to the audio and select the correct translation:",
                options: ["Good morning", "Good afternoon", "Good evening", "Good night"],
                correctAnswer: 0,
                explanation: "The audio says 'Buenos días' which means 'Good morning'",
                audioURL: "buenos_dias.mp3"
            )
        ]
    }
    
    // MARK: - Language Management
    func addLanguageToLearning(_ language: Language) {
        let newProgress = UserProgress(
            languageCode: language.code,
            level: .a1,
            experiencePoints: 0,
            streak: 0,
            completedChallenges: [],
            achievements: [],
            lastStudyDate: Date(),
            totalStudyTime: 0,
            vocabularyMastered: 0,
            currentLocation: nil
        )
        
        userProgress.append(newProgress)
        saveUserProgress()
        
        // Award first language achievement
        let achievement = Achievement(
            title: "Language Explorer",
            description: "Started learning \(language.name)",
            icon: "globe",
            unlockedDate: Date(),
            experienceReward: 100,
            category: .vocabulary
        )
        
        addAchievement(achievement)
    }
}
