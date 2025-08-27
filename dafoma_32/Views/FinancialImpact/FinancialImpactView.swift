//
//  FinancialImpactView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct FinancialImpactView: View {
    @StateObject private var viewModel: FinancialImpactViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var animateContent = false
    
    init(financialCalculatorService: FinancialCalculatorService) {
        _viewModel = StateObject(wrappedValue: FinancialImpactViewModel(financialCalculatorService: financialCalculatorService))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#02102b")
                    .ignoresSafeArea()
                
                if viewModel.showingResults, let result = viewModel.calculationResult {
                    FinancialResultsView(
                        result: result,
                        viewModel: viewModel,
                        onNewCalculation: {
                            viewModel.resetCalculation()
                        }
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Header
                            FinancialImpactHeader()
                                .opacity(animateContent ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8), value: animateContent)
                            
                            // Language Selection
                            LanguageSelectionSection(viewModel: viewModel)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8).delay(0.1), value: animateContent)
                            
                            // Personal Information
                            PersonalInfoSection(viewModel: viewModel)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateContent)
                            
                            // Professional Information
                            ProfessionalInfoSection(viewModel: viewModel)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateContent)
                            
                            // Proficiency Level
                            ProficiencyLevelSection(viewModel: viewModel)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateContent)
                            
                            // Calculate Button
                            CalculateButton(viewModel: viewModel)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8).delay(0.5), value: animateContent)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            animateContent = true
        }
    }
}

struct FinancialImpactHeader: View {
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: {
                    // Handle back navigation
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Financial Impact")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Placeholder for alignment
                Color.clear
                    .frame(width: 18, height: 18)
            }
            
            VStack(spacing: 8) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: "#ffbe00"))
                
                Text("Calculate Your Earning Potential")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct LanguageSelectionSection: View {
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "Select Language", icon: "globe.americas.fill")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Language.sampleLanguages, id: \.id) { language in
                        LanguageSelectionCard(
                            language: language,
                            isSelected: viewModel.selectedLanguage?.id == language.id
                        ) {
                            viewModel.selectedLanguage = language
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct LanguageSelectionCard: View {
    let language: Language
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(language.flag)
                    .font(.system(size: 24))
                
                Text(language.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                
                Text("+\(Int(language.economicImpact.averageSalaryIncrease / 1000))K")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(hex: "#ffbe00"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(width: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "#0a1a3b"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color(hex: "#bd0e1b") : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct PersonalInfoSection: View {
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "Personal Information", icon: "person.fill")
            
            VStack(spacing: 12) {
                FinancialInputField(
                    title: "Current Annual Salary",
                    placeholder: "50000",
                    text: $viewModel.currentSalary,
                    keyboardType: .numberPad,
                    prefix: "$"
                )
                
                FinancialStepperField(
                    title: "Years of Experience",
                    value: $viewModel.yearsOfExperience,
                    range: 0...40,
                    suffix: "years"
                )
            }
        }
    }
}

struct ProfessionalInfoSection: View {
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "Professional Information", icon: "briefcase.fill")
            
            VStack(spacing: 12) {
                FinancialPickerField(
                    title: "Industry",
                    selection: $viewModel.selectedIndustry,
                    options: viewModel.industries
                )
                
                FinancialPickerField(
                    title: "Location",
                    selection: $viewModel.selectedLocation,
                    options: viewModel.locations
                )
            }
        }
    }
}

struct ProficiencyLevelSection: View {
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionHeader(title: "Target Proficiency Level", icon: "target")
            
            VStack(spacing: 8) {
                ForEach(viewModel.proficiencyLevels, id: \.self) { level in
                    FinancialProficiencyLevelButton(
                        level: level,
                        isSelected: viewModel.selectedProficiencyLevel == level
                    ) {
                        viewModel.selectedProficiencyLevel = level
                    }
                }
            }
        }
    }
}

struct FinancialProficiencyLevelButton: View {
    let level: UserProgress.ProficiencyLevel
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Circle()
                    .fill(isSelected ? Color(hex: "#bd0e1b") : Color.gray.opacity(0.3))
                    .frame(width: 12, height: 12)
                
                Text(level.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
                
                ProgressView(value: level.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "#ffbe00")))
                    .frame(width: 60)
                
                Text("\(Int(level.progress * 100))%")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#ffbe00"))
                    .frame(width: 30)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color(hex: "#bd0e1b").opacity(0.2) : Color(hex: "#0a1a3b"))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color(hex: "#bd0e1b") : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CalculateButton: View {
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var canCalculate: Bool {
        viewModel.selectedLanguage != nil &&
        !viewModel.currentSalary.isEmpty &&
        Double(viewModel.currentSalary) != nil &&
        Double(viewModel.currentSalary) ?? 0 > 0
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Button(action: {
                viewModel.calculateImpact()
            }) {
                HStack {
                    if viewModel.isCalculating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "calculator")
                            .font(.system(size: 16))
                    }
                    
                    Text(viewModel.isCalculating ? "Calculating..." : "Calculate Financial Impact")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(canCalculate ? Color(hex: "#bd0e1b") : Color.gray)
                .cornerRadius(25)
            }
            .disabled(!canCalculate || viewModel.isCalculating)
            
            if !canCalculate {
                Text("Please fill in all required fields")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
}

// MARK: - Helper Components

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#bd0e1b"))
            
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

struct FinancialInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let prefix: String?
    
    init(title: String, placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, prefix: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.prefix = prefix
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            HStack {
                if let prefix = prefix {
                    Text(prefix)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                
                TextField(placeholder, text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: "#0a1a3b"))
            .cornerRadius(10)
        }
    }
}

struct FinancialStepperField: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let suffix: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            HStack {
                Stepper(value: $value, in: range) {
                    Text("\(value) \(suffix)")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
                .accentColor(Color(hex: "#bd0e1b"))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: "#0a1a3b"))
            .cornerRadius(10)
        }
    }
}

struct FinancialPickerField: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                        .foregroundColor(.white)
                        .tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(Color(hex: "#bd0e1b"))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(hex: "#0a1a3b"))
            .cornerRadius(10)
        }
    }
}

#Preview {
    FinancialImpactView(financialCalculatorService: FinancialCalculatorService())
}
