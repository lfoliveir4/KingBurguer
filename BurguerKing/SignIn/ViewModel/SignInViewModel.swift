import Foundation
import Combine

final class SignInViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var state: SignInState = .none
    
    var isValidEmailPublisher: AnyPublisher<Bool, Never> {
        $email.map { $0.isValidEmail }
            .eraseToAnyPublisher()
    }
    
    var isValidPasswordPublisher: AnyPublisher<Bool, Never> {
        $password.map { !$0.isEmpty }
            .eraseToAnyPublisher()
    }
    
    var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isValidEmailPublisher, isValidPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }

    var coordinator: SignInCoordinator?
    let interactor = SignInInteractor()
    
    func send() {
        state = .loading
        
        interactor.login(request: .init(username: email, password: password)) { created, error in
            DispatchQueue.main.async {
                if let errorMessage = error {
                    self.state = .error(errorMessage)
                } else {
                    self.state = .success
                }
            }
        }
    }
    
    func goToSignUp() {
        coordinator?.signUp()
    }
    
    func goToHome() {
        coordinator?.home()
    }
}
