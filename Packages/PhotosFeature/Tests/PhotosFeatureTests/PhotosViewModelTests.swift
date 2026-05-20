import Testing
import Foundation
import PhotosNetworking
@testable import PhotosFeature

@MainActor
@Test func viewModelStartsIdle() {
    let vm = PhotosViewModel()
    guard case .idle = vm.state else {
        Issue.record("Initial state should be .idle")
        return
    }
}

@MainActor
@Test func cancellationDoesNotEnterFailedState() async {
    let service = PhotoService(
        session: .stubbed,
        endpoint: URL(string: "https://stub.local/cancelled")!
    )
    let vm = PhotosViewModel(service: service)

    await vm.load()

    guard case .idle = vm.state else {
        Issue.record("Cancellation should restore the prior state, got \(vm.state)")
        return
    }
}

@MainActor
@Test func networkErrorEntersFailedState() async {
    let service = PhotoService(
        session: .stubbed,
        endpoint: URL(string: "https://stub.local/timeout")!
    )
    let vm = PhotosViewModel(service: service)

    await vm.load()

    guard case .failed = vm.state else {
        Issue.record("A real network error should enter .failed, got \(vm.state)")
        return
    }
}
