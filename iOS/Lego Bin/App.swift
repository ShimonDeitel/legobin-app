import SwiftUI

@main
struct LegoBinApp: App {
    @StateObject private var store = Store()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .onChange(of: purchases.isPro) { oldValue, newValue in
                    store.isPro = newValue
                }
        }
    }
}
