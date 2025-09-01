//
//  AppViewModel.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var hasCompletedOnboarding: Bool = false
    @Published var selectedLanguages: [String] = []
    @Published var currentUser: UserProfile?
    @Published var isLoading: Bool = false
    
    // Services
    let dataService = DataService()
    let locationService = LocationService()
    let financialCalculatorService = FinancialCalculatorService()
    
    init() {
        loadUserPreferences()
    }
    
    private func loadUserPreferences() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        selectedLanguages = UserDefaults.standard.stringArray(forKey: "selectedLanguages") ?? []
        
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(UserProfile.self, from: userData) {
            currentUser = user
        }
    }
    
    func completeOnboarding(with profile: UserProfile, selectedLanguages: [Language]) {
        self.currentUser = profile
        self.selectedLanguages = selectedLanguages.map { $0.code }
        self.hasCompletedOnboarding = true
        
        // Save to UserDefaults
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        UserDefaults.standard.set(self.selectedLanguages, forKey: "selectedLanguages")
        
        if let userData = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(userData, forKey: "currentUser")
        }
        
        // Add selected languages to learning progress
        for language in selectedLanguages {
            dataService.addLanguageToLearning(language)
        }
    }
    
    func resetOnboarding() {
        hasCompletedOnboarding = false
        selectedLanguages = []
        currentUser = nil
        
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "selectedLanguages")
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}

struct UserProfile: Codable {
    let id = UUID()
    var name: String
    var age: Int
    var currentSalary: Double
    var yearsOfExperience: Int
    var industry: String
    var location: String
    var learningGoals: [LearningGoal]
    var preferredStudyTime: Int // minutes per day
    
    enum LearningGoal: String, CaseIterable, Codable {
        case career = "Career Advancement"
        case travel = "Travel & Tourism"
        case culture = "Cultural Understanding"
        case business = "Business Communication"
        case academic = "Academic Purposes"
        case personal = "Personal Interest"
    }
}

