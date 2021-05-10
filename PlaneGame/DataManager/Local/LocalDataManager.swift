import Foundation

protocol LocalDataManager {
    func getHighScore(completion: @escaping (Int) -> ())

    func setHighScore(score: Int, completion: @escaping () -> ())
}
