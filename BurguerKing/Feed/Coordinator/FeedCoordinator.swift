import UIKit

final class FeedCoordinator {
    private let navigationController: UINavigationController
    var parentCoordinator: HomeCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let interactor = FeedInteractor()
        let viewModel = FeedViewModel(interactor: interactor)
        viewModel.coordinator = self
        
        let feedViewController = FeedViewController()
        feedViewController.viewModel = viewModel
        navigationController.pushViewController(feedViewController, animated: true)
    }
    
    func detail(_ id: Int) {
        let coordinator = FoodViewCoordinator(navigationController: navigationController, id: id)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func goToLogin() {
        parentCoordinator?.goToLogin()
    }
}
