import SwiftUI

/// The app's main entry point.
@main
struct DeviceCheckDemoApp: App {
    
    /// The app's main application delegate to handle app-lifecycle events.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
