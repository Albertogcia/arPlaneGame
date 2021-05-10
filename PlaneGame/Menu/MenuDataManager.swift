import Foundation

protocol MenuDataManager {
    func getHighScore(completion: @escaping (Int) -> ())
    
    func setHighScore(score: Int, completion: @escaping () -> ())
}
