import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter = ResultAlertPresenter()
    private let presenter = MovieQuizPresenter()
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        presenter.viewController = self
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = UIImage(data: step.image) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title,
                               message: result.text,
                               buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            questionFactory?.requestNextQuestion()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.questionFactory = self.questionFactory
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
            
            self.showLoadingIndicator()
            self.questionFactory?.loadData()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func changeButtonActivity(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func resetBorder() {
        imageView.layer.borderWidth = 0
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        changeButtonActivity(isEnabled: false)
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        changeButtonActivity(isEnabled: false)
        presenter.noButtonClicked()
    }
}
