import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    private var alertPresenter = ResultAlertPresenter()
    private var presenter: MovieQuizPresenter?
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = UIImage(data: step.imageData) ?? UIImage()
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title,
                               message: result.text,
                               buttonText: result.buttonText) { [weak self] in
            guard let self = self else { return }
            
            self.presenter?.restartGame()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            
            self.presenter?.restartGame()
            self.showLoadingIndicator()
        }
        
        alertPresenter.show(in: self, model: model)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func changeButtonActivity(isEnabled: Bool) {
        yesButton.isEnabled = isEnabled
        noButton.isEnabled = isEnabled
    }
    
    func resetBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        changeButtonActivity(isEnabled: false)
        presenter?.didAnswer(isYes: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        changeButtonActivity(isEnabled: false)
        presenter?.didAnswer(isYes: false)
    }
}
