//
//  CodeAlong_NovApp.swift
//  CodeAlong-Nov
//
//  Created by putragandadewata on 15/11/25.
//

import SwiftUI
import SwiftData

@main
struct CodeAlong_NovApp: App {
    let dataContainer = DataContainer()
    
    var body: some Scene {
        WindowGroup {
            MomentEntryView()
                .environment(dataContainer)
        }
        .modelContainer(dataContainer.modelContainer)
    }
}
