//
//  OnboardingView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#02102b")
                    .ignoresSafeArea()
                
                TabView(selection: $viewModel.currentStep) {
                    WelcomeStepView()
                        .tag(0)
                    
                    LanguageSelectionStepView(viewModel: viewModel)
                        .tag(1)
                    
                    SkillAssessmentStepView(viewModel: viewModel)
                        .tag(2)
                    
                    ProfileSetupStepView(viewModel: viewModel)
                        .tag(3)
                    
                    GoalsSelectionStepView(viewModel: viewModel)
                        .tag(4)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: viewModel.currentStep)
                
                VStack {
                    Spacer()
                    
                    // Progress indicator
                    HStack {
                        ForEach(0..<5) { index in
                            Circle()
                                .fill(index <= viewModel.currentStep ? Color(hex: "#bd0e1b") : Color.gray.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .animation(.easeInOut, value: viewModel.currentStep)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // Navigation buttons
                    HStack {
                        if viewModel.currentStep > 0 {
                            Button("Back") {
                                withAnimation {
                                    viewModel.previousStep()
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#0a1a3b"))
                            .cornerRadius(25)
                        }
                        
                        Spacer()
                        
                        Button(viewModel.currentStep == 4 ? "Get Started" : "Next") {
                            withAnimation {
                                if viewModel.currentStep == 4 {
                                    completeOnboarding()
                                } else {
                                    viewModel.nextStep()
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(viewModel.canProceed ? Color(hex: "#bd0e1b") : Color.gray)
                        .cornerRadius(25)
                        .disabled(!viewModel.canProceed)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func completeOnboarding() {
        let profile = UserProfile(
            name: viewModel.userName,
            age: viewModel.userAge,
            currentSalary: viewModel.currentSalary,
            yearsOfExperience: viewModel.yearsOfExperience,
            industry: viewModel.selectedIndustry,
            location: viewModel.selectedLocation,
            learningGoals: viewModel.selectedGoals,
            preferredStudyTime: viewModel.studyTimePerDay
        )
        
        appViewModel.completeOnboarding(with: profile, selectedLanguages: viewModel.selectedLanguages)
    }
}

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var selectedLanguages: [Language] = []
    @Published var assessmentResults: [String: UserProgress.ProficiencyLevel] = [:]
    @Published var userName: String = ""
    @Published var userAge: Int = 25
    @Published var currentSalary: Double = 50000
    @Published var yearsOfExperience: Int = 2
    @Published var selectedIndustry: String = "Technology"
    @Published var selectedLocation: String = "New York"
    @Published var selectedGoals: [UserProfile.LearningGoal] = []
    @Published var studyTimePerDay: Int = 15
    
    var canProceed: Bool {
        switch currentStep {
        case 0: return true
        case 1: return !selectedLanguages.isEmpty
        case 2: return !assessmentResults.isEmpty
        case 3: return !userName.isEmpty && currentSalary > 0
        case 4: return !selectedGoals.isEmpty
        default: return false
        }
    }
    
    func nextStep() {
        if currentStep < 4 {
            currentStep += 1
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func selectLanguage(_ language: Language) {
        if selectedLanguages.contains(language) {
            selectedLanguages.removeAll { $0.id == language.id }
        } else {
            selectedLanguages.append(language)
        }
    }
    
    func setAssessmentResult(for languageCode: String, level: UserProgress.ProficiencyLevel) {
        assessmentResults[languageCode] = level
    }
    
    func toggleGoal(_ goal: UserProfile.LearningGoal) {
        if selectedGoals.contains(goal) {
            selectedGoals.removeAll { $0 == goal }
        } else {
            selectedGoals.append(goal)
        }
    }
}
