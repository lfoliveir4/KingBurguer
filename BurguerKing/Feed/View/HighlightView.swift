import UIKit

protocol HighlightViewDelegate {
    func highlightSelected(productId: Int)
}

final class HighlightView: UIView {
    var delegate: HighlightViewDelegate?
    var id: Int?

    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "highlight")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Resgatar Cupom", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 7
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(highlightDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradient()
        
        addSubview(moreButton)
        moreButtonConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    private func moreButtonConstraints() {
        NSLayoutConstraint.activate([
            moreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            moreButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50.0)
        ])
    }
    
    @objc func highlightDidTap() {
        if let id {
            delegate?.highlightSelected(productId: id)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
