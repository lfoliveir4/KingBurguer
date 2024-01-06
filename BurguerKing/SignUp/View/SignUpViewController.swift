import UIKit
import Combine

final class SignUpViewController: UIViewController {
    
    var viewModel = SignUpViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let notificationCenter = NotificationCenter.default
    
    let scrollview: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UITextField = {
        let field = UITextField()
        field.placeholder = "Name"
        field.borderStyle = .roundedRect
        field.returnKeyType = .next
        field.text = "LF OLIVEIRA"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var email: UITextField = {
        let field = UITextField()
        field.placeholder = "E-mail"
        field.borderStyle = .roundedRect
        field.returnKeyType = .next
        field.text = "luis.felipi@hotmail.com"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var password: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.returnKeyType = .next
        field.isSecureTextEntry = true
        field.text = "123"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var document: UITextField = {
        let field = UITextField()
        field.placeholder = "CPF"
        field.borderStyle = .roundedRect
        field.returnKeyType = .next
        field.text = "35480613898"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var birthday: UITextField = {
        let field = UITextField()
        field.placeholder = "Birthday"
        field.borderStyle = .roundedRect
        field.returnKeyType = .done
        field.text = "2019-08-12"
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var register: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Criar Conta", for: .normal)
        button.backgroundColor = .red
        button.tintColor = .white
        button.addTarget(
            self,
            action: #selector(onSubmit),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LIFE CICLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // MARK: - CONTAINER SUBVIEWS
        container.addSubview(name)
        container.addSubview(email)
        container.addSubview(password)
        container.addSubview(document)
        container.addSubview(birthday)
        container.addSubview(register)
        
        // MARK: - SCROLLVIEW SUBVIEWS
        scrollview.addSubview(container)
        scrollview.showsVerticalScrollIndicator = false
        
        // MARK: - VIEW SUBVIEWS
        view.addSubview(scrollview)
        
        setupConstraints()
        setupPublishers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    private func setupPublishers() {
        notificationCenter
            .publisher(for: UITextField.textDidChangeNotification, object: name)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.name, on: viewModel)
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: UITextField.textDidChangeNotification, object: email)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: UITextField.textDidChangeNotification, object: password)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: UITextField.textDidChangeNotification, object: document)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.document, on: viewModel)
            .store(in: &cancellables)
        
        notificationCenter
            .publisher(for: UITextField.textDidChangeNotification, object: birthday)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.birthday, on: viewModel)
            .store(in: &cancellables)
        
        viewModel.isSubmitEnabled
            .assign(to: \.isEnabled, on: register)
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .none:
                    break
                case .loading:
                    self?.register.isEnabled = false
                    self?.register.setTitle("Cadastrando ...", for: .normal)
                case .success:
                    self?.viewModel.goToHome()
                case .error(let message):
                    let alert = UIAlertController(
                        title: "Erro Inesperado",
                        message: message,
                        preferredStyle: .actionSheet
                    )
                    let action = UIAlertAction(title: "Fechar", style: .default)
                    alert.addAction(action)
                    self?.present(alert, animated: true)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupConstraints() {
        
        // MARK: - SCROLLVIEW
        NSLayoutConstraint.activate([
            scrollview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let heightConstraint = container.heightAnchor.constraint(equalTo: view.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        // MARK: - CONTAINER
        NSLayoutConstraint.activate([
            container.widthAnchor.constraint(equalTo: view.widthAnchor),
            container.topAnchor.constraint(equalTo: scrollview.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollview.bottomAnchor),
            container.trailingAnchor.constraint(equalTo: scrollview.trailingAnchor),
            container.leadingAnchor.constraint(equalTo: scrollview.leadingAnchor),
        ])
        
        // MARK: - NAME FIELD
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            name.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            name.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
            name.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        // MARK: - EMAIL FIELD
        NSLayoutConstraint.activate([
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10.0),
            email.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        // MARK: - PASSWORD FIELD
        NSLayoutConstraint.activate([
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10.0),
            password.heightAnchor.constraint(equalToConstant: 50.0),
        ])
        
        // MARK: - DOCUMENT FIELD
        NSLayoutConstraint.activate([
            document.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            document.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            document.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10.0),
            document.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        // MARK: - BIRTHDAY FIELD
        NSLayoutConstraint.activate([
            birthday.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            birthday.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            birthday.topAnchor.constraint(equalTo: document.bottomAnchor, constant: 10.0),
            birthday.heightAnchor.constraint(equalToConstant: 50.0)
        ])
        
        // MARK: - REGISTER BUTTON
        NSLayoutConstraint.activate([
            register.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            register.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            register.topAnchor.constraint(equalTo: birthday.topAnchor, constant: 60.0),
            register.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    @objc func hideKeyboard(_ view: UITapGestureRecognizer) {
        self.view.endEditing(true)
        scrollview.setContentOffset(.zero, animated: true)
    }
    
    @objc func onSubmit() {
        viewModel.send()
    }
}

#Preview {
    SignUpViewController()
}
