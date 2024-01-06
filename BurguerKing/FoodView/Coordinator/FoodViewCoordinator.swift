import UIKit

final class FoodViewCoordinator {
    private let navigationController: UINavigationController
    private let id: Int
    var parentCoordinator: FeedCoordinator?
    
    init(navigationController: UINavigationController, id: Int) {
        self.navigationController = navigationController
        self.id = id
    }
    
    func start() {
        let interactor = FoodViewInteractor()
        let couponInteractor = CouponInteractor()
        let viewModel = FoodViewViewModel(
            interactor: interactor,
            couponInteractor: couponInteractor
        )
        viewModel.coordinator = self
        
        let viewController = FoodViewViewController()
        viewController.id = id
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
