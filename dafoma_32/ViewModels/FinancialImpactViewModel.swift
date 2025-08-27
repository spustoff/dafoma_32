//
//  FinancialImpactViewModel.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation
import SwiftUI

class FinancialImpactViewModel: ObservableObject {
    @Published var currentSalary: String = ""
    @Published var yearsOfExperience: Int = 0
    @Published var selectedIndustry: String = "Technology"
    @Published var selectedLocation: String = "New York"
    @Published var selectedLanguage: Language?
    @Published var selectedProficiencyLevel: UserProgress.ProficiencyLevel = .b1
    @Published var calculationResult: FinancialCalculation?
    @Published var isCalculating: Bool = false
    @Published var showingResults: Bool = false
    
    private let financialCalculatorService: FinancialCalculatorService
    
    let industries = IndustryData.industries.map { $0.name }
    let locations = LocationMultiplier.locations.map { $0.city }
    let proficiencyLevels = UserProgress.ProficiencyLevel.allCases
    
    init(financialCalculatorService: FinancialCalculatorService) {
        self.financialCalculatorService = financialCalculatorService
    }
    
    func calculateImpact() {
        guard let language = selectedLanguage,
              let salary = Double(currentSalary),
              salary > 0 else {
            return
        }
        
        isCalculating = true
        
        // Simulate calculation delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.calculationResult = self.financialCalculatorService.calculateFinancialImpact(
                languageCode: language.code,
                currentSalary: salary,
                yearsOfExperience: self.yearsOfExperience,
                industry: self.selectedIndustry,
                location: self.selectedLocation,
                proficiencyLevel: self.selectedProficiencyLevel
            )
            
            self.isCalculating = false
            self.showingResults = true
        }
    }
    
    func resetCalculation() {
        calculationResult = nil
        showingResults = false
        currentSalary = ""
        yearsOfExperience = 0
        selectedIndustry = "Technology"
        selectedLocation = "New York"
        selectedProficiencyLevel = .b1
    }
    
    func getIndustryRecommendations() -> [IndustryData] {
        guard let language = selectedLanguage else { return [] }
        return financialCalculatorService.getIndustryRecommendations(for: language.code)
    }
    
    func getLocationRecommendations() -> [LocationMultiplier] {
        guard let language = selectedLanguage else { return [] }
        return financialCalculatorService.getLocationRecommendations(for: language.code)
    }
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
    func formatPercentage(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value / 100)) ?? "0%"
    }
    
    func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
    
    func getROIColor(_ roi: Double) -> Color {
        if roi >= 500 {
            return Color(hex: "#ffbe00") // Gold
        } else if roi >= 200 {
            return Color(hex: "#bd0e1b") // Red
        } else if roi >= 100 {
            return Color(hex: "#0a1a3b") // Dark blue
        } else {
            return Color.gray
        }
    }
    
    func getImpactDescription(_ impact: CalculatedImpact) -> String {
        let increase = impact.projectedSalaryIncrease
        
        if increase >= 30000 {
            return "Exceptional financial impact! This language skill could significantly boost your career."
        } else if increase >= 20000 {
            return "Strong financial benefits. This language is highly valued in your field."
        } else if increase >= 10000 {
            return "Good financial potential. Learning this language will provide solid returns."
        } else {
            return "Moderate financial impact. Consider other factors like personal interest and career goals."
        }
    }
    
    func getBreakEvenDescription(_ months: Int) -> String {
        if months <= 6 {
            return "Very quick payback period"
        } else if months <= 12 {
            return "Fast return on investment"
        } else if months <= 24 {
            return "Reasonable payback time"
        } else {
            return "Long-term investment"
        }
    }
    
    func getMarketDemandDescription(_ advantage: MarketAdvantage) -> String {
        let edge = advantage.competitiveEdge
        
        if edge >= 50 {
            return "Extremely high demand - you'll have a significant competitive advantage"
        } else if edge >= 30 {
            return "High demand - strong market position"
        } else if edge >= 15 {
            return "Moderate demand - noticeable advantage"
        } else {
            return "Basic demand - some advantage in specific roles"
        }
    }
}
