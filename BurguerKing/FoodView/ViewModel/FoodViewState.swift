enum FoodViewState {
    case loading
    case success(FoodViewResponse)
    case successCoupon(CouponResponse)
    case error(String)
}
