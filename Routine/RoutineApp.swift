//

import SwiftUI

@main
struct RoutineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TodayView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
