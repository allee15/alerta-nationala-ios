//
//  GuideService.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 24/08/2026.
//

import Foundation
import Combine

class GuideService {
    static let shared = GuideService()
    private let guidesApi = GuidesApi()
    var bag = Set<AnyCancellable>()
    
    private let guideStore = GuidesStore.shared
    
    private init() { }
    
    func localGuides() -> [Guide] {
        guideStore.all()
    }
    
    func sync(completion: @escaping () -> Void) {
        guidesApi.fetchVersions()
            .flatMap { [weak self] serverVersions -> AnyPublisher<[Guide], Error> in
                guard let self else {
                    return Fail(error: AuthError.unauthorized).eraseToAnyPublisher()
                }
                
                let localVersions = self.guideStore.versionsById()
                let idsToFetch = serverVersions
                    .filter { localVersions[$0.id] == nil || localVersions[$0.id]! < $0.version }
                    .map { $0.id }
                
                guard !idsToFetch.isEmpty else {
                    return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
                }
                
                let publishers = idsToFetch.map { self.guidesApi.fetchOne(id: $0) }
                return Publishers.MergeMany(publishers)
                    .collect()
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { _ in
                completion()
            } receiveValue: { [weak self] newOrUpdatedGuides in
                if !newOrUpdatedGuides.isEmpty {
                    self?.guideStore.upsert(newOrUpdatedGuides)
                }
            }
            .store(in: &bag)
    }
}
