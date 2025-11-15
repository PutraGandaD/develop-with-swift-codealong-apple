//
//  MomentEntryView.swift
//  CodeAlong-Nov
//
//  Created by putragandadewata on 15/11/25.
//

import SwiftUI
import PhotosUI
import SwiftData

struct MomentEntryView: View {
    @State private var title = ""
    @State private var note = ""
    
    // State for selected image in "Data" format
    @State private var imageData: Data?
    
    // State for image picked from PhotosPicker
    @State private var newImage: PhotosPickerItem?
    
    @State private var isShowingCancelConfirmation = false
    
    // Accessing SwiftUI environment for "dismiss" state in this layout/view
    @Environment(\.dismiss) private var dismiss
    
    // Accessing app environment to access SwiftData
    @Environment(DataContainer.self) private var dataContainer
    
    var body: some View {
        NavigationStack {
            ScrollView {
                contentStack
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Grateful For")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", systemImage: "xmark") {
                        isShowingCancelConfirmation = true
                    }
                    .confirmationDialog("Discard Moment", isPresented: $isShowingCancelConfirmation) {
                        Button("Discard Moment", role: .destructive) {
                            if title.isEmpty, note.isEmpty, imageData == nil {
                                dismiss()
                            } else {
                                isShowingCancelConfirmation = true
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add", systemImage: "checkmark") {
                        // create a Moment data when user tap add
                        let newMoment = Moment(
                            title: title,
                            note: note,
                            imageData: imageData,
                            timestamp: .now
                        )
                        dataContainer.context.insert(newMoment)
                        do {
                            try dataContainer.context.save()
                            dismiss()
                        } catch {
                            // dont dismiss when error
                        }
                    }
                }
            }
            .disabled(title.isEmpty)
        }
    }
    
    private var photoPicker: some View {
        PhotosPicker(selection: $newImage) {
            // using group the apply the rounded clipshape to all the views
            Group {
                if let imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "photo.badge.plus.fill")
                        .font(.largeTitle) // image size
                        .frame(height: 250)
                        .frame(maxWidth: .infinity) // match_parent
                        .background(Color(white: 0.4, opacity: 0.32))
                }
            }
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .onChange(of: newImage) {
            guard let newImage else { return }
            // asynchronous task
            Task {
                imageData = try await newImage.loadTransferable(type: Data.self)
            }
        }
    }
    
    var contentStack: some View {
        VStack(alignment: .leading) {
            TextField(text: $title) {
                Text("Title (Required)")
            }
            .font(.title.bold())
            .padding(.top, 30)
            Divider()
            
            TextField("Log your small wins", text: $note, axis: .vertical)
                .multilineTextAlignment(.leading)
                .lineLimit(5...Int.max)
            
            photoPicker
        }
        .padding()
    }
}

#Preview {
    MomentEntryView()
        .sampleDataContainer()
}
