//
//  ProficiencyMapView.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import SwiftUI
import MapKit

struct ProficiencyMapView: View {
    @StateObject private var viewModel = ProficiencyMapViewModel()
    @EnvironmentObject var appViewModel: AppViewModel
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                Color(hex: "#02102b")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    ProficiencyMapHeader(viewModel: viewModel)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .animation(.easeInOut(duration: 0.8), value: animateContent)
                    
                    // Map View
                    ZStack {
                        MapView(viewModel: viewModel)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.easeInOut(duration: 0.8).delay(0.2), value: animateContent)
                        
                        // Overlay Controls
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                // Map Controls
                                VStack(spacing: 10) {
                                    MapControlButton(
                                        icon: "location.fill",
                                        action: {
                                            viewModel.centerOnUserLocation()
                                        }
                                    )
                                    
                                    MapControlButton(
                                        icon: "map.fill",
                                        action: {
                                            viewModel.toggleMapType()
                                        }
                                    )
                                }
                                .padding(.trailing, 20)
                            }
                            
                            // Language Filter
                            LanguageFilterBar(viewModel: viewModel)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .animation(.easeInOut(duration: 0.8).delay(0.4), value: animateContent)
                        }
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.loadMapData()
            animateContent = true
        }
        .sheet(isPresented: $viewModel.showingLocationDetail) {
            if let selectedLocation = viewModel.selectedMapLocation {
                LocationDetailView(
                    location: selectedLocation,
                    viewModel: viewModel
                )
            }
        }
    }
}

class ProficiencyMapViewModel: ObservableObject {
    @Published var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 50.0, longitudeDelta: 50.0)
    )
    @Published var mapType: MKMapType = .standard
    @Published var selectedLanguage: Language?
    @Published var mapLocations: [MapLocation] = []
    @Published var showingLocationDetail = false
    @Published var selectedMapLocation: MapLocation?
    
    private let locationService = LocationService()
    
    func loadMapData() {
        // Generate sample map locations with language proficiency data
        mapLocations = generateSampleMapLocations()
        
        // Set default language
        if selectedLanguage == nil {
            selectedLanguage = Language.sampleLanguages.first
        }
    }
    
    func centerOnUserLocation() {
        locationService.requestLocationPermission()
        
        if let location = locationService.currentLocation {
            mapRegion = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            )
        }
    }
    
    func toggleMapType() {
        mapType = mapType == .standard ? .satellite : .standard
    }
    
    func selectLanguage(_ language: Language) {
        selectedLanguage = language
    }
    
    func selectLocation(_ location: MapLocation) {
        selectedMapLocation = location
        showingLocationDetail = true
    }
    
    private func generateSampleMapLocations() -> [MapLocation] {
        return [
            MapLocation(
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
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                city: "San Francisco",
                country: "United States",
                languageProficiency: [
                    "zh": LanguageProficiencyData(level: .b2, speakers: 1200000, demand: .veryHigh, averageSalary: 120000),
                    "ja": LanguageProficiencyData(level: .b1, speakers: 150000, demand: .high, averageSalary: 110000),
                    "es": LanguageProficiencyData(level: .a2, speakers: 800000, demand: .medium, averageSalary: 85000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 25.7617, longitude: -80.1918),
                city: "Miami",
                country: "United States",
                languageProficiency: [
                    "es": LanguageProficiencyData(level: .c1, speakers: 1800000, demand: .veryHigh, averageSalary: 65000),
                    "pt": LanguageProficiencyData(level: .b1, speakers: 200000, demand: .high, averageSalary: 60000),
                    "fr": LanguageProficiencyData(level: .a2, speakers: 100000, demand: .low, averageSalary: 55000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832),
                city: "Toronto",
                country: "Canada",
                languageProficiency: [
                    "fr": LanguageProficiencyData(level: .c2, speakers: 500000, demand: .veryHigh, averageSalary: 70000),
                    "zh": LanguageProficiencyData(level: .b1, speakers: 300000, demand: .high, averageSalary: 75000),
                    "es": LanguageProficiencyData(level: .b2, speakers: 150000, demand: .medium, averageSalary: 65000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278),
                city: "London",
                country: "United Kingdom",
                languageProficiency: [
                    "fr": LanguageProficiencyData(level: .b2, speakers: 400000, demand: .high, averageSalary: 65000),
                    "de": LanguageProficiencyData(level: .b1, speakers: 200000, demand: .high, averageSalary: 70000),
                    "es": LanguageProficiencyData(level: .b1, speakers: 300000, demand: .medium, averageSalary: 60000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                city: "Paris",
                country: "France",
                languageProficiency: [
                    "fr": LanguageProficiencyData(level: .c2, speakers: 2200000, demand: .veryHigh, averageSalary: 55000),
                    "de": LanguageProficiencyData(level: .b1, speakers: 150000, demand: .medium, averageSalary: 60000),
                    "es": LanguageProficiencyData(level: .b2, speakers: 200000, demand: .medium, averageSalary: 50000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),
                city: "Berlin",
                country: "Germany",
                languageProficiency: [
                    "de": LanguageProficiencyData(level: .c2, speakers: 3500000, demand: .veryHigh, averageSalary: 65000),
                    "fr": LanguageProficiencyData(level: .b1, speakers: 200000, demand: .medium, averageSalary: 60000),
                    "es": LanguageProficiencyData(level: .b1, speakers: 150000, demand: .low, averageSalary: 55000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
                city: "Tokyo",
                country: "Japan",
                languageProficiency: [
                    "ja": LanguageProficiencyData(level: .c2, speakers: 13500000, demand: .veryHigh, averageSalary: 55000),
                    "zh": LanguageProficiencyData(level: .b1, speakers: 200000, demand: .high, averageSalary: 60000),
                    "fr": LanguageProficiencyData(level: .a2, speakers: 50000, demand: .low, averageSalary: 50000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
                city: "Beijing",
                country: "China",
                languageProficiency: [
                    "zh": LanguageProficiencyData(level: .c2, speakers: 21500000, demand: .veryHigh, averageSalary: 35000),
                    "ja": LanguageProficiencyData(level: .b1, speakers: 100000, demand: .medium, averageSalary: 40000),
                    "fr": LanguageProficiencyData(level: .a2, speakers: 30000, demand: .low, averageSalary: 30000)
                ]
            ),
            MapLocation(
                id: UUID(),
                coordinate: CLLocationCoordinate2D(latitude: 40.4168, longitude: -3.7038),
                city: "Madrid",
                country: "Spain",
                languageProficiency: [
                    "es": LanguageProficiencyData(level: .c2, speakers: 6500000, demand: .veryHigh, averageSalary: 35000),
                    "fr": LanguageProficiencyData(level: .b1, speakers: 200000, demand: .medium, averageSalary: 40000),
                    "de": LanguageProficiencyData(level: .b1, speakers: 100000, demand: .medium, averageSalary: 42000)
                ]
            )
        ]
    }
}

struct MapLocation: Identifiable {
    let id: UUID
    let coordinate: CLLocationCoordinate2D
    let city: String
    let country: String
    let languageProficiency: [String: LanguageProficiencyData]
}

struct LanguageProficiencyData {
    let level: UserProgress.ProficiencyLevel
    let speakers: Int
    let demand: EconomicImpact.MarketDemand
    let averageSalary: Double
}

struct ProficiencyMapHeader: View {
    @ObservedObject var viewModel: ProficiencyMapViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            // Top Navigation
            HStack {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("Language Proficiency Map")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#bd0e1b"))
                }
            }
            
            // Map Legend
            HStack {
                Text("Global Language Opportunities")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Spacer()
                
                HStack(spacing: 15) {
                    LegendItem(color: "#bd0e1b", label: "High Demand")
                    LegendItem(color: "#ffbe00", label: "Medium Demand")
                    LegendItem(color: "#0a1a3b", label: "Low Demand")
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color(hex: "#0a1a3b"))
    }
}

struct LegendItem: View {
    let color: String
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(Color(hex: color))
                .frame(width: 8, height: 8)
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(.gray)
        }
    }
}

struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: ProficiencyMapViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.mapType = viewModel.mapType
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .none
        
        // Add annotations
        updateAnnotations(mapView)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.mapType = viewModel.mapType
        
        if mapView.region.center.latitude != viewModel.mapRegion.center.latitude ||
           mapView.region.center.longitude != viewModel.mapRegion.center.longitude {
            mapView.setRegion(viewModel.mapRegion, animated: true)
        }
        
        updateAnnotations(mapView)
    }
    
    private func updateAnnotations(_ mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        
        for location in viewModel.mapLocations {
            let annotation = LocationAnnotation(mapLocation: location, selectedLanguage: viewModel.selectedLanguage)
            mapView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let locationAnnotation = annotation as? LocationAnnotation else {
                return nil
            }
            
            let identifier = "LocationAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            // Customize annotation based on language demand
            if let selectedLanguage = parent.viewModel.selectedLanguage,
               let proficiencyData = locationAnnotation.mapLocation.languageProficiency[selectedLanguage.code] {
                
                switch proficiencyData.demand {
                case .veryHigh:
                    annotationView?.markerTintColor = UIColor(Color(hex: "#bd0e1b"))
                case .high:
                    annotationView?.markerTintColor = UIColor(Color(hex: "#ffbe00"))
                case .medium:
                    annotationView?.markerTintColor = UIColor(Color(hex: "#0a1a3b"))
                case .low:
                    annotationView?.markerTintColor = UIColor.gray
                }
            } else {
                annotationView?.markerTintColor = UIColor.gray
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let locationAnnotation = view.annotation as? LocationAnnotation {
                parent.viewModel.selectLocation(locationAnnotation.mapLocation)
            }
        }
    }
}

class LocationAnnotation: NSObject, MKAnnotation {
    let mapLocation: MapLocation
    let selectedLanguage: Language?
    
    var coordinate: CLLocationCoordinate2D {
        mapLocation.coordinate
    }
    
    var title: String? {
        mapLocation.city
    }
    
    var subtitle: String? {
        if let selectedLanguage = selectedLanguage,
           let proficiencyData = mapLocation.languageProficiency[selectedLanguage.code] {
            return "\(proficiencyData.demand.rawValue) Demand - \(proficiencyData.speakers) speakers"
        }
        return mapLocation.country
    }
    
    init(mapLocation: MapLocation, selectedLanguage: Language?) {
        self.mapLocation = mapLocation
        self.selectedLanguage = selectedLanguage
    }
}

struct LanguageFilterBar: View {
    @ObservedObject var viewModel: ProficiencyMapViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Language.sampleLanguages, id: \.id) { language in
                    LanguageFilterButton(
                        language: language,
                        isSelected: viewModel.selectedLanguage?.id == language.id
                    ) {
                        viewModel.selectLanguage(language)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 10)
        .background(Color(hex: "#0a1a3b").opacity(0.9))
    }
}

struct LanguageFilterButton: View {
    let language: Language
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Text(language.flag)
                    .font(.system(size: 16))
                
                Text(language.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isSelected ? Color(hex: "#bd0e1b") : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(isSelected ? Color(hex: "#bd0e1b") : Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MapControlButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color(hex: "#0a1a3b").opacity(0.9))
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ProficiencyMapView()
        .environmentObject(AppViewModel())
}

