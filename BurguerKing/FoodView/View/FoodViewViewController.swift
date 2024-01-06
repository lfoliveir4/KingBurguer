import UIKit
import SDWebImage

final class FoodViewViewController: UIViewController {
    var id: Int!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.backgroundColor = .systemBackground
        activity.startAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .red
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .red
        label.font = .systemFont(ofSize: 18)
        label.clipsToBounds = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var foodDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .darkText
        label.sizeToFit()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Resgatar Cupom", for: .normal)
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 7
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(couponDidTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var viewModel: FoodViewViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.fetch(id: id)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationItem.title = "Cupom"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(stackView)
        view.addSubview(button)
        view.addSubview(activityIndicator)
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(container)
        stackView.addArrangedSubview(foodDescription)
        
        container.addSubview(name)
        container.addSubview(price)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        // MARK: - IMAGE CONSTRAINTS
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerYAnchor.constraint(equalTo: stackView.centerYAnchor, constant: -200)
        ])
        
        // MARK: - CONTAINER (UIVIEW) CONSTRAINTS
        container.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // MARK: - DESCRIPTION CONSTRAINTS
        foodDescription.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -40).isActive = true
            
        // MARK: - LABEL CONSTRAINTS
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            name.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
        ])
        
        // MARK: - PRICE CONSTRAINTS
        NSLayoutConstraint.activate([
            price.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            price.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
        ])
        
        // MARK: - BUTTON CONSTRAINTS
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // MARK: - ACTIVITY INDICATOR CONSTRAINTS
        NSLayoutConstraint.activate([
            activityIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }
    
    @objc private func couponDidTap() {
        viewModel?.createCoupon(id: id)
    }
}

extension FoodViewViewController: FoodViewViewModelDelegate {
    func viewModelDidChange(state: FoodViewState) {
        switch state {
        case .loading:
            break
        case .success(let response):
            DispatchQueue.main.async { [self] in
                buildProductScreen(response: response)
            }
            break
        case .successCoupon(let response):
            DispatchQueue.main.async { [self] in
                buildCouponAlert(response: response)
            }
            break
        case .error(let message):
            activityIndicator.stopAnimating()
            print("\(message)")
            break
        }
    }
    
    private func priceFormatter(price: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "PT-BR")
        return formatter.string(from: price as NSNumber)
    }
    
    private func buildProductScreen(response: FoodViewResponse) {
        name.text = response.name
        foodDescription.text = response.description
        imageView.sd_setImage(with: URL(string: response.pictureURL))
        price.text = priceFormatter(price: response.price)
        activityIndicator.stopAnimating()
    }
    
    private func buildCouponAlert(response: CouponResponse) {
        let alert = UIAlertController(
            title: "KingBurguer",
            message: "Cupom gerado: \(response.coupon)",
            preferredStyle: .alert
        )
        
        alert.addAction(.init(title: "Ok", style: .default))
        
        self.present(alert, animated: true)
    }
}
