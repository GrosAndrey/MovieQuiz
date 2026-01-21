//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 20.01.2026.
//

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    var correctAnswers: Int = 0
    var questionFactory: QuestionFactoryProtocol?
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    private var currentQuestionIndex: Int = 0
    private var statisticService: StatisticServiceProtocol?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        self.statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
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
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            let message: String = statisticService?.getResultGame(correct: correctAnswers, total: self.questionsAmount) ?? ""
            let resultQuiz: QuizResultsViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: message,
                buttonText: "Сыграть еще раз")
            
            viewController?.show(quiz: resultQuiz)
            
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
        viewController?.resetBorder()
        viewController?.changeButtonActivity(isEnabled: true)
    }
}
