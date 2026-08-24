//
//  GuidesViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 24/08/2026.
//

import Foundation
import Combine

class GuidesViewModel: BaseViewModel {
    private let guidesService = GuideService.shared
    
    @Published var guides: [Guide] = []
    
    override init() {
        super.init()
        self.loadAll()
    }
    
    private func loadAll() {
        guides = guidesService.localGuides()
        guidesService.sync { [weak self] in
            guard let self else {return}
            self.guides = self.guidesService.localGuides()
        }
    }
}
