//
//  BaseViewModel.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import Foundation
import Combine

class BaseViewModel: ObservableObject {
    var bag = Set<AnyCancellable>()
}

