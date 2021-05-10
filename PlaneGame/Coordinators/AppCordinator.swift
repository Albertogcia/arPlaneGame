import UIKit

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    lazy var remoteDataManager: RemoteDataManager = {
        return RemoteDataManagerImp()
    }()
    
    lazy var localDataManager: LocalDataManager = {
        return LocalDataManagerImp()
    }()
    
    lazy var dataManager: DataManager = {
        return DataManager(localDataManager: self.localDataManager, remoteDataManager: self.remoteDataManager)
    }()

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        let menuCoordinator = MenuCoordinator(presenter: navigationController, menuDataManager: dataManager)
        addChildCoordinator(menuCoordinator)
        menuCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    override func finish() {}
}
