import Testing
@testable import PhotosFeature

@MainActor
@Test func viewModelStartsIdle() {
    let vm = PhotosViewModel()
    guard case .idle = vm.state else {
        Issue.record("Initial state should be .idle")
        return
    }
}
