//
//  AssemblyPointsService.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 26/08/2026.
//

import Foundation
import Combine

class AssemblyPointsService {
    static let shared = AssemblyPointsService()
    private let assemblyPointsApi = AssemblyPointsApi()
    var bag = Set<AnyCancellable>()
    
    private let store = AssemblyPointsStore.shared
    
    private init() { }
    
    func localPoints() -> [AssemblyPoint] {
        store.all()
    }
    
    func sync(onUpdated: @escaping ([AssemblyPoint]) -> Void) {
        assemblyPointsApi.fetchAll()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] points in
                guard let self else {return}
                self.store.replace(points)
                onUpdated(points)
            }
            .store(in: &bag)
        }
}
