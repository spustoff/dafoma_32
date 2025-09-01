//
//  ChallengeDetailView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct ChallengeDetailView: View {
    let challenge: Challenge
    let onComplete: (Double) -> Void
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswers: [Int] = []
    @State private var showingResults = false
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?
    @State private var animateContent = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var currentQuestion: ChallengeQuestion? {
        guard currentQuestionIndex < challenge.questions.count else { return nil }
        return challenge.questions[currentQuestionIndex]
    }
    
    var progress: Double {
        guard !challenge.questions.isEmpty else { return 0 }
        return Double(currentQuestionIndex) / Double(challenge.questions.count)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#02102b")
                    .ignoresSafeArea()
                
                if showingResults {
                    ChallengeResultsView(
                        challenge: challenge,
                        selectedAnswers: selectedAnswers,
                        onComplete: onComplete,
                        onDismiss: {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                } else {
                    VStack(spacing: 0) {
                        // Header
                        ChallengeHeader(
                            challenge: challenge,
                            progress: progress,
                            timeRemaining: timeRemaining,
                            onClose: {
                                presentationMode.wrappedValue.dismiss()
                            }
                        )
                        
                        // Question Content
                        if let question = currentQuestion {
                            QuestionView(
                                question: question,
                                questionNumber: currentQuestionIndex + 1,
                                totalQuestions: challenge.questions.count,
                                selectedAnswer: selectedAnswers.count > currentQuestionIndex ? selectedAnswers[currentQuestionIndex] : -1,
                                onAnswerSelected: { answerIndex in
                                    selectAnswer(answerIndex)
                                }
                            )
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.5), value: animateContent)
                        }
                        
                        Spacer()
                        
                        // Navigation Buttons
                        ChallengeNavigationButtons(
                            currentQuestionIndex: currentQuestionIndex,
                            totalQuestions: challenge.questions.count,
                            hasSelectedAnswer: selectedAnswers.count > currentQuestionIndex,
                            onPrevious: previousQuestion,
                            onNext: nextQuestion,
                            onFinish: finishChallenge
                        )
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupChallenge()
            animateContent = true
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func setupChallenge() {
        selectedAnswers = Array(repeating: -1, count: challenge.questions.count)
        
        if let timeLimit = challenge.timeLimit {
            timeRemaining = timeLimit
            startTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                finishChallenge()
            }
        }
    }
    
    private func selectAnswer(_ answerIndex: Int) {
        selectedAnswers[currentQuestionIndex] = answerIndex
    }
    
    private func nextQuestion() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if currentQuestionIndex < challenge.questions.count - 1 {
                currentQuestionIndex += 1
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                animateContent = true
            }
        }
    }
    
    private func previousQuestion() {
        withAnimation(.easeInOut(duration: 0.3)) {
            animateContent = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if currentQuestionIndex > 0 {
                currentQuestionIndex -= 1
            }
            
            withAnimation(.easeInOut(duration: 0.3)) {
                animateContent = true
            }
        }
    }
    
    private func finishChallenge() {
        timer?.invalidate()
        showingResults = true
    }
}

struct ChallengeHeader: View {
    let challenge: Challenge
    let progress: Double
    let timeRemaining: TimeInterval
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Top Bar
            HStack {
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text(challenge.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Timer (if applicable)
                if challenge.timeLimit != nil {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(timeRemaining < 60 ? Color(hex: "#bd0e1b") : .white)
                        
                        Text(formatTime(timeRemaining))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(timeRemaining < 60 ? Color(hex: "#bd0e1b") : .white)
                    }
                } else {
                    // Placeholder for alignment
                    Color.clear
                        .frame(width: 60, height: 20)
                }
            }
            
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#bd0e1b")))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color(hex: "#0a1a3b"))
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct QuestionView: View {
    let question: ChallengeQuestion
    let questionNumber: Int
    let totalQuestions: Int
    let selectedAnswer: Int
    let onAnswerSelected: (Int) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Question Header
                VStack(spacing: 10) {
                    Text("Question \(questionNumber) of \(totalQuestions)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "#ffbe00"))
                    
                    Text(question.question)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
                // Answer Options
                VStack(spacing: 12) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        AnswerOptionButton(
                            text: option,
                            isSelected: selectedAnswer == index,
                            optionLetter: String(Character(UnicodeScalar(65 + index)!))
                        ) {
                            onAnswerSelected(index)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.top, 30)
        }
    }
}

struct AnswerOptionButton: View {
    let text: String
    let isSelected: Bool
    let optionLetter: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                // Option Letter
                Text(optionLetter)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isSelected ? .white : Color(hex: "#bd0e1b"))
                    .frame(width: 30, height: 30)
                    .background(
                        Circle()
                            .fill(isSelected ? Color(hex: "#bd0e1b") : Color.clear)
                            .overlay(
                                Circle()
                                    .stroke(Color(hex: "#bd0e1b"), lineWidth: 2)
                            )
                    )
                
                // Option Text
                Text(text)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color(hex: "#bd0e1b").opacity(0.2) : Color(hex: "#0a1a3b"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color(hex: "#bd0e1b") : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ChallengeNavigationButtons: View {
    let currentQuestionIndex: Int
    let totalQuestions: Int
    let hasSelectedAnswer: Bool
    let onPrevious: () -> Void
    let onNext: () -> Void
    let onFinish: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            // Previous Button
            if currentQuestionIndex > 0 {
                Button(action: onPrevious) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14))
                        Text("Previous")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#0a1a3b"))
                    .cornerRadius(25)
                }
            }
            
            Spacer()
            
            // Next/Finish Button
            Button(action: {
                if currentQuestionIndex == totalQuestions - 1 {
                    onFinish()
                } else {
                    onNext()
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentQuestionIndex == totalQuestions - 1 ? "Finish" : "Next")
                        .font(.system(size: 16, weight: .medium))
                    
                    if currentQuestionIndex < totalQuestions - 1 {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14))
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(hasSelectedAnswer ? Color(hex: "#bd0e1b") : Color.gray)
                .cornerRadius(25)
            }
            .disabled(!hasSelectedAnswer)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
}

#Preview {
    ChallengeDetailView(
        challenge: Challenge(
            title: "Daily Vocabulary",
            description: "Learn 10 new words",
            difficulty: .medium,
            experienceReward: 200,
            timeLimit: 300,
            questions: [
                ChallengeQuestion(
                    question: "What does 'Hola' mean in English?",
                    options: ["Goodbye", "Hello", "Please", "Thank you"],
                    correctAnswer: 1,
                    explanation: "Hola means Hello in Spanish",
                    audioURL: nil
                )
            ],
            requiredLocation: nil
        ),
        onComplete: { _ in }
    )
}

