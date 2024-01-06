import UIKit

final class SignInCoordinator {
    var window: UIWindow?
    private let navigationController: UINavigationController
    
    init(window: UIWindow? = nil) {
        self.window = window
        self.navigationController = UINavigationController()
    }
    
    func start() {
        let viewModel = SignInViewModel()
        viewModel.coordinator = self
        
        let signInViewController = SignInViewController()
        signInViewController.viewModel = viewModel
        
        navigationController.pushViewController(signInViewController, animated: true)
        window?.rootViewController = navigationController
    }
    
    func signUp() {
        let signUpCoordinator = SignUpCoordinator(navigationController: navigationController)
        signUpCoordinator.parentCoordinator = self
        signUpCoordinator.start()
    }
    
    func home() {
        let homeCoordinator = HomeCoordinator(window: window)
        homeCoordinator.start()        
    }
}
