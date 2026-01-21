//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 20.01.2026.
//

import Foundation

final class MovieQuizPresenter {
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image, // <- здесь убрали преобразование в UIImage и храним «сырые» данные
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
}
