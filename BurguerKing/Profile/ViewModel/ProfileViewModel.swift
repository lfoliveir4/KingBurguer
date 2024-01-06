protocol ProfileViewModelDelegate {
    func viewModelDidChanged(state: ProfileState)
}

final class ProfileViewModel {
    var delegate: ProfileViewModelDelegate?
    var coordinator: ProfileCoordinator?
    
    var state: ProfileState = .loading {
        didSet {
            delegate?.viewModelDidChanged(state: state)
        }
    }
    
    private let interactor: ProfileInteractor
    
    init(interactor: ProfileInteractor) {
        self.interactor = interactor
    }
    
    func fetch() {
        interactor.fetch() { response, error in
            if let error {
                self.state = .error(error)
            }
            
            if let response {
                self.state = .success(response)
            }
        }
    }
}
