//
//  FinancialImpact.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation

struct FinancialCalculation: Identifiable, Codable {
    let id = UUID()
    let languageCode: String
    let currentSalary: Double
    let yearsOfExperience: Int
    let industry: String
    let location: String
    let proficiencyLevel: UserProgress.ProficiencyLevel
    let calculatedImpact: CalculatedImpact
    let timestamp: Date
}

struct CalculatedImpact: Codable {
    let projectedSalaryIncrease: Double
    let projectedAnnualSalary: Double
    let lifetimeEarningsIncrease: Double
    let jobOpportunityIncrease: Double
    let marketAdvantage: MarketAdvantage
    let roi: ReturnOnInvestment
}

struct MarketAdvantage: Codable {
    let competitiveEdge: Double // Percentage
    let accessiblePositions: Int
    let globalOpportunities: Int
    let industryDemand: String
}

struct ReturnOnInvestment: Codable {
    let studyTimeInvestment: TimeInterval
    let estimatedCost: Double
    let breakEvenMonths: Int
    let fiveYearROI: Double
    let tenYearROI: Double
}

struct IndustryData: Codable, Hashable {
    let name: String
    let languageMultiplier: [String: Double] // Language code to multiplier
    let averageSalary: Double
    let growthRate: Double
    let demandLevel: EconomicImpact.MarketDemand
}

struct LocationMultiplier: Codable, Hashable {
    let country: String
    let city: String
    let costOfLiving: Double
    let languageDemand: [String: Double] // Language code to demand multiplier
    let averageIncome: Double
}

extension IndustryData {
    static let industries: [IndustryData] = [
        IndustryData(
            name: "Technology",
            languageMultiplier: [
                "zh": 1.8, "ja": 1.6, "de": 1.4, "es": 1.2, "fr": 1.1, "pt": 1.1
            ],
            averageSalary: 95000,
            growthRate: 0.15,
            demandLevel: .veryHigh
        ),
        IndustryData(
            name: "Finance",
            languageMultiplier: [
                "zh": 2.0, "de": 1.7, "ja": 1.5, "fr": 1.3, "es": 1.2, "pt": 1.1
            ],
            averageSalary: 85000,
            growthRate: 0.08,
            demandLevel: .high
        ),
        IndustryData(
            name: "Healthcare",
            languageMultiplier: [
                "es": 1.8, "zh": 1.4, "fr": 1.3, "de": 1.2, "ja": 1.1, "pt": 1.2
            ],
            averageSalary: 75000,
            growthRate: 0.12,
            demandLevel: .high
        ),
        IndustryData(
            name: "Education",
            languageMultiplier: [
                "es": 1.5, "zh": 1.4, "fr": 1.3, "de": 1.2, "ja": 1.2, "pt": 1.1
            ],
            averageSalary: 55000,
            growthRate: 0.06,
            demandLevel: .medium
        ),
        IndustryData(
            name: "Tourism",
            languageMultiplier: [
                "es": 1.6, "fr": 1.5, "de": 1.3, "zh": 1.4, "ja": 1.2, "pt": 1.3
            ],
            averageSalary: 45000,
            growthRate: 0.10,
            demandLevel: .medium
        ),
        IndustryData(
            name: "International Business",
            languageMultiplier: [
                "zh": 2.2, "de": 1.8, "ja": 1.6, "es": 1.4, "fr": 1.3, "pt": 1.2
            ],
            averageSalary: 80000,
            growthRate: 0.11,
            demandLevel: .veryHigh
        )
    ]
}

extension LocationMultiplier {
    static let locations: [LocationMultiplier] = [
        LocationMultiplier(
            country: "United States",
            city: "New York",
            costOfLiving: 1.8,
            languageDemand: [
                "es": 1.5, "zh": 1.8, "fr": 1.2, "de": 1.3, "ja": 1.4, "pt": 1.1
            ],
            averageIncome: 85000
        ),
        LocationMultiplier(
            country: "United States",
            city: "San Francisco",
            costOfLiving: 2.1,
            languageDemand: [
                "zh": 2.0, "ja": 1.6, "es": 1.3, "de": 1.2, "fr": 1.1, "pt": 1.0
            ],
            averageIncome: 120000
        ),
        LocationMultiplier(
            country: "United States",
            city: "Miami",
            costOfLiving: 1.3,
            languageDemand: [
                "es": 2.2, "pt": 1.8, "fr": 1.2, "zh": 1.1, "de": 1.0, "ja": 1.0
            ],
            averageIncome: 65000
        ),
        LocationMultiplier(
            country: "Canada",
            city: "Toronto",
            costOfLiving: 1.4,
            languageDemand: [
                "fr": 1.8, "zh": 1.5, "es": 1.2, "de": 1.1, "ja": 1.2, "pt": 1.0
            ],
            averageIncome: 70000
        )
    ]
}
