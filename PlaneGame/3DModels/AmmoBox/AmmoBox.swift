import ARKit

class AmmoBox: SCNNode{
    
    override init() {
        super.init()
        
        let scene = SCNScene(named: "ammoBox.scn")
        guard let ammoBox = scene?.rootNode.childNode(withName: "ammoBox", recursively: true) else { return }
        
        self.addChildNode(ammoBox)
        
        self.transform.m41 = Float.random(in: -2.5 ... 1.5) // X
        self.transform.m42 = Float.random(in: -1.5 ... 1.5) // Y
        self.transform.m43 = -3 // Z
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = [.X, .Y, .Z]
        self.constraints = [billboardConstraint]
        
        let shape = SCNPhysicsShape(geometry: SCNBox(width: 0.4, height: 0.2, length: 0.2, chamferRadius: 0), options: nil)
        self.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        self.physicsBody?.categoryBitMask = Collisions.plane.rawValue
        self.physicsBody?.collisionBitMask = Collisions.bullet.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
