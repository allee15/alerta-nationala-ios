//
//  ControllerRepresentable.swift
//  AlertaNationala
//
//  Created by Alexia Aldea
//

import UIKit
import SwiftUI

struct ControllerRepresentable: UIViewControllerRepresentable {
    let controller: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}

