import ARKit

protocol PlaneDelegate: class {
    func planeDestroyed(plane: Plane)
    func planeReachPlayer()
}

class Plane: SCNNode {
    
    weak var delegate: PlaneDelegate?
    
    var maxPlaneHealth: Int
    var currentPlaneHealth: Int
    
    var healthBar: PlaneHealthBar?
        
    override init() {
        
        self.maxPlaneHealth = Int.random(in: 4 ... 8)
        self.currentPlaneHealth = self.maxPlaneHealth
        
        super.init()
        
        let scene = SCNScene(named: "ship.scn")
        guard let plane = scene?.rootNode.childNode(withName: "ship", recursively: true) else { return }
        
        self.addChildNode(plane)
        
        self.transform.m41 = Float.random(in: -2.5 ... 1.5) // X
        self.transform.m42 = Float.random(in: -1.5 ... 1.5) // Y
        self.transform.m43 = Float.random(in: -5 ... -3) // Z
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = [.X, .Y, .Z]
        self.constraints = [billboardConstraint]
                
        let shape = SCNPhysicsShape(geometry: SCNBox(width: 0.67, height: 0.17, length: 0.4, chamferRadius: 0), options: nil)

        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false

        self.physicsBody?.categoryBitMask = Collisions.plane.rawValue
        self.physicsBody?.collisionBitMask = Collisions.bullet.rawValue
        
        let emptyHealthBar = PlaneHealthBar(color: .red)
        emptyHealthBar.position = SCNVector3(emptyHealthBar.position.x - 0.3, emptyHealthBar.position.y + 0.15, emptyHealthBar.position.z - 0.601)
        self.addChildNode(emptyHealthBar)
        
        let healthBar = PlaneHealthBar(color: .green)
        healthBar.position = SCNVector3(healthBar.position.x - 0.3, healthBar.position.y + 0.15, healthBar.position.z - 0.6)
        self.addChildNode(healthBar)
        self.healthBar = healthBar
        
        let time = Double.random(in: 5 ... 10)
        let move = SCNAction.move(to: SCNVector3(0, 0, 0), duration: time)
        move.timingMode = .linear
        self.runAction(move) { [weak self] in
            self?.delegate?.planeReachPlayer()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func planeHitDetected(damage: Int) {
        guard self.currentPlaneHealth != 0 else { return }
        if self.currentPlaneHealth >= damage {
            self.currentPlaneHealth -= damage
        }
        else {
            self.currentPlaneHealth = 0
        }
        self.healthBar?.scale = SCNVector3(Double(self.currentPlaneHealth) / Double(self.maxPlaneHealth), 1, 1)
        if self.currentPlaneHealth <= 0 {
            self.delegate?.planeDestroyed(plane: self)
        }
    }
}
