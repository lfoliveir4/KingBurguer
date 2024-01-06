import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var document: String = ""
    @Published var birthday: String = ""
    @Published var state: SignUpState = .none
    
    let webService = WebService.instance
    
    private var validators: [AnyPublisher<Bool, Never>] = []
    var coordinator: SignUpCoordinator?
    
    var isValidNamePublisher: AnyPublisher<Bool, Never> {
        $name.map { !$0.isEmpty }.eraseToAnyPublisher()
    }
    
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email.map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }
    
    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password.map { !$0.isEmpty }.eraseToAnyPublisher()
    }
    
    var isValidDocumentPublisher: AnyPublisher<Bool, Never> {
        $document.map { !$0.isEmpty }.eraseToAnyPublisher()
    }
    
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            isValidNamePublisher,
            isValidEmailPublisher,
            isValidPasswordPublisher,
            isValidDocumentPublisher
        )
        .map { $0 && $1 && $2 && $3 }
        .eraseToAnyPublisher()
    }
    
    private let interactor = SignUpInteractor()
    
    func send() {
        state = .loading
        
        interactor.createUser(request: .init(
            name: name,
            email: email,
            password: password,
            document: document,
            birthday: birthday
        )) { created, error in
            DispatchQueue.main.async {
                if let errorMessage = error {
                    self.state = .error(errorMessage)
                } else if let created = created {
                    if created {
                        self.state = .success
                    }
                }
            }
        }
    }
    
    func goToHome() {
        coordinator?.home()
    }
}
