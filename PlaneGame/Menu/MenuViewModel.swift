import AVKit
import Foundation

protocol MenuCoordinatorDelegate: class {
    func startGame()
}

protocol MenuViewDelegate: class {
    func setHighScore(score: Int)
    func showCameraErrorMessage()
}

class MenuViewModel {
    
    let menuDataManager: MenuDataManager
    weak var coordinatorDelegate: MenuCoordinatorDelegate?
    weak var viewDelegate: MenuViewDelegate?
    
    var latestHighScore: Int = 0
    
    init(menuDataManager: MenuDataManager) {
        self.menuDataManager = menuDataManager
    }
    
    func viewWasLoaded() {
        getHigherScore()
    }
    
    func getHigherScore() {
        menuDataManager.getHighScore { [weak self] score in
            self?.latestHighScore = score
            self?.viewDelegate?.setHighScore(score: score)
        }
    }
        
    func startGameButtonTapped() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                coordinatorDelegate?.startGame()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) {[weak self] granted in
                    DispatchQueue.main.async {
                        if granted {
                            self?.coordinatorDelegate?.startGame()
                        }
                        else{
                            self?.viewDelegate?.showCameraErrorMessage()
                        }
                    }
                }
            default:
                self.viewDelegate?.showCameraErrorMessage()
        }
    }
    
    func onGameFinished(score: Int) {
        if score > latestHighScore {
            latestHighScore = score
            menuDataManager.setHighScore(score: score) { [weak self] in
                self?.viewDelegate?.setHighScore(score: score)
            }
        }
    }
}
