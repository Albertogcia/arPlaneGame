import Foundation

protocol GameScreenCoordinatorDelegate: class {
    func onGameFinished(score: Int)
}

protocol GameScreenViewDelegate: class {
    func addNewPlane()
    func addNewAmmoBox()
    func selectNormalAmmoBox()
    func selectDoubleAmmoBox()
    func updateDoubleAmmoLabel(total: Int)
    func updateScoreboard(total: Int)
    func shootBullet(camera: Any, damage: Int)
    func showExplosionAndRemoveNode(node: Any)
}

class GameScreenViewModel {
    
    weak var coordinatorDelegate: GameScreenCoordinatorDelegate?
    weak var viewDelegate: GameScreenViewDelegate?
    
    var planeTimer: Timer?
    var ammoTimer: Timer?
    
    var doubleAmmoSelected: Bool = false
    
    var score: Int = 0
    var doubleAmmo: Int = 0
    
    func viewWasLoaded() {
        viewDelegate?.addNewPlane()
        setTimers()
    }
    
    @objc private func addNewPlane() {
        viewDelegate?.addNewPlane()
    }
    
    @objc private func addNewAmmoBox() {
        self.viewDelegate?.addNewAmmoBox()
    }
    
    func planeIsDestroyed(plane: Any) {
        score += 1
        viewDelegate?.updateScoreboard(total: score)
        viewDelegate?.showExplosionAndRemoveNode(node: plane)
        addNewPlane()
    }
    
    func ammoBoxIsDestroyed(ammoBox: Any) {
        doubleAmmo += Int.random(in: 5 ... 10)
        viewDelegate?.updateDoubleAmmoLabel(total: doubleAmmo)
        viewDelegate?.showExplosionAndRemoveNode(node: ammoBox)
    }
    
    func screenTapped(camera: Any) {
        var dmg = 1
        if doubleAmmoSelected, doubleAmmo > 0 {
            doubleAmmo -= 1
            viewDelegate?.updateDoubleAmmoLabel(total: doubleAmmo)
            dmg = 2
            if doubleAmmo <= 0 {
                doubleAmmoSelected = false
                viewDelegate?.selectNormalAmmoBox()
            }
        }
        viewDelegate?.shootBullet(camera: camera, damage: dmg)
    }
    
    func normalAmmoTapped() {
        viewDelegate?.selectNormalAmmoBox()
        doubleAmmoSelected = false
    }
    
    func doubleAmmoTaped() {
        if doubleAmmo > 0 {
            viewDelegate?.selectDoubleAmmoBox()
            doubleAmmoSelected = true
        }
    }
    
    func gameEnded() {
        stopTimers()
        coordinatorDelegate?.onGameFinished(score: score)
    }
    
    func setTimers() {
        planeTimer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(addNewPlane), userInfo: nil, repeats: true)
        ammoTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(addNewAmmoBox), userInfo: nil, repeats: true)
    }
    
    func stopTimers() {
        planeTimer?.invalidate()
        ammoTimer?.invalidate()
    }
}
