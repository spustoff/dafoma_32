//
//  FinancialResultsView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct FinancialResultsView: View {
    let result: FinancialCalculation
    @ObservedObject var viewModel: FinancialImpactViewModel
    let onNewCalculation: () -> Void
    
    @State private var animateResults = false
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ResultsHeader(
                result: result,
                viewModel: viewModel,
                onNewCalculation: onNewCalculation
            )
            .opacity(animateResults ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8), value: animateResults)
            
            // Tab Content
            TabView(selection: $selectedTab) {
                SalaryImpactTab(result: result, viewModel: viewModel)
                    .tag(0)
                
                ROIAnalysisTab(result: result, viewModel: viewModel)
                    .tag(1)
                
                MarketAdvantageTab(result: result, viewModel: viewModel)
                    .tag(2)
                
                RecommendationsTab(result: result, viewModel: viewModel)
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .opacity(animateResults ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8).delay(0.3), value: animateResults)
            
            // Tab Selector
            ResultsTabSelector(selectedTab: $selectedTab)
                .opacity(animateResults ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.8).delay(0.5), value: animateResults)
        }
        .onAppear {
            animateResults = true
        }
    }
}

struct ResultsHeader: View {
    let result: FinancialCalculation
    @ObservedObject var viewModel: FinancialImpactViewModel
    let onNewCalculation: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Top Navigation
            HStack {
                Button(action: onNewCalculation) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Financial Impact Results")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: onNewCalculation) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                }
            }
            
            // Main Result Display
            VStack(spacing: 15) {
                // Language Info
                if let language = Language.sampleLanguages.first(where: { $0.code == result.languageCode }) {
                    HStack {
                        Text(language.flag)
                            .font(.system(size: 24))
                        
                        Text(language.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(result.proficiencyLevel.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "#bd0e1b"))
                            .cornerRadius(8)
                    }
                }
                
                // Primary Impact Display
                VStack(spacing: 8) {
                    Text("Projected Salary Increase")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.formatCurrency(result.calculatedImpact.projectedSalaryIncrease))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color(hex: "#ffbe00"))
                    
                    Text("per year")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                // Quick Stats
                HStack {
                    QuickResultStat(
                        title: "New Salary",
                        value: viewModel.formatCurrency(result.calculatedImpact.projectedAnnualSalary),
                        icon: "dollarsign.circle.fill",
                        color: "#bd0e1b"
                    )
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                        .frame(height: 40)
                    
                    QuickResultStat(
                        title: "Lifetime Gain",
                        value: viewModel.formatCurrency(result.calculatedImpact.lifetimeEarningsIncrease),
                        icon: "chart.line.uptrend.xyaxis",
                        color: "#ffbe00"
                    )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(hex: "#0a1a3b"))
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

struct QuickResultStat: View {
    let title: String
    let value: String
    let icon: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct SalaryImpactTab: View {
    let result: FinancialCalculation
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Current vs Projected Comparison
                VStack(alignment: .leading, spacing: 15) {
                    Text("Salary Comparison")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        SalaryComparisonRow(
                            title: "Current Salary",
                            amount: result.currentSalary,
                            color: "#666666",
                            viewModel: viewModel
                        )
                        
                        SalaryComparisonRow(
                            title: "Projected Salary",
                            amount: result.calculatedImpact.projectedAnnualSalary,
                            color: "#ffbe00",
                            viewModel: viewModel
                        )
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        SalaryComparisonRow(
                            title: "Annual Increase",
                            amount: result.calculatedImpact.projectedSalaryIncrease,
                            color: "#bd0e1b",
                            viewModel: viewModel,
                            isIncrease: true
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "#0a1a3b"))
                )
                
                // Impact Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Impact Analysis")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(viewModel.getImpactDescription(result.calculatedImpact))
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "#0a1a3b"))
                )
                
                // Factors Breakdown
                FactorsBreakdownCard(result: result)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct SalaryComparisonRow: View {
    let title: String
    let amount: Double
    let color: String
    @ObservedObject var viewModel: FinancialImpactViewModel
    let isIncrease: Bool
    
    init(title: String, amount: Double, color: String, viewModel: FinancialImpactViewModel, isIncrease: Bool = false) {
        self.title = title
        self.amount = amount
        self.color = color
        self.viewModel = viewModel
        self.isIncrease = isIncrease
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            HStack(spacing: 4) {
                if isIncrease {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: color))
                }
                
                Text(viewModel.formatCurrency(amount))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: color))
            }
        }
    }
}

struct FactorsBreakdownCard: View {
    let result: FinancialCalculation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Calculation Factors")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 10) {
                FactorRow(title: "Industry", value: result.industry, icon: "building.2.fill")
                FactorRow(title: "Location", value: result.location, icon: "location.fill")
                FactorRow(title: "Experience", value: "\(result.yearsOfExperience) years", icon: "briefcase.fill")
                FactorRow(title: "Proficiency", value: result.proficiencyLevel.rawValue, icon: "target")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct FactorRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#bd0e1b"))
                .frame(width: 20)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct ROIAnalysisTab: View {
    let result: FinancialCalculation
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // ROI Overview
                VStack(alignment: .leading, spacing: 15) {
                    Text("Return on Investment")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 15) {
                        ROIMetricCard(
                            title: "5-Year ROI",
                            value: viewModel.formatPercentage(result.calculatedImpact.roi.fiveYearROI),
                            description: "Return over 5 years",
                            color: viewModel.getROIColor(result.calculatedImpact.roi.fiveYearROI)
                        )
                        
                        ROIMetricCard(
                            title: "10-Year ROI",
                            value: viewModel.formatPercentage(result.calculatedImpact.roi.tenYearROI),
                            description: "Return over 10 years",
                            color: viewModel.getROIColor(result.calculatedImpact.roi.tenYearROI)
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "#0a1a3b"))
                )
                
                // Break-even Analysis
                VStack(alignment: .leading, spacing: 15) {
                    Text("Break-even Analysis")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Investment Cost")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(viewModel.formatCurrency(result.calculatedImpact.roi.estimatedCost))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        HStack {
                            Text("Break-even Time")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("\(result.calculatedImpact.roi.breakEvenMonths) months")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "#ffbe00"))
                        }
                        
                        Text(viewModel.getBreakEvenDescription(result.calculatedImpact.roi.breakEvenMonths))
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "#0a1a3b"))
                )
                
                // Study Time Investment
                StudyTimeCard(result: result)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct ROIMetricCard: View {
    let title: String
    let value: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(color)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.3))
        )
    }
}

struct StudyTimeCard: View {
    let result: FinancialCalculation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Study Time Investment")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Estimated Study Time")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(Int(result.calculatedImpact.roi.studyTimeInvestment / 3600)) hours")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                
                HStack {
                    Text("Daily Study (30 min)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(Int(result.calculatedImpact.roi.studyTimeInvestment / 1800)) days")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#ffbe00"))
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct MarketAdvantageTab: View {
    let result: FinancialCalculation
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Market Position
                VStack(alignment: .leading, spacing: 15) {
                    Text("Market Advantage")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 12) {
                        MarketMetricRow(
                            title: "Competitive Edge",
                            value: viewModel.formatPercentage(result.calculatedImpact.marketAdvantage.competitiveEdge),
                            icon: "chart.line.uptrend.xyaxis"
                        )
                        
                        MarketMetricRow(
                            title: "Job Opportunities",
                            value: viewModel.formatNumber(Double(result.calculatedImpact.marketAdvantage.accessiblePositions)),
                            icon: "briefcase.fill"
                        )
                        
                        MarketMetricRow(
                            title: "Global Opportunities",
                            value: viewModel.formatNumber(Double(result.calculatedImpact.marketAdvantage.globalOpportunities)),
                            icon: "globe.americas.fill"
                        )
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "#0a1a3b"))
                )
                
                // Market Demand Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Market Demand Analysis")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(viewModel.getMarketDemandDescription(result.calculatedImpact.marketAdvantage))
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(hex: "#0a1a3b"))
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct MarketMetricRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#bd0e1b"))
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
    }
}

struct RecommendationsTab: View {
    let result: FinancialCalculation
    @ObservedObject var viewModel: FinancialImpactViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Industry Recommendations
                VStack(alignment: .leading, spacing: 15) {
                    Text("Top Industries for This Language")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 10) {
                        ForEach(Array(viewModel.getIndustryRecommendations().prefix(3).enumerated()), id: \.offset) { index, industry in
                            IndustryRecommendationCard(industry: industry, rank: index + 1, languageCode: result.languageCode)
                        }
                    }
                }
                
                // Location Recommendations
                VStack(alignment: .leading, spacing: 15) {
                    Text("Best Locations for This Language")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 10) {
                        ForEach(Array(viewModel.getLocationRecommendations().prefix(3).enumerated()), id: \.offset) { index, location in
                            LocationRecommendationCard(location: location, rank: index + 1, languageCode: result.languageCode)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
}

struct IndustryRecommendationCard: View {
    let industry: IndustryData
    let rank: Int
    let languageCode: String
    
    var body: some View {
        HStack {
            // Rank Badge
            Text("\(rank)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color(hex: "#bd0e1b"))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(industry.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("Avg. Salary: \(formatCurrency(industry.averageSalary))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(String(format: "%.1fx", industry.languageMultiplier[languageCode] ?? 1.0))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#ffbe00"))
                
                Text("multiplier")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        return String(format: "$%.0fK", amount / 1000)
    }
}

struct LocationRecommendationCard: View {
    let location: LocationMultiplier
    let rank: Int
    let languageCode: String
    
    var body: some View {
        HStack {
            // Rank Badge
            Text("\(rank)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Color(hex: "#bd0e1b"))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(location.city)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(location.country)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(String(format: "%.1fx", location.languageDemand[languageCode] ?? 1.0))")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(hex: "#ffbe00"))
                
                Text("demand")
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct ResultsTabSelector: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        ("dollarsign.circle.fill", "Salary"),
        ("chart.line.uptrend.xyaxis", "ROI"),
        ("target", "Market"),
        ("lightbulb.fill", "Tips")
    ]
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].0)
                            .font(.system(size: 16))
                            .foregroundColor(selectedTab == index ? Color(hex: "#bd0e1b") : .gray)
                        
                        Text(tabs[index].1)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(selectedTab == index ? Color(hex: "#bd0e1b") : .gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 10)
        .background(Color(hex: "#0a1a3b"))
    }
}

#Preview {
    FinancialResultsView(
        result: FinancialCalculation(
            languageCode: "es",
            currentSalary: 50000,
            yearsOfExperience: 3,
            industry: "Technology",
            location: "New York",
            proficiencyLevel: .b1,
            calculatedImpact: CalculatedImpact(
                projectedSalaryIncrease: 15000,
                projectedAnnualSalary: 65000,
                lifetimeEarningsIncrease: 450000,
                jobOpportunityIncrease: 25000,
                marketAdvantage: MarketAdvantage(
                    competitiveEdge: 35.0,
                    accessiblePositions: 1500,
                    globalOpportunities: 750,
                    industryDemand: "High"
                ),
                roi: ReturnOnInvestment(
                    studyTimeInvestment: 3600 * 350,
                    estimatedCost: 8750,
                    breakEvenMonths: 7,
                    fiveYearROI: 757.1,
                    tenYearROI: 1614.3
                )
            ),
            timestamp: Date()
        ),
        viewModel: FinancialImpactViewModel(financialCalculatorService: FinancialCalculatorService()),
        onNewCalculation: {}
    )
    .background(Color(hex: "#02102b"))
}
