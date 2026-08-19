//
//  OnboardingViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import Foundation
import Combine

enum OnboardingState {
    case completed
}

class OnboardingViewModel: BaseViewModel {
    var userDefaultsService = UserDefaultsService.shared
    
    @Published var pageIndex = 0
    let eventSubject = PassthroughSubject<OnboardingState, Never>()
    
    let onboardingPages: [OnboardingData] = [
        OnboardingData(image: .imgOnboarding1,
                       title: "Fii informat. Fii in siguranta. ",
                       description: "AlertaNationala iti transmite avertizari oficiale direct pentru zona ta."),
        OnboardingData(image: .imgOnboarding2,
                       title: "Ghiduri offline, oricand ai nevoie ",
                       description: "Functioneaza chiar si fara conexiune la internet, exact atunci cand conteaza cel mai mult."),
        OnboardingData(image: .imgOnboarding3,
                       title: "Activeaza locatia",
                       description: "Ca sa-ti aratam alertele relevante pentru zona ta si cel mai apropiat punct de adunare.")
    ]
    
    override init() {
        super.init()
    }
    
    func nextPage() {
        if pageIndex == onboardingPages.count - 1 {
            self.userDefaultsService.setOnboarding(onboardingIsOver: true)
            self.eventSubject.send(.completed)
        } else if pageIndex < onboardingPages.count - 1 {
            pageIndex += 1
        }
    }
}
