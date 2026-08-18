//
//  ErrorInterceptor.swift
//  AlertaNationala
//
//  Created by Alexia Aldea 
//

import Combine

class ErrorInterceptor {
    private let subject = PassthroughSubject<ErrorEvent, Never>()

    func errors() -> AnyPublisher<ErrorEvent, Never> {
        subject.eraseToAnyPublisher()
    }

    func notify(_ errorEvent: ErrorEvent) {
        subject.send(errorEvent)
    }
}

struct ErrorEvent {
    let throwable: Error
    let message: String
}

let noInternetInterceptor = ErrorInterceptor()

