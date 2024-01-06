enum ProfileState: Equatable {
    static func == (lhs: ProfileState, rhs: ProfileState) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        default:
            return false
        }
    }
    
    case loading
    case success(ProfileResponse)
    case error(String)
}
