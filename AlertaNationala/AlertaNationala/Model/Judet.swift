//
//  Judet.swift
//  AlertaNationala
//
//  Created by Alexia Aldea on 21/08/2026.
//

import Foundation

struct Judet {
    let name: String
    let lat: Double
    let lng: Double
}

enum Judete {
    static let all: [Judet] = [
        Judet(name: "Alba", lat: 46.07, lng: 23.57),
        Judet(name: "Arad", lat: 46.18, lng: 21.31),
        Judet(name: "Arges", lat: 44.86, lng: 24.87),
        Judet(name: "Bacau", lat: 46.57, lng: 26.91),
        Judet(name: "Bihor", lat: 47.07, lng: 21.92),
        Judet(name: "Bistrita-Nasaud", lat: 47.13, lng: 24.50),
        Judet(name: "Botosani", lat: 47.75, lng: 26.67),
        Judet(name: "Braila", lat: 45.27, lng: 27.98),
        Judet(name: "Brasov", lat: 45.65, lng: 25.61),
        Judet(name: "Buzau", lat: 45.15, lng: 26.82),
        Judet(name: "Caras-Severin", lat: 45.30, lng: 21.89),
        Judet(name: "Calarasi", lat: 44.20, lng: 27.33),
        Judet(name: "Cluj", lat: 46.77, lng: 23.60),
        Judet(name: "Constanta", lat: 44.18, lng: 28.65),
        Judet(name: "Covasna", lat: 45.86, lng: 25.79),
        Judet(name: "Dambovita", lat: 44.93, lng: 25.46),
        Judet(name: "Dolj", lat: 44.32, lng: 23.80),
        Judet(name: "Galati", lat: 45.44, lng: 28.05),
        Judet(name: "Giurgiu", lat: 43.90, lng: 25.97),
        Judet(name: "Gorj", lat: 45.03, lng: 23.28),
        Judet(name: "Harghita", lat: 46.36, lng: 25.80),
        Judet(name: "Hunedoara", lat: 45.88, lng: 22.90),
        Judet(name: "Ialomita", lat: 44.56, lng: 27.37),
        Judet(name: "Iasi", lat: 47.16, lng: 27.59),
        Judet(name: "Ilfov", lat: 44.55, lng: 26.10),
        Judet(name: "Maramures", lat: 47.66, lng: 23.57),
        Judet(name: "Mehedinti", lat: 44.63, lng: 22.66),
        Judet(name: "Mures", lat: 46.54, lng: 24.56),
        Judet(name: "Neamt", lat: 46.93, lng: 26.38),
        Judet(name: "Olt", lat: 44.43, lng: 24.37),
        Judet(name: "Prahova", lat: 44.94, lng: 26.02),
        Judet(name: "Satu Mare", lat: 47.79, lng: 22.89),
        Judet(name: "Salaj", lat: 47.19, lng: 23.06),
        Judet(name: "Sibiu", lat: 45.79, lng: 24.15),
        Judet(name: "Suceava", lat: 47.65, lng: 26.25),
        Judet(name: "Teleorman", lat: 43.98, lng: 25.33),
        Judet(name: "Timis", lat: 45.75, lng: 21.23),
        Judet(name: "Tulcea", lat: 45.18, lng: 28.80),
        Judet(name: "Vaslui", lat: 46.64, lng: 27.73),
        Judet(name: "Valcea", lat: 45.10, lng: 24.37),
        Judet(name: "Vrancea", lat: 45.70, lng: 27.18),
        Judet(name: "Bucuresti", lat: 44.43, lng: 26.10),
    ]

    static var names: [String] {
        all.map { $0.name }
    }
}
