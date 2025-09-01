//
//  DashboardView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedTab = 0
    
    init(dataService: DataService) {
        _viewModel = StateObject(wrappedValue: DashboardViewModel(dataService: dataService))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#02102b")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Custom Navigation Header
                    DashboardHeader(viewModel: viewModel)
                    
                    // Tab Content
                    TabView(selection: $selectedTab) {
                        OverviewTabView(viewModel: viewModel)
                            .tag(0)
                        
                        ChallengesTabView(viewModel: viewModel)
                            .tag(1)
                        
                        ProgressTabView(viewModel: viewModel)
                            .tag(2)
                        
                        AchievementsTabView(viewModel: viewModel)
                            .tag(3)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    // Custom Tab Bar
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.isShowingChallengeDetail) {
            if let challenge = viewModel.selectedChallenge {
                ChallengeDetailView(
                    challenge: challenge,
                    onComplete: { score in
                        viewModel.completeChallenge(challenge, score: score)
                    }
                )
            }
        }
    }
}

struct DashboardHeader: View {
    @ObservedObject var viewModel: DashboardViewModel
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            // Top row with greeting and profile
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Hello, \(appViewModel.currentUser?.name ?? "Learner")!")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Ready to learn today?")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // Profile button
                Button(action: {}) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                }
            }
            
            // Language selector
            if let selectedLanguage = viewModel.selectedLanguage {
                HStack {
                    Text(selectedLanguage.flag)
                        .font(.system(size: 20))
                    
                    Text(selectedLanguage.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Quick stats
                    HStack(spacing: 15) {
                        StatBadge(
                            icon: "flame.fill",
                            value: viewModel.getStreakText(for: selectedLanguage.code),
                            color: "#ffbe00"
                        )
                        
                        StatBadge(
                            icon: "star.fill",
                            value: viewModel.getExperienceText(for: selectedLanguage.code),
                            color: "#bd0e1b"
                        )
                    }
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "#0a1a3b"))
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}

struct StatBadge: View {
    let icon: String
    let value: String
    let color: String
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(hex: color))
            
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(hex: color).opacity(0.2))
        .cornerRadius(8)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        ("house.fill", "Overview"),
        ("gamecontroller.fill", "Challenges"),
        ("chart.line.uptrend.xyaxis", "Progress"),
        ("trophy.fill", "Achievements")
    ]
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 4) {
                        Image(systemName: tabs[index].0)
                            .font(.system(size: 20))
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
        .background(
            Color(hex: "#0a1a3b")
                .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview {
    DashboardView(dataService: DataService())
        .environmentObject(AppViewModel())
}

