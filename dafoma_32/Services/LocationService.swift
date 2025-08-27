//
//  LocationService.swift
//  LinguaEducate Kan
//
//  Created by AI Assistant
//

import Foundation
import CoreLocation
import MapKit

class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocationUpdates() {
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            locationError = "Location access not authorized"
            return
        }
        
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    func getLocationData() -> LocationData? {
        guard let location = currentLocation else { return nil }
        
        return LocationData(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            country: "Unknown", // Will be updated via reverse geocoding
            city: "Unknown",
            timestamp: Date()
        )
    }
    
    func reverseGeocode(location: CLLocation, completion: @escaping (LocationData?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            
            let locationData = LocationData(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                country: placemark.country ?? "Unknown",
                city: placemark.locality ?? "Unknown",
                timestamp: Date()
            )
            
            completion(locationData)
        }
    }
    
    func getLanguageChallengesForLocation(_ location: LocationData) -> [Challenge] {
        // Return location-specific challenges based on the current location
        // This would typically fetch from a server or local database
        // For now, return sample challenges
        return generateLocationBasedChallenges(for: location)
    }
    
    private func generateLocationBasedChallenges(for location: LocationData) -> [Challenge] {
        var challenges: [Challenge] = []
        
        // Generate challenges based on location
        if location.country.lowercased().contains("spain") || location.country.lowercased().contains("mexico") {
            challenges.append(Challenge(
                title: "Local Spanish Expressions",
                description: "Learn common expressions used in \(location.city)",
                difficulty: .medium,
                experienceReward: 200,
                timeLimit: 300,
                questions: generateSpanishQuestions(),
                requiredLocation: location
            ))
        }
        
        if location.country.lowercased().contains("france") {
            challenges.append(Challenge(
                title: "French Cultural Context",
                description: "Understand French customs in \(location.city)",
                difficulty: .medium,
                experienceReward: 200,
                timeLimit: 300,
                questions: generateFrenchQuestions(),
                requiredLocation: location
            ))
        }
        
        return challenges
    }
    
    private func generateSpanishQuestions() -> [ChallengeQuestion] {
        return [
            ChallengeQuestion(
                question: "How do you say 'How much does this cost?' in Spanish?",
                options: ["¿Cuánto cuesta esto?", "¿Dónde está esto?", "¿Qué es esto?", "¿Cuándo es esto?"],
                correctAnswer: 0,
                explanation: "¿Cuánto cuesta esto? is the correct way to ask about price in Spanish.",
                audioURL: nil
            ),
            ChallengeQuestion(
                question: "What does 'Gracias' mean in English?",
                options: ["Please", "Thank you", "Excuse me", "You're welcome"],
                correctAnswer: 1,
                explanation: "Gracias means 'Thank you' in English.",
                audioURL: nil
            )
        ]
    }
    
    private func generateFrenchQuestions() -> [ChallengeQuestion] {
        return [
            ChallengeQuestion(
                question: "How do you say 'Excuse me' in French?",
                options: ["Excusez-moi", "Merci", "Bonjour", "Au revoir"],
                correctAnswer: 0,
                explanation: "Excusez-moi is the polite way to say 'Excuse me' in French.",
                audioURL: nil
            )
        ]
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        locationError = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationError = error.localizedDescription
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            locationError = "Location access denied"
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
