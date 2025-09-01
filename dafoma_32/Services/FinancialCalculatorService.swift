//
//  FinancialCalculatorService.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation

class FinancialCalculatorService: ObservableObject {
    
    func calculateFinancialImpact(
        languageCode: String,
        currentSalary: Double,
        yearsOfExperience: Int,
        industry: String,
        location: String,
        proficiencyLevel: UserProgress.ProficiencyLevel
    ) -> FinancialCalculation {
        
        let language = Language.sampleLanguages.first { $0.code == languageCode }
        let industryData = IndustryData.industries.first { $0.name == industry }
        let locationData = LocationMultiplier.locations.first { $0.city == location }
        
        let baseIncrease = language?.economicImpact.averageSalaryIncrease ?? 10000
        let industryMultiplier = industryData?.languageMultiplier[languageCode] ?? 1.0
        let locationMultiplier = locationData?.languageDemand[languageCode] ?? 1.0
        let proficiencyMultiplier = getProficiencyMultiplier(proficiencyLevel)
        let experienceMultiplier = getExperienceMultiplier(yearsOfExperience)
        
        let projectedIncrease = baseIncrease * industryMultiplier * locationMultiplier * proficiencyMultiplier * experienceMultiplier
        let projectedAnnualSalary = currentSalary + projectedIncrease
        let lifetimeIncrease = projectedIncrease * 30 // 30 year career
        
        let marketAdvantage = calculateMarketAdvantage(
            languageCode: languageCode,
            industry: industry,
            location: location
        )
        
        let roi = calculateROI(
            salaryIncrease: projectedIncrease,
            proficiencyLevel: proficiencyLevel
        )
        
        let calculatedImpact = CalculatedImpact(
            projectedSalaryIncrease: projectedIncrease,
            projectedAnnualSalary: projectedAnnualSalary,
            lifetimeEarningsIncrease: lifetimeIncrease,
            jobOpportunityIncrease: Double(language?.economicImpact.jobOpportunities ?? 1000) * industryMultiplier,
            marketAdvantage: marketAdvantage,
            roi: roi
        )
        
        return FinancialCalculation(
            languageCode: languageCode,
            currentSalary: currentSalary,
            yearsOfExperience: yearsOfExperience,
            industry: industry,
            location: location,
            proficiencyLevel: proficiencyLevel,
            calculatedImpact: calculatedImpact,
            timestamp: Date()
        )
    }
    
    private func getProficiencyMultiplier(_ level: UserProgress.ProficiencyLevel) -> Double {
        switch level {
        case .a1: return 0.3
        case .a2: return 0.5
        case .b1: return 0.7
        case .b2: return 0.85
        case .c1: return 0.95
        case .c2: return 1.0
        }
    }
    
    private func getExperienceMultiplier(_ years: Int) -> Double {
        switch years {
        case 0...2: return 0.8
        case 3...5: return 1.0
        case 6...10: return 1.2
        case 11...15: return 1.4
        default: return 1.5
        }
    }
    
    private func calculateMarketAdvantage(languageCode: String, industry: String, location: String) -> MarketAdvantage {
        let industryData = IndustryData.industries.first { $0.name == industry }
        let locationData = LocationMultiplier.locations.first { $0.city == location }
        
        let competitiveEdge = (industryData?.languageMultiplier[languageCode] ?? 1.0) * 25
        let accessiblePositions = Int((industryData?.languageMultiplier[languageCode] ?? 1.0) * 1000)
        let globalOpportunities = Int((locationData?.languageDemand[languageCode] ?? 1.0) * 500)
        
        return MarketAdvantage(
            competitiveEdge: competitiveEdge,
            accessiblePositions: accessiblePositions,
            globalOpportunities: globalOpportunities,
            industryDemand: industryData?.demandLevel.rawValue ?? "Medium"
        )
    }
    
    private func calculateROI(salaryIncrease: Double, proficiencyLevel: UserProgress.ProficiencyLevel) -> ReturnOnInvestment {
        let studyTimeRequired = getRequiredStudyTime(for: proficiencyLevel)
        let estimatedCost = studyTimeRequired / 3600 * 25 // $25 per hour of study materials/courses
        let monthlyIncrease = salaryIncrease / 12
        let breakEvenMonths = Int(estimatedCost / monthlyIncrease)
        
        let fiveYearROI = (salaryIncrease * 5 - estimatedCost) / estimatedCost * 100
        let tenYearROI = (salaryIncrease * 10 - estimatedCost) / estimatedCost * 100
        
        return ReturnOnInvestment(
            studyTimeInvestment: studyTimeRequired,
            estimatedCost: estimatedCost,
            breakEvenMonths: breakEvenMonths,
            fiveYearROI: fiveYearROI,
            tenYearROI: tenYearROI
        )
    }
    
    private func getRequiredStudyTime(for level: UserProgress.ProficiencyLevel) -> TimeInterval {
        switch level {
        case .a1: return 3600 * 100  // 100 hours
        case .a2: return 3600 * 200  // 200 hours
        case .b1: return 3600 * 350  // 350 hours
        case .b2: return 3600 * 500  // 500 hours
        case .c1: return 3600 * 700  // 700 hours
        case .c2: return 3600 * 1000 // 1000 hours
        }
    }
    
    func getIndustryRecommendations(for languageCode: String) -> [IndustryData] {
        return IndustryData.industries
            .filter { $0.languageMultiplier[languageCode] != nil }
            .sorted { (first, second) in
                let firstMultiplier = first.languageMultiplier[languageCode] ?? 0
                let secondMultiplier = second.languageMultiplier[languageCode] ?? 0
                return firstMultiplier > secondMultiplier
            }
    }
    
    func getLocationRecommendations(for languageCode: String) -> [LocationMultiplier] {
        return LocationMultiplier.locations
            .filter { $0.languageDemand[languageCode] != nil }
            .sorted { (first, second) in
                let firstDemand = first.languageDemand[languageCode] ?? 0
                let secondDemand = second.languageDemand[languageCode] ?? 0
                return firstDemand > secondDemand
            }
    }
}

