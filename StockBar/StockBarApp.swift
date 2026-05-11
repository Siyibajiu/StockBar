import SwiftUI

@main
struct StockBarApp: App {
    @State private var viewModel = StockViewModel()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(viewModel: viewModel)
        } label: {
            Image(systemName: "calendar")
        }
        .menuBarExtraStyle(.window)
    }
}
