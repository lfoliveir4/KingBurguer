import UIKit

final class HomeViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let feedInteractor = FeedInteractor()
        let feedViewModel = FeedViewModel(interactor: feedInteractor)
        let feedViewController = FeedViewController()
        feedViewController.viewModel = feedViewModel
        tabBar.tintColor = .red
    }
}

#Preview {
    HomeViewController()
}
