import UIKit

protocol GameScreenCoordinatorFinishDelegate: class{
    func onGameFinished(score: Int)
}

class GameScreenCoordinator: Coordinator {
    let presenter: UINavigationController
    
    weak var coordinatorFinishDelegate: GameScreenCoordinatorFinishDelegate?
        
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    override func start() {
        let gameScreenViewModel = GameScreenViewModel()
        let gameScreenViewController = GameScreenViewController(viewModel: gameScreenViewModel)
        gameScreenViewModel.viewDelegate = gameScreenViewController
        gameScreenViewModel.coordinatorDelegate = self
        presenter.pushViewController(gameScreenViewController, animated: true)
    }
    
    override func finish() {
        presenter.popViewController(animated: true)
    }
}

extension GameScreenCoordinator: GameScreenCoordinatorDelegate{
    func onGameFinished(score: Int) {
        coordinatorFinishDelegate?.onGameFinished(score: score)
    }
}
