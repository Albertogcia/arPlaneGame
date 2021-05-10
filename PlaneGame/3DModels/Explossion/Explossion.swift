import ARKit

class Explossion: SCNNode {
    static func show(with node: SCNNode, in scene: SCNScene) {
        guard let explossion = SCNParticleSystem(named: "Explossion", inDirectory: nil) else { return }
        let p = node.position
        let translationMatrix = SCNMatrix4MakeTranslation(p.x, p.y, p.z)
        let r = node.rotation
        let rotationMAtrix = SCNMatrix4MakeRotation(r.w, r.x, r.y, r.z)
        let transformMatrix = SCNMatrix4Mult(rotationMAtrix, translationMatrix)
        explossion.emitterShape = node.geometry
        scene.addParticleSystem(explossion, transform: transformMatrix)
    }
}
