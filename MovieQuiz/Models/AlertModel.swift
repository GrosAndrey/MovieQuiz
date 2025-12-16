//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 12.12.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let completion: () -> Void
}
