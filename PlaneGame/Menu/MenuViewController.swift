import UIKit

class MenuViewController: UIViewController {
    
    lazy var mainView: MenuView = {
        MenuView()
    }()
    
    let viewModel: MenuViewModel
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        mainView.startGameButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewWasLoaded()
    }
    
    @objc func startGameButtonTapped() {
        viewModel.startGameButtonTapped()
    }
}

extension MenuViewController: MenuViewDelegate {
    func setHighScore(score: Int) {
        mainView.highScoreLabel.text = "High score: \(score)"
    }
    
    func showCameraErrorMessage() {
        let alertController = UIAlertController(title: "Error", message: "Need to grant camera permission for playing the game", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }))
        present(alertController, animated: true, completion: nil)
    }
}
