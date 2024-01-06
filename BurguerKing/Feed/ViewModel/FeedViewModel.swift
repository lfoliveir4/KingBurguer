import Foundation

protocol FeedViewModelDelegate {
    func viewModelDidChange(state: FeedState)
}

final class FeedViewModel {
    var delegate: FeedViewModelDelegate?
    var coordinator: FeedCoordinator?
    
    var state: FeedState = .loading {
        didSet {
            delegate?.viewModelDidChange(state: state)
        }
    }
    
    private let interactor: FeedInteractor
    
    init(interactor: FeedInteractor) {
        self.interactor = interactor
    }
    
    func fetch() {
        interactor.fetch { response, error in
            DispatchQueue.main.async {
                if let error {
                    self.state = .error(error)
                } else if let response {
                    print("RESS \(response)")
                    self.state = .success(response)
                }
            }
        }
    }
    
    func fetchHighlight() {
        interactor.fetch { response, error in
            DispatchQueue.main.async {
                if let error {
                    self.state = .error(error)
                } else if let response {
                    self.state = .successHighlight(response)
                }
            }
        }
    }
    
    func goToProductDetail(_ id: Int) {
        coordinator?.detail(id)
    }
    
    func logout() {
        interactor.logout()
        coordinator?.goToLogin()
    }
}
