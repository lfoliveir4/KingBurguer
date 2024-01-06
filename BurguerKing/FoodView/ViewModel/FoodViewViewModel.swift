protocol FoodViewViewModelDelegate {
    func viewModelDidChange(state: FoodViewState)
}

final class FoodViewViewModel {
    var delegate: FoodViewViewModelDelegate?
    var coordinator: FoodViewCoordinator?
    
    var state: FoodViewState = .loading {
        didSet {
            delegate?.viewModelDidChange(state: state)
        }
    }
    
    private let interactor: FoodViewInteractor
    private let couponInteractor: CouponInteractor
    
    init(
        interactor: FoodViewInteractor,
        couponInteractor: CouponInteractor
    ) {
        self.interactor = interactor
        self.couponInteractor = couponInteractor
    }
    
    func fetch(id: Int) {
        interactor.fetch(id: id) { response, error in
            if let error {
                self.state = .error(error)
            }
            
            if let response {
                self.state = .success(response)
            }
        }
    }
    
    func createCoupon(id: Int) {
        couponInteractor.create(id: id) { response, error in
            if let error {
                self.state = .error(error)
            }
            
            if let response {
                self.state = .successCoupon(response)
            }
        }
    }
}
