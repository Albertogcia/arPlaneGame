import ARKit
import UIKit

class GameScreenView: UIView {
    
    lazy var sceneView: ARSCNView = {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    lazy var aimImageView: UIImageView = {
        let aimImageView = UIImageView(frame: .zero)
        aimImageView.translatesAutoresizingMaskIntoConstraints = false
        aimImageView.image = UIImage(named: "aim")
        return aimImageView
    }()
    
    lazy var scoreboardLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.textColor = .black
        label.textAlignment = .center
        label.layer.cornerRadius = 20
        label.clipsToBounds = true
        label.text = "SCORE: 0"
        return label
    }()
    
    lazy var exitButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Exit", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    lazy var doubleAmmoTextLabel: UILabel = {
        let ammoNameLabel = UILabel(frame: .zero)
        ammoNameLabel.translatesAutoresizingMaskIntoConstraints = false
        ammoNameLabel.textColor = .white
        ammoNameLabel.textAlignment = .center
        ammoNameLabel.text = "0"
        return ammoNameLabel
    }()
        
    lazy var doubleAmmoBox: UIStackView = {
         let dmgLabel = UILabel(frame:.zero)
         dmgLabel.translatesAutoresizingMaskIntoConstraints = false
         dmgLabel.backgroundColor = .blue
         dmgLabel.textColor = .white
         dmgLabel.textAlignment = .center
         dmgLabel.font = dmgLabel.font.withSize(20)
         dmgLabel.text = "x2"
         //
         let stackView = UIStackView(arrangedSubviews: [dmgLabel, doubleAmmoTextLabel])
         stackView.backgroundColor = UIColor.black
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.layer.cornerRadius = 10
         stackView.clipsToBounds = true
         stackView.axis = .vertical
         stackView.alpha = 0.4
         //
         return stackView
     }()
    
    lazy var normalAmmoBox: UIStackView = {
         let dmgLabel = UILabel(frame:.zero)
         dmgLabel.translatesAutoresizingMaskIntoConstraints = false
         dmgLabel.backgroundColor = .red
         dmgLabel.textColor = .white
         dmgLabel.textAlignment = .center
         dmgLabel.font = dmgLabel.font.withSize(20)
         dmgLabel.text = "x1"
         //
         let ammoNameLabel = UILabel(frame: .zero)
         ammoNameLabel.translatesAutoresizingMaskIntoConstraints = false
         ammoNameLabel.textColor = .white
         ammoNameLabel.textAlignment = .center
         ammoNameLabel.text = "∞"
         //
         let stackView = UIStackView(arrangedSubviews: [dmgLabel, ammoNameLabel])
         stackView.backgroundColor = UIColor.black
         stackView.translatesAutoresizingMaskIntoConstraints = false
         stackView.layer.cornerRadius = 10
         stackView.clipsToBounds = true
         stackView.axis = .vertical
         //
         return stackView
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViews()
    }
    
    private func loadViews() {
        addSubview(sceneView)
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: topAnchor),
            sceneView.leftAnchor.constraint(equalTo: leftAnchor),
            sceneView.rightAnchor.constraint(equalTo: rightAnchor),
            sceneView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(aimImageView)
        NSLayoutConstraint.activate([
            aimImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            aimImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            aimImageView.widthAnchor.constraint(equalToConstant: 45),
            aimImageView.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        addSubview(scoreboardLabel)
        NSLayoutConstraint.activate([
            scoreboardLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scoreboardLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            scoreboardLabel.widthAnchor.constraint(equalToConstant: 150),
            scoreboardLabel.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        addSubview(exitButton)
        NSLayoutConstraint.activate([
            exitButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            exitButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 100),
            exitButton.heightAnchor.constraint(equalToConstant: 45)
        ])
                
        addSubview(doubleAmmoBox)
        NSLayoutConstraint.activate([
            doubleAmmoBox.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30),
            doubleAmmoBox.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            doubleAmmoBox.widthAnchor.constraint(equalToConstant: 60),
            doubleAmmoBox.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        addSubview(normalAmmoBox)
        NSLayoutConstraint.activate([
            normalAmmoBox.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 30),
            normalAmmoBox.bottomAnchor.constraint(equalTo: doubleAmmoBox.topAnchor, constant: -10),
            normalAmmoBox.widthAnchor.constraint(equalToConstant: 60),
            normalAmmoBox.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
