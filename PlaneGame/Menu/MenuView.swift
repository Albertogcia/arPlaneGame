import UIKit

class MenuView: UIView{
    
    lazy var highScoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = label.font.withSize(25)
        label.textAlignment = .center
        return label
    }()
    
    lazy var startGameButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("Start game", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadViews()
    }
    
    private func loadViews(){
        backgroundColor = .lightGray
        
        self.addSubview(highScoreLabel)
        NSLayoutConstraint.activate([
            highScoreLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            highScoreLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            highScoreLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30)
        ])
        
        self.addSubview(startGameButton)
        NSLayoutConstraint.activate([
            startGameButton.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor, constant: 30),
            startGameButton.bottomAnchor.constraint(greaterThanOrEqualTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            startGameButton.widthAnchor.constraint(equalToConstant: 150),
            startGameButton.heightAnchor.constraint(equalToConstant: 50),
            startGameButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
