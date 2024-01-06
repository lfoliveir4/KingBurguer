import UIKit

final class SignUpCoordinator {
    private let navigationController: UINavigationController
    var parentCoordinator: SignInCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = SignUpViewModel()
        viewModel.coordinator = self
        
        let signUpViewController = SignUpViewController()
        signUpViewController.viewModel = viewModel
        
        navigationController.pushViewController(signUpViewController, animated: true)
    }
    
    func home() {
        parentCoordinator?.home()
    }
}
