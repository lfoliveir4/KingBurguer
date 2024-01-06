import Foundation
import UIKit
import Combine

final class SignInViewController: UIViewController {

    var viewModel = SignInViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let notificationCenter = NotificationCenter.default
    
    let scrollView: UIScrollView = {
        let scrollview = UIScrollView()
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()
    
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let email: UITextField = {
        let field = UITextField()
        field.placeholder = "e-mail"
        field.textContentType = .emailAddress
        field.keyboardType = .emailAddress
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let password: UITextField = {
        let field = UITextField()
        field.placeholder = "password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .red
        button.tintColor = .white
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onSubmit), for: .touchUpInside)
        return button
    }()
    
    private lazy var register: UIButton = {
        let registerButton = UIButton()
        registerButton.setTitle("Criar Conta", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(
            self,
            action: #selector(registerButtonDidTap),
            for: .touchUpInside
        )
        return registerButton
    }()
    
    // MARK: - LIFE CICLE
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Login"

        setupConstraints()
        setupPublishers()
    }
    
    // MARK: - CONSTRAINTS
    private func setupConstraints() {
        view.addSubview(email)
        NSLayoutConstraint.activate([
            email.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            email.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            email.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            email.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        view.addSubview(password)
        NSLayoutConstraint.activate([
            password.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10.0),
            password.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        view.addSubview(submitButton)
        NSLayoutConstraint.activate([
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            submitButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 15.0),
            submitButton.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        view.addSubview(register)
        NSLayoutConstraint.activate([
            register.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            register.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            register.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 15.0),
            register.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    // MARK: - PUBLISHERS
    private func setupPublishers() {
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
        
        viewModel.isSubmitEnabled
            .assign(to: \.isEnabled, on: submitButton)
            .store(in: &cancellables)
        
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .none:
                    break
                case .loading:
                    self?.submitButton.isEnabled = false
                    self?.submitButton.setTitle("Entrando ...", for: .normal)
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
    
    // MARK: - OBJC FUNCS
    @objc private func onSubmit(_ sender: UIButton) {
        viewModel.send()
    }
    
    @objc private func registerButtonDidTap(_ sender: UIButton) {
        viewModel.goToSignUp()
    }
    
    @objc func hideKeyboard(_ view: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
