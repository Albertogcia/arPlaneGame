import UIKit
import Foundation

class MenuCoordinator: Coordinator {
    let presenter: UINavigationController
    let menuDataManager: MenuDataManager

    var menuViewModel: MenuViewModel?
    var gameScreenCoordinator: GameScreenCoordinator?

    init(presenter: UINavigationController, menuDataManager: MenuDataManager) {
        self.presenter = presenter
        self.menuDataManager = menuDataManager
    }

    override func start() {
        let menuViewModel = MenuViewModel(menuDataManager: menuDataManager)
        let menuViewController = MenuViewController(viewModel: menuViewModel)
        menuViewModel.viewDelegate = menuViewController
        menuViewModel.coordinatorDelegate = self
        self.menuViewModel = menuViewModel
        self.presenter.pushViewController(menuViewController, animated: false)
    }

    override func finish() {}
}

extension MenuCoordinator: MenuCoordinatorDelegate {
    func startGame() {
        let gameScreenCoordinator = GameScreenCoordinator(presenter: presenter)
        addChildCoordinator(gameScreenCoordinator)
        gameScreenCoordinator.coordinatorFinishDelegate = self
        self.gameScreenCoordinator = gameScreenCoordinator
        gameScreenCoordinator.start()
    }
}

extension MenuCoordinator: GameScreenCoordinatorFinishDelegate {
    func onGameFinished(score: Int) {
        DispatchQueue.main.async { [weak self] in
            if let gameScreenCoordinator = self?.gameScreenCoordinator {
                gameScreenCoordinator.finish()
                self?.removeChildCoordinator(gameScreenCoordinator)
            }
            self?.menuViewModel?.onGameFinished(score: score)
        }
    }
}
