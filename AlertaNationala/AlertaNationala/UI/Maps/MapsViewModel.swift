//
//  MapsViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 26/08/2026.
//

import Foundation
import Combine
import CoreLocation

enum ViewType: Int {
    case map = 0
    case list = 1
}

class MapsViewModel: BaseViewModel {
    private let assemblyPointsService = AssemblyPointsService.shared
    private let locationManager = LocationManager.shared
    
    @Published var points: [AssemblyPoint] = []
    @Published var userLocation: CLLocation?
    @Published var selectedPoint: AssemblyPoint?
    @Published var selectedTab: ViewType = .map
    
    var sortedPoints: [AssemblyPoint] {
        guard let userLocation else { return points }
        return points.sorted {
            CLLocation(latitude: $0.lat, longitude: $0.lng).distance(from: userLocation) < CLLocation(latitude: $1.lat, longitude: $1.lng).distance(from: userLocation)
        }
    }
    
    override init() {
        super.init()
        
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                guard let self else {return}
                self.userLocation = location
            }
            .store(in: &bag)
        
        self.load()
    }
    
    private func load() {
        self.points = assemblyPointsService.localPoints()
        locationManager.requestPermissionAndStart()
        assemblyPointsService.sync { [weak self] updatedLocations in
            guard let self else {return}
            self.points = updatedLocations
        }
    }
    
    func distanceString(point: AssemblyPoint) -> String? {
        guard let userLocation else {return nil}
        
        let pointLocation = CLLocation(latitude: point.lat, longitude: point.lng)
        let meters = userLocation.distance(from: pointLocation)
        return meters >= 1000 ? String(format: "%.1f km", meters / 1000) : String(format: "%.0f m", meters)
    }
}
