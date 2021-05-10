import Foundation

class DataManager {
    let localDataManager: LocalDataManager
    let remoteDataManager: RemoteDataManager

    init(localDataManager: LocalDataManager, remoteDataManager: RemoteDataManager) {
        self.localDataManager = localDataManager
        self.remoteDataManager = remoteDataManager
    }
}

extension DataManager: MenuDataManager {
    func getHighScore(completion: @escaping (Int) -> ()) {
        localDataManager.getHighScore(completion: completion)
    }

    func setHighScore(score: Int, completion: @escaping () -> ()) {
        localDataManager.setHighScore(score: score, completion: completion)
    }
}
