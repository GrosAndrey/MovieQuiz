//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 10.12.2025.
//

import Foundation

// вью модель для состояния "Вопрос показан"
struct QuizStepViewModel {
    // картинка с афишей фильма с типом Data
    let image: Data
    // вопрос о рейтинге квиза
    let question: String
    // строка с порядковым номером этого вопроса (ex. "1/10")
    let questionNumber: String
}
