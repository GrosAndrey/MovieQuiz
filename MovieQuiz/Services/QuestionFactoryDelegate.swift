//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Андрей Грошев on 10.12.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
