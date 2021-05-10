import ARKit
import AVFoundation
import SceneKit
import UIKit

class GameScreenViewController: UIViewController {

    lazy var mainView: GameScreenView = {
        GameScreenView()
    }()

    let viewModel: GameScreenViewModel

    var explosionSound: AVAudioPlayer?

    init(viewModel: GameScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpComponents()
        viewModel.viewWasLoaded()
    }

    private func setUpComponents() {
        guard ARWorldTrackingConfiguration.isSupported else { return }

        if let path = Bundle.main.path(forResource: "explosionSound.wav", ofType: nil) {
            explosionSound = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            explosionSound?.prepareToPlay()
        }

        startTracking()

        mainView.sceneView.session.delegate = self
        mainView.sceneView.scene.physicsWorld.contactDelegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        mainView.sceneView.addGestureRecognizer(tap)

        mainView.exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)

        let normalAmmoBoxTap = UITapGestureRecognizer(target: self, action: #selector(normalAmmoTapped))
        mainView.normalAmmoBox.addGestureRecognizer(normalAmmoBoxTap)

        let doubleAmmoBoxTap = UITapGestureRecognizer(target: self, action: #selector(doubleAmmoTapped))
        mainView.doubleAmmoBox.addGestureRecognizer(doubleAmmoBoxTap)

        UIApplication.shared.isIdleTimerDisabled = true
    }

    private func startTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]

        mainView.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    private func ammoBoxDestroyed(ammoBox: AmmoBox) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.ammoBoxIsDestroyed(ammoBox: ammoBox)
        }
    }

    private func pauseAllNodes() {
        mainView.sceneView.scene.rootNode.childNodes.forEach { $0.isPaused = true }
    }

    private func resumeAllNodes() {
        mainView.sceneView.scene.rootNode.childNodes.forEach { $0.isPaused = false }
    }

    @objc func screenTapped() {
        guard let camera = mainView.sceneView.session.currentFrame?.camera else { return }
        viewModel.screenTapped(camera: camera)
    }

    @objc func normalAmmoTapped() {
        viewModel.normalAmmoTapped()
    }

    @objc func doubleAmmoTapped() {
        viewModel.doubleAmmoTaped()
    }

    @objc func exitButtonTapped() {
        pauseAllNodes()
        viewModel.stopTimers()
        let alertController = UIAlertController(title: "", message: "Do you really want to exit?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak self] _ in
            self?.viewModel.gameEnded()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] _ in
            self?.resumeAllNodes()
            self?.viewModel.setTimers()
        }))
        present(alertController, animated: true, completion: nil)
    }
}

extension GameScreenViewController: GameScreenViewDelegate {
    func addNewPlane() {
        let plane = Plane()
        plane.delegate = self
        mainView.sceneView.prepare([plane]) { [weak self] _ in
            self?.mainView.sceneView.scene.rootNode.addChildNode(plane)
        }
    }

    func addNewAmmoBox() {
        let ammoBox = AmmoBox()
        mainView.sceneView.prepare([ammoBox]) { [weak self] _ in
            self?.mainView.sceneView.scene.rootNode.addChildNode(ammoBox)
        }
    }

    func shootBullet(camera: Any, damage: Int) {
        guard let camera = camera as? ARCamera else { return }
        let bullet = Bullet(camera: camera, damage: damage)
        mainView.sceneView.scene.rootNode.addChildNode(bullet)
    }

    func showExplosionAndRemoveNode(node: Any) {
        guard let node = node as? SCNNode else { return }
        Explossion.show(with: node, in: mainView.sceneView.scene)
        if node is Plane, let explosionSound = explosionSound {
            explosionSound.play()
        }
        node.removeFromParentNode()
    }

    func updateDoubleAmmoLabel(total: Int) {
        mainView.doubleAmmoTextLabel.text = "\(total)"
    }

    func updateScoreboard(total: Int) {
        mainView.scoreboardLabel.text = "SCORE: \(total)"
    }

    func selectNormalAmmoBox() {
        mainView.normalAmmoBox.alpha = 1
        mainView.doubleAmmoBox.alpha = 0.4
    }

    func selectDoubleAmmoBox() {
        mainView.doubleAmmoBox.alpha = 1
        mainView.normalAmmoBox.alpha = 0.4
    }
}

extension GameScreenViewController: PlaneDelegate {
    func planeDestroyed(plane: Plane) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.planeIsDestroyed(plane: plane)
        }
    }

    func planeReachPlayer() {
        viewModel.gameEnded()
    }
}

extension GameScreenViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let n1 = contact.nodeA
        let n2 = contact.nodeB

        if let bullet = n1 as? Bullet {
            bullet.removeFromParentNode()
            if let plane = n2 as? Plane {
                plane.planeHitDetected(damage: bullet.damage)
            }
            else if let ammoBox = n2 as? AmmoBox {
                ammoBoxDestroyed(ammoBox: ammoBox)
            }
        }
        else if let bullet = n2 as? Bullet {
            bullet.removeFromParentNode()
            if let plane = n1 as? Plane {
                plane.planeHitDetected(damage: bullet.damage)
            }
            else if let ammoBox = n1 as? AmmoBox {
                ammoBoxDestroyed(ammoBox: ammoBox)
            }
        }
    }
}

extension GameScreenViewController: ARSessionDelegate {
    func sessionInterruptionEnded(_ session: ARSession) {
        startTracking()
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        startTracking()
    }
}
