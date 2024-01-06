import UIKit

final class HomeCoordinator {
    private let window: UIWindow?
    let homeNavigationController = UINavigationController()
    let profileNavigationController = UINavigationController()
    
    private var signInCoordinator: SignInCoordinator?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let homeViewController = HomeViewController()
        let profileViewController = ProfileViewController(style: .plain)
        
        let feedCoordinator = FeedCoordinator(navigationController: homeNavigationController)
        feedCoordinator.parentCoordinator = self
        feedCoordinator.start()
        
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator.start()
        
        
        homeViewController.setViewControllers([
            homeNavigationController,
            profileNavigationController
        ], animated: true)
        
        window?.rootViewController = homeViewController
    }
    
    func goToLogin() {
        signInCoordinator = SignInCoordinator(window: window)
        signInCoordinator?.start()
    }
}
