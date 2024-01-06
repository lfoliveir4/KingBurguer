import UIKit

final class FeedCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeedCollectionViewCell"
    var product: Product! {
        willSet {
            if let url = URL(string: newValue.pictureURL) {
                imageView.sd_setImage(with: url)
            }
            name.text = newValue.name
            price.text = priceFormatter(price: newValue.price)
        }
    }
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = 7
        image.clipsToBounds = true
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.font = .systemFont(ofSize: 12)
        label.text = "Whoper"
        return label
    }()
    
    let price: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .red
        label.textColor = .white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightText.cgColor
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.text = "R$ 20,00"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(name)
        addSubview(price)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height - 80)
        name.frame = CGRect(x: 0, y: bounds.size.height - 80, width: bounds.size.width, height: 28)
        price.frame = CGRect(x: 0, y: bounds.size.height - 40, width: bounds.size.width, height: 38)
    }
    
    private func priceFormatter(price: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "PT-BR")
        return formatter.string(from: price as NSNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
