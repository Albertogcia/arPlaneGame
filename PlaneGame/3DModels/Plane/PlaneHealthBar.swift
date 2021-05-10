import ARKit

class PlaneHealthBar: SCNNode {
    init(color: UIColor) {
        super.init()
        
        let shape = SCNShape(path: UIBezierPath(rect: CGRect(x: 0, y: 0, width: 0.6, height: 0.02)), extrusionDepth: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = color
        shape.materials = [material]
        self.geometry = shape
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
