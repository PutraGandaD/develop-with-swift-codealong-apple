//
//  MomentDetailView.swift
//  CodeAlong-Nov
//
//  Created by putragandadewata on 20/11/25.
//

import SwiftUI
import SwiftData

struct MomentDetailView: View {
    // public var that need to be initialized when using this struct
    var moment: Moment
    
    // Accessing app environment to access SwiftData
    @Environment(DataContainer.self) private var dataContainer
    
    // Accessing SwiftUI environment for "dismiss" state in this layout/view
    @Environment(\.dismiss) private var dismiss
    
    @State private var isShowingDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            contentStack
        }
        .navigationTitle(moment.title)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button("Delete", systemImage: "trash") {
                    isShowingDeleteConfirmation = true
                }
                .confirmationDialog("Delete Moment", isPresented: $isShowingDeleteConfirmation) {
                    Button("Delete Moment", role: .destructive) {
                        dataContainer.context.delete(moment)
                        try? dataContainer.context.save()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var contentStack: some View {
        VStack(alignment: .leading) {
            // load timestamp into date format
            Text(moment.timestamp, style: .date)
                .font(.subheadline)
            
            // load moment note/desc
            if (!moment.note.isEmpty) {
                Text(moment.note)
                    .font(.title2)
                    .textSelection(.enabled)
            }

            // load image, properly unwrap optional
            if let image = moment.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        // property for VStack
        .frame(
            maxWidth: .infinity,
            alignment: .leading)
        .padding()
    }
}

#Preview {
    NavigationStack {
        MomentDetailView(moment: .imageSample)
            .sampleDataContainer()
    }
}
