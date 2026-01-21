//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 20.01.2026.
//

import Foundation

final class MovieQuizPresenter {
    let questionsAmount: Int = 10
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    private var currentQuestionIndex: Int = 0
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: model.image,
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func checkAnswer(answer: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        viewController?.showAnswerResult(isCorrect: answer == currentQuestion.correctAnswer)
    }
}
