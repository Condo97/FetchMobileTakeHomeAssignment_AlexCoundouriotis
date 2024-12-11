//
//  MaximizedImageView.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI

struct MaximizedImageView: View {
    
    /**
     Maximized Image View
     
     Shows an enlarged large image with a swipe to dismiss gesture.
     
     Parameters
     - model: Model - The model with the image to display
     - isPresented: Binding<Bool> - Binding to source of truth for presentation and dismissal
     */
    
    let model: Model
    let onDismiss: () -> Void
    
    /**
     Model
     
     The model containing the image to display.
     
     Parameters
     - image: UIImage - The image to display
     */
    struct Model: Identifiable {
        var id: Int {
            image.hashValue
        }
        
        var image: UIImage
    }
    
    @State private var dismissOffset: CGFloat = 80.0 // The offset magnitude to dismiss
    
    @State private var dragOffset: CGSize = .zero // Keep track of drag offset
    
    var body: some View {
        VStack {
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 14.0))
                .offset(dragOffset) // Show the drag
                .zIndex(1) // Remain in front of close button when dragging
                .simultaneousGesture(
                    DragGesture()
                        .onChanged({value in
                            // Update dragOffset with value translation
                            dragOffset = value.translation
                        })
                        .onEnded({value in
                            // If uesr has dragged the image with a greater magnitude than dismissOffset dismiss
                            if abs(dragOffset.height) > dismissOffset || abs(dragOffset.width) > dismissOffset {
                                withAnimation {
                                    onDismiss()
                                }
                            }
                            
                            // Reset dragOffset
                            withAnimation {
                                dragOffset = .zero
                            }
                        })
                )
            
            // Close button
            Button("Close", action: onDismiss)
                .fontWeight(.bold)
                .padding()
        }
    }
    
}

#Preview {
    
    MaximizedImageView(
        model: MaximizedImageView.Model(image: UIImage(systemName: "checkmark")!),
        onDismiss: {
            
        })
    
}
