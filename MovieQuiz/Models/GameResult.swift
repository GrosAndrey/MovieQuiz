//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 12.12.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        return correct > another.correct
    }
}
