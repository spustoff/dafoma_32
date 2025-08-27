//
//  LocationDetailView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI
import CoreLocation

struct LocationDetailView: View {
    let location: MapLocation
    @ObservedObject var viewModel: ProficiencyMapViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#02102b")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Header
                        LocationHeader(location: location)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8), value: animateContent)
                        
                        // Language Opportunities
                        LanguageOpportunitiesSection(location: location)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateContent)
                        
                        // Market Analysis
                        MarketAnalysisSection(location: location)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateContent)
                        
                        // Recommendations
                        RecommendationsSection(location: location)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.6), value: animateContent)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            animateContent = true
        }
    }
}

struct LocationHeader: View {
    let location: MapLocation
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // Navigation
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Location Details")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Placeholder for alignment
                Color.clear
                    .frame(width: 18, height: 18)
            }
            
            // Location Info
            VStack(spacing: 15) {
                // Location Icon and Name
                VStack(spacing: 8) {
                    Image(systemName: "location.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                    
                    Text(location.city)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(location.country)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                // Coordinates
                Text("Lat: \(String(format: "%.4f", location.coordinate.latitude)), Lng: \(String(format: "%.4f", location.coordinate.longitude))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(8)
            }
        }
    }
}

struct LanguageOpportunitiesSection: View {
    let location: MapLocation
    
    var sortedLanguages: [(String, LanguageProficiencyData)] {
        location.languageProficiency.sorted { first, second in
            first.value.demand.rawValue > second.value.demand.rawValue
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Language Opportunities")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(Array(sortedLanguages.enumerated()), id: \.offset) { index, languageData in
                    if let language = Language.sampleLanguages.first(where: { $0.code == languageData.0 }) {
                        LanguageOpportunityCard(
                            language: language,
                            proficiencyData: languageData.1,
                            rank: index + 1
                        )
                    }
                }
            }
        }
    }
}

struct LanguageOpportunityCard: View {
    let language: Language
    let proficiencyData: LanguageProficiencyData
    let rank: Int
    
    var body: some View {
        HStack(spacing: 15) {
            // Rank Badge
            Text("\(rank)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(Color(hex: "#bd0e1b"))
                .cornerRadius(14)
            
            // Language Info
            HStack(spacing: 10) {
                Text(language.flag)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(language.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("\(formatNumber(proficiencyData.speakers)) speakers")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Stats
            VStack(alignment: .trailing, spacing: 4) {
                // Demand Badge
                Text(proficiencyData.demand.rawValue)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(getDemandColor(proficiencyData.demand))
                    .cornerRadius(8)
                
                // Salary
                Text(formatCurrency(proficiencyData.averageSalary))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(hex: "#ffbe00"))
                
                // Proficiency Level
                Text(proficiencyData.level.rawValue)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
    
    private func getDemandColor(_ demand: EconomicImpact.MarketDemand) -> Color {
        switch demand {
        case .veryHigh: return Color(hex: "#bd0e1b")
        case .high: return Color(hex: "#ffbe00")
        case .medium: return Color(hex: "#0a1a3b")
        case .low: return Color.gray
        }
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.0fK", Double(number) / 1000)
        } else {
            return String(number)
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.0fK", amount / 1000)
    }
}

struct MarketAnalysisSection: View {
    let location: MapLocation
    
    var totalSpeakers: Int {
        location.languageProficiency.values.reduce(0) { $0 + $1.speakers }
    }
    
    var averageSalary: Double {
        let salaries = location.languageProficiency.values.map { $0.averageSalary }
        return salaries.reduce(0, +) / Double(salaries.count)
    }
    
    var highDemandLanguages: Int {
        location.languageProficiency.values.filter { 
            $0.demand == .high || $0.demand == .veryHigh 
        }.count
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Market Analysis")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            // Market Stats Grid
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            LazyVGrid(columns: columns, spacing: 12) {
                MarketStatCard(
                    title: "Total Speakers",
                    value: formatLargeNumber(totalSpeakers),
                    icon: "person.3.fill",
                    color: "#bd0e1b"
                )
                
                MarketStatCard(
                    title: "Avg. Salary",
                    value: formatCurrency(averageSalary),
                    icon: "dollarsign.circle.fill",
                    color: "#ffbe00"
                )
                
                MarketStatCard(
                    title: "Languages",
                    value: "\(location.languageProficiency.count)",
                    icon: "globe.americas.fill",
                    color: "#0a1a3b"
                )
                
                MarketStatCard(
                    title: "High Demand",
                    value: "\(highDemandLanguages)",
                    icon: "chart.line.uptrend.xyaxis",
                    color: "#bd0e1b"
                )
            }
            
            // Market Insights
            VStack(alignment: .leading, spacing: 10) {
                Text("Market Insights")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 8) {
                    InsightRow(
                        icon: "star.fill",
                        text: getTopLanguageInsight(),
                        color: "#ffbe00"
                    )
                    
                    InsightRow(
                        icon: "chart.bar.fill",
                        text: getSalaryInsight(),
                        color: "#bd0e1b"
                    )
                    
                    InsightRow(
                        icon: "target",
                        text: getDemandInsight(),
                        color: "#0a1a3b"
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
    
    private func getTopLanguageInsight() -> String {
        if let topLanguage = location.languageProficiency.max(by: { $0.value.speakers < $1.value.speakers }),
           let language = Language.sampleLanguages.first(where: { $0.code == topLanguage.key }) {
            return "\(language.name) is the most spoken language with \(formatLargeNumber(topLanguage.value.speakers)) speakers"
        }
        return "Multiple languages are spoken in this region"
    }
    
    private func getSalaryInsight() -> String {
        if let highestSalary = location.languageProficiency.max(by: { $0.value.averageSalary < $1.value.averageSalary }),
           let language = Language.sampleLanguages.first(where: { $0.code == highestSalary.key }) {
            return "\(language.name) offers the highest average salary at \(formatCurrency(highestSalary.value.averageSalary))"
        }
        return "Competitive salaries across all languages"
    }
    
    private func getDemandInsight() -> String {
        let veryHighDemand = location.languageProficiency.filter { $0.value.demand == .veryHigh }.count
        if veryHighDemand > 0 {
            return "\(veryHighDemand) language\(veryHighDemand == 1 ? "" : "s") in very high demand"
        } else if highDemandLanguages > 0 {
            return "\(highDemandLanguages) language\(highDemandLanguages == 1 ? "" : "s") in high demand"
        }
        return "Moderate demand for language skills"
    }
    
    private func formatLargeNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000)
        } else if number >= 1000 {
            return String(format: "%.0fK", Double(number) / 1000)
        } else {
            return String(number)
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.0fK", amount / 1000)
    }
}

struct MarketStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.3))
        )
    }
}

struct InsightRow: View {
    let icon: String
    let text: String
    let color: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: color))
                .frame(width: 16)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
    }
}

struct RecommendationsSection: View {
    let location: MapLocation
    
    var topRecommendations: [(String, LanguageProficiencyData)] {
        location.languageProficiency.sorted { first, second in
            // Sort by demand first, then by salary
            if first.value.demand != second.value.demand {
                return first.value.demand.rawValue > second.value.demand.rawValue
            }
            return first.value.averageSalary > second.value.averageSalary
        }.prefix(3).map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recommendations")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                ForEach(Array(topRecommendations.enumerated()), id: \.offset) { index, languageData in
                    if let language = Language.sampleLanguages.first(where: { $0.code == languageData.0 }) {
                        RecommendationCard(
                            language: language,
                            proficiencyData: languageData.1,
                            reason: getRecommendationReason(language: language, data: languageData.1, rank: index + 1)
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
    
    private func getRecommendationReason(language: Language, data: LanguageProficiencyData, rank: Int) -> String {
        switch rank {
        case 1:
            if data.demand == .veryHigh {
                return "Highest demand with excellent salary potential"
            } else {
                return "Best overall opportunity in this location"
            }
        case 2:
            return "Strong market presence with good earning potential"
        case 3:
            return "Growing demand with competitive salaries"
        default:
            return "Good opportunity for language learners"
        }
    }
}

struct RecommendationCard: View {
    let language: Language
    let proficiencyData: LanguageProficiencyData
    let reason: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                Text(language.flag)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(language.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(reason)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            
            // Quick Stats
            HStack {
                StatPill(
                    label: "Demand",
                    value: proficiencyData.demand.rawValue,
                    color: getDemandColor(proficiencyData.demand)
                )
                
                StatPill(
                    label: "Salary",
                    value: formatCurrency(proficiencyData.averageSalary),
                    color: "#ffbe00"
                )
                
                StatPill(
                    label: "Level",
                    value: String(proficiencyData.level.rawValue.prefix(2)),
                    color: "#0a1a3b"
                )
                
                Spacer()
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#bd0e1b").opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    private func getDemandColor(_ demand: EconomicImpact.MarketDemand) -> String {
        switch demand {
        case .veryHigh: return "#bd0e1b"
        case .high: return "#ffbe00"
        case .medium: return "#0a1a3b"
        case .low: return "#666666"
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.0fK", amount / 1000)
    }
}

struct StatPill: View {
    let label: String
    let value: String
    let color: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(Color(hex: color))
            
            Text(label)
                .font(.system(size: 8))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: color).opacity(0.1))
        )
    }
}

#Preview {
    LocationDetailView(
        location: MapLocation(
            id: UUID(),
            coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            city: "New York",
            country: "United States",
            languageProficiency: [
                "es": LanguageProficiencyData(level: .b1, speakers: 2500000, demand: .high, averageSalary: 75000),
                "zh": LanguageProficiencyData(level: .a2, speakers: 800000, demand: .veryHigh, averageSalary: 95000),
                "fr": LanguageProficiencyData(level: .b2, speakers: 300000, demand: .medium, averageSalary: 70000)
            ]
        ),
        viewModel: ProficiencyMapViewModel()
    )
}
