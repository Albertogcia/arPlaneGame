import ARKit

class Bullet: SCNNode {
    let speed: Float = 9
    let damage: Int

    init(camera: ARCamera, damage: Int) {
        self.damage = damage
        let color: UIColor = damage == 1 ? UIColor.red : UIColor.blue
        super.init()

        let bullet = SCNSphere(radius: 0.02)
        let material = SCNMaterial()
        material.diffuse.contents = color
        bullet.materials = [material]
        self.geometry = bullet

        let shape = SCNPhysicsShape(geometry: bullet, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false

        self.physicsBody?.categoryBitMask = Collisions.bullet.rawValue
        self.physicsBody?.contactTestBitMask = Collisions.plane.rawValue

        let matrix = SCNMatrix4(camera.transform)
        let v = -self.speed
        let dir = SCNVector3(v * matrix.m31, v * matrix.m32, v * matrix.m33)
        let pos = SCNVector3(matrix.m41, matrix.m42, matrix.m43)

        self.position = pos
        self.physicsBody?.applyForce(dir, asImpulse: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
