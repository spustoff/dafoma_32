//
//  Language.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation
import CoreLocation

struct Language: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String
    let difficulty: LanguageDifficulty
    let economicImpact: EconomicImpact
    let regions: [String]
    let speakers: Int
    
    enum LanguageDifficulty: String, CaseIterable, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate" 
        case advanced = "Advanced"
        case expert = "Expert"
        
        var color: String {
            switch self {
            case .beginner: return "#ffbe00"
            case .intermediate: return "#bd0e1b"
            case .advanced: return "#0a1a3b"
            case .expert: return "#ffffff"
            }
        }
    }
}

struct EconomicImpact: Codable, Hashable {
    let averageSalaryIncrease: Double
    let jobOpportunities: Int
    let marketDemand: MarketDemand
    let industries: [String]
    
    enum MarketDemand: String, CaseIterable, Codable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case veryHigh = "Very High"
        
        var multiplier: Double {
            switch self {
            case .low: return 1.0
            case .medium: return 1.2
            case .high: return 1.5
            case .veryHigh: return 2.0
            }
        }
    }
}

extension Language {
    static let sampleLanguages: [Language] = [
        Language(
            name: "Spanish",
            code: "es",
            flag: "🇪🇸",
            difficulty: .beginner,
            economicImpact: EconomicImpact(
                averageSalaryIncrease: 15000,
                jobOpportunities: 25000,
                marketDemand: .high,
                industries: ["Healthcare", "Education", "Business", "Tourism"]
            ),
            regions: ["Spain", "Mexico", "Argentina", "Colombia"],
            speakers: 500000000
        ),
        Language(
            name: "Mandarin Chinese",
            code: "zh",
            flag: "🇨🇳",
            difficulty: .expert,
            economicImpact: EconomicImpact(
                averageSalaryIncrease: 35000,
                jobOpportunities: 45000,
                marketDemand: .veryHigh,
                industries: ["Technology", "Manufacturing", "Finance", "Trade"]
            ),
            regions: ["China", "Taiwan", "Singapore"],
            speakers: 918000000
        ),
        Language(
            name: "French",
            code: "fr",
            flag: "🇫🇷",
            difficulty: .intermediate,
            economicImpact: EconomicImpact(
                averageSalaryIncrease: 18000,
                jobOpportunities: 20000,
                marketDemand: .medium,
                industries: ["Diplomacy", "Fashion", "Culinary", "Tourism"]
            ),
            regions: ["France", "Canada", "Belgium", "Switzerland"],
            speakers: 280000000
        ),
        Language(
            name: "German",
            code: "de",
            flag: "🇩🇪",
            difficulty: .advanced,
            economicImpact: EconomicImpact(
                averageSalaryIncrease: 22000,
                jobOpportunities: 18000,
                marketDemand: .high,
                industries: ["Engineering", "Automotive", "Science", "Finance"]
            ),
            regions: ["Germany", "Austria", "Switzerland"],
            speakers: 132000000
        ),
        Language(
            name: "Japanese",
            code: "ja",
            flag: "🇯🇵",
            difficulty: .expert,
            economicImpact: EconomicImpact(
                averageSalaryIncrease: 28000,
                jobOpportunities: 15000,
                marketDemand: .high,
                industries: ["Technology", "Gaming", "Animation", "Manufacturing"]
            ),
            regions: ["Japan"],
            speakers: 125000000
        ),
        Language(
            name: "Portuguese",
            code: "pt",
            flag: "🇧🇷",
            difficulty: .intermediate,
            economicImpact: EconomicImpact(
                averageSalaryIncrease: 16000,
                jobOpportunities: 12000,
                marketDemand: .medium,
                industries: ["Business", "Mining", "Agriculture", "Tourism"]
            ),
            regions: ["Brazil", "Portugal"],
            speakers: 260000000
        )
    ]
}

