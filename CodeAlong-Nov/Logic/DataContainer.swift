//
//  DataContainer.swift
//  CodeAlong-Nov
//
//  Created by putragandadewata on 15/11/25.
//

import SwiftData
import SwiftUI

@Observable // make this datacontainer observable for SwiftUI
@MainActor // ensure in main thread for UI updates
class DataContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(includeSampleMoments: Bool = false) {
        let schema = Schema([
            Moment.self,
        ])

        // isStoredInMemory only when set to true, the data is not persist, good for testing
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: includeSampleMoments)

        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

            if(includeSampleMoments) {
                loadSampleMoments() // load sample data for testing
            }
            
            try context.save()
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    private func loadSampleMoments() {
        for moment in Moment.sampleData {
            context.insert(moment)
        }
    }
}

private let sampleContainer = DataContainer(includeSampleMoments: true)

// extension of "View" from SwiftUI
extension View {
    /*
     instead of calling .modelContainer(DataContainer(includeSampleMoments: true).modelContainer) everytime
     we can just use .sampleDataContainer() by using this extension
     */
    func sampleDataContainer() -> some View {
        self
            .environment(sampleContainer)
            .modelContainer(sampleContainer.modelContainer)
    }
}
