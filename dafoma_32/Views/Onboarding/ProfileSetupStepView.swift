//
//  ProfileSetupStepView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI

struct ProfileSetupStepView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var animateContent = false
    
    let industries = IndustryData.industries.map { $0.name }
    let locations = LocationMultiplier.locations.map { $0.city }
    
    var body: some View {
        VStack(spacing: 25) {
            // Header
            VStack(spacing: 10) {
                Text("Tell Us About You")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Help us personalize your financial calculations")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 50)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.8), value: animateContent)
            
            // Form
            ScrollView {
                VStack(spacing: 20) {
                    // Name Field
                    ProfileFormField(
                        title: "Name",
                        icon: "person.fill"
                    ) {
                        TextField("Enter your name", text: $viewModel.userName)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    
                    // Age Field
                    ProfileFormField(
                        title: "Age",
                        icon: "calendar"
                    ) {
                        HStack {
                            Stepper(value: $viewModel.userAge, in: 18...65) {
                                Text("\(viewModel.userAge) years old")
                                    .foregroundColor(.white)
                            }
                            .accentColor(Color(hex: "#bd0e1b"))
                        }
                    }
                    
                    // Current Salary Field
                    ProfileFormField(
                        title: "Current Annual Salary",
                        icon: "dollarsign.circle.fill"
                    ) {
                        HStack {
                            Text("$")
                                .foregroundColor(.white)
                            TextField("50000", value: $viewModel.currentSalary, format: .number)
                                .textFieldStyle(CustomTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                    }
                    
                    // Years of Experience
                    ProfileFormField(
                        title: "Years of Experience",
                        icon: "briefcase.fill"
                    ) {
                        HStack {
                            Stepper(value: $viewModel.yearsOfExperience, in: 0...40) {
                                Text("\(viewModel.yearsOfExperience) years")
                                    .foregroundColor(.white)
                            }
                            .accentColor(Color(hex: "#bd0e1b"))
                        }
                    }
                    
                    // Industry Picker
                    ProfileFormField(
                        title: "Industry",
                        icon: "building.2.fill"
                    ) {
                        Picker("Industry", selection: $viewModel.selectedIndustry) {
                            ForEach(industries, id: \.self) { industry in
                                Text(industry)
                                    .foregroundColor(.white)
                                    .tag(industry)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(Color(hex: "#bd0e1b"))
                    }
                    
                    // Location Picker
                    ProfileFormField(
                        title: "Location",
                        icon: "location.fill"
                    ) {
                        Picker("Location", selection: $viewModel.selectedLocation) {
                            ForEach(locations, id: \.self) { location in
                                Text(location)
                                    .foregroundColor(.white)
                                    .tag(location)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(Color(hex: "#bd0e1b"))
                    }
                    
                    // Study Time Preference
                    ProfileFormField(
                        title: "Daily Study Time",
                        icon: "clock.fill"
                    ) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("\(viewModel.studyTimePerDay) minutes/day")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            Slider(value: Binding(
                                get: { Double(viewModel.studyTimePerDay) },
                                set: { viewModel.studyTimePerDay = Int($0) }
                            ), in: 5...120, step: 5)
                            .accentColor(Color(hex: "#bd0e1b"))
                            
                            HStack {
                                Text("5 min")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("2 hours")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .onAppear {
            animateContent = true
        }
    }
}

struct ProfileFormField<Content: View>: View {
    let title: String
    let icon: String
    let content: Content
    
    init(title: String, icon: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: "#bd0e1b"))
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
            }
            
            content
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#0a1a3b"))
        )
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.3))
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}

#Preview {
    ProfileSetupStepView(viewModel: OnboardingViewModel())
        .background(Color(hex: "#02102b"))
}
