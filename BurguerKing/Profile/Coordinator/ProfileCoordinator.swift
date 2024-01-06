import UIKit

final class ProfileCoordinator {
    private let navigationController: UINavigationController
    var parentCoordinator: HomeCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let interactor = ProfileInteractor()
        let viewModel = ProfileViewModel(interactor: interactor)
        viewModel.coordinator = self
        
        let profileViewController = ProfileViewController(style: .plain)
        profileViewController.viewModel = viewModel
        navigationController.pushViewController(profileViewController, animated: true)
    }
}
