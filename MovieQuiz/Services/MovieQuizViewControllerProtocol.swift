//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 21.01.2026.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
    func showNetworkError(message: String)
    
    func resetBorder()
    func changeButtonActivity(isEnabled: Bool)
}
