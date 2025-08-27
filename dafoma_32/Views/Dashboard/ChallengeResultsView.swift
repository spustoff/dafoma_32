//
//  ChallengeResultsView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct ChallengeResultsView: View {
    let challenge: Challenge
    let selectedAnswers: [Int]
    let onComplete: (Double) -> Void
    let onDismiss: () -> Void
    
    @State private var animateResults = false
    @State private var showConfetti = false
    
    var score: Double {
        guard !challenge.questions.isEmpty else { return 0 }
        let correctAnswers = challenge.questions.enumerated().filter { index, question in
            index < selectedAnswers.count && selectedAnswers[index] == question.correctAnswer
        }.count
        return Double(correctAnswers) / Double(challenge.questions.count)
    }
    
    var experienceEarned: Int {
        Int(Double(challenge.experienceReward) * score)
    }
    
    var performanceLevel: String {
        switch score {
        case 0.9...1.0: return "Excellent!"
        case 0.7..<0.9: return "Great Job!"
        case 0.5..<0.7: return "Good Work!"
        case 0.3..<0.5: return "Keep Practicing!"
        default: return "Try Again!"
        }
    }
    
    var performanceColor: String {
        switch score {
        case 0.9...1.0: return "#ffbe00"
        case 0.7..<0.9: return "#bd0e1b"
        case 0.5..<0.7: return "#0a1a3b"
        default: return "#666666"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Results Header
            VStack(spacing: 20) {
                // Performance Badge
                VStack(spacing: 10) {
                    Image(systemName: getPerformanceIcon())
                        .font(.system(size: 60))
                        .foregroundColor(Color(hex: performanceColor))
                        .scaleEffect(animateResults ? 1.0 : 0.5)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2), value: animateResults)
                    
                    Text(performanceLevel)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(animateResults ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateResults)
                }
                
                // Score Display
                VStack(spacing: 8) {
                    Text("Your Score")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    
                    Text("\(Int(score * 100))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color(hex: performanceColor))
                        .opacity(animateResults ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8).delay(0.6), value: animateResults)
                }
            }
            
            // Statistics
            VStack(spacing: 20) {
                HStack {
                    ResultStatCard(
                        title: "Correct",
                        value: "\(Int(score * Double(challenge.questions.count)))",
                        subtitle: "out of \(challenge.questions.count)",
                        icon: "checkmark.circle.fill",
                        color: "#ffbe00"
                    )
                    
                    ResultStatCard(
                        title: "XP Earned",
                        value: "\(experienceEarned)",
                        subtitle: "experience points",
                        icon: "star.fill",
                        color: "#bd0e1b"
                    )
                }
                .opacity(animateResults ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.8), value: animateResults)
                
                // Challenge Info
                HStack {
                    ResultStatCard(
                        title: "Difficulty",
                        value: challenge.difficulty.rawValue,
                        subtitle: "level",
                        icon: "target",
                        color: "#0a1a3b"
                    )
                    
                    ResultStatCard(
                        title: "Bonus",
                        value: String(format: "%.1fx", challenge.difficulty.multiplier),
                        subtitle: "multiplier",
                        icon: "multiply.circle.fill",
                        color: performanceColor
                    )
                }
                .opacity(animateResults ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(1.0), value: animateResults)
            }
            
            // Question Review (if poor performance)
            if score < 0.7 {
                VStack(alignment: .leading, spacing: 15) {
                    Text("Review Incorrect Answers")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(Array(challenge.questions.enumerated()), id: \.offset) { index, question in
                                if index < selectedAnswers.count && selectedAnswers[index] != question.correctAnswer {
                                    QuestionReviewCard(
                                        question: question,
                                        questionNumber: index + 1,
                                        selectedAnswer: selectedAnswers[index],
                                        correctAnswer: question.correctAnswer
                                    )
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
                .padding(.horizontal, 20)
                .opacity(animateResults ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(1.2), value: animateResults)
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 15) {
                Button(action: {
                    onComplete(score)
                    onDismiss()
                }) {
                    Text("Continue Learning")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color(hex: "#bd0e1b"))
                        .cornerRadius(25)
                }
                
                Button(action: onDismiss) {
                    Text("Back to Dashboard")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(hex: "#0a1a3b"))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 20)
            .opacity(animateResults ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8).delay(1.4), value: animateResults)
        }
        .onAppear {
            animateResults = true
            if score >= 0.9 {
                showConfetti = true
            }
        }
    }
    
    private func getPerformanceIcon() -> String {
        switch score {
        case 0.9...1.0: return "trophy.fill"
        case 0.7..<0.9: return "star.fill"
        case 0.5..<0.7: return "hand.thumbsup.fill"
        default: return "arrow.clockwise"
        }
    }
}

struct ResultStatCard: View {
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
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct QuestionReviewCard: View {
    let question: ChallengeQuestion
    let questionNumber: Int
    let selectedAnswer: Int
    let correctAnswer: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Question
            Text("Q\(questionNumber): \(question.question)")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            // Your Answer
            if selectedAnswer >= 0 && selectedAnswer < question.options.count {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(hex: "#bd0e1b"))
                    
                    Text("Your answer: \(question.options[selectedAnswer])")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                }
            }
            
            // Correct Answer
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color(hex: "#ffbe00"))
                
                Text("Correct answer: \(question.options[correctAnswer])")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            
            // Explanation
            if !question.explanation.isEmpty {
                Text(question.explanation)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .italic()
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.3))
        )
    }
}

#Preview {
    ChallengeResultsView(
        challenge: Challenge(
            title: "Daily Vocabulary",
            description: "Learn 10 new words",
            difficulty: .medium,
            experienceReward: 200,
            timeLimit: 300,
            questions: [
                ChallengeQuestion(
                    question: "What does 'Hola' mean?",
                    options: ["Goodbye", "Hello", "Please", "Thank you"],
                    correctAnswer: 1,
                    explanation: "Hola means Hello in Spanish",
                    audioURL: nil
                )
            ],
            requiredLocation: nil
        ),
        selectedAnswers: [1],
        onComplete: { _ in },
        onDismiss: {}
    )
    .background(Color(hex: "#02102b"))
}
