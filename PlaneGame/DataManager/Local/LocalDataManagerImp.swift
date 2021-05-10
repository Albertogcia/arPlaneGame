import Foundation

class LocalDataManagerImp: LocalDataManager {
    func getHighScore(completion: @escaping (Int) -> ()) {
        completion(UserDefaults.standard.integer(forKey: "highScore"))
    }

    func setHighScore(score: Int, completion: @escaping () -> ()) {
        UserDefaults.standard.set(score, forKey: "highScore")
        completion()
    }
}
