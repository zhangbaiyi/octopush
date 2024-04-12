import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(){
                    tidyCatalystWindow()
                }
        }
    }
}

func tidyCatalystWindow() {
    #if targetEnvironment(macCatalyst)
    UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
     .forEach { ws in
        ws.sizeRestrictions?.minimumSize = CGSize(width: 800, height:1200)
        ws.sizeRestrictions?.maximumSize = CGSize(width: 1000, height: 1500)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            ws.sizeRestrictions?.maximumSize = CGSize(width: 9000, height: 9000)
        }
    }
    #endif
}
