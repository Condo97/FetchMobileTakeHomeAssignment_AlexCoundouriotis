//
//  SetRecipeView.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI

struct SetRecipeView: View {
    
    /**
     Set Recipe View
     
     Takes user entry of a URL and calls a closure on its submit button tap.
     
     Parameters
     - urlText: Binding<String> - Binding to the text input
     - isLoading: Binding<Bool> - Binding to the loading state
     */
    
    @Binding var urlText: String
    @Binding var isLoading: Bool
    let onAdd: () -> Void
    let onDelete: () -> Void
    
    @FetchRequest(sortDescriptors: []) private var recipes: FetchedResults<Recipe>
    
    @FocusState private var urlTextFocus // Focus state for text field to handle keyboard dismiss on return and button press
    
    @State private var alertShowingConfirmDeletion: Bool = false
    
    var body: some View {
        HStack {
//            let _ = Self._printChanges()
            VStack(alignment: .leading) {
                // Title
                Text("Import Recipes")
                    .font(.system(size: 24.0, weight: .bold))
                
                // Text input field
                HStack {
                    TextField("Enter URL...", text: $urlText)
                        .focused($urlTextFocus)
                        .frame(maxHeight: .infinity)
                    
                    if !urlText.isEmpty {
                        // Show easy delete button if not empty
                        Button(action: {
                            // Set urlTextFocus to false to dismiss keyboard
                            urlTextFocus = false
                            
                            // Clear urlText
                            urlText = ""
                        }) {
                            Image(systemName:"xmark")
                                .font(.system(size: 12.0))
                                .opacity(0.6)
                        }
                        .frame(maxHeight: .infinity)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                
                // Underline
                Capsule()
                    .frame(height: 1.0)
                    .opacity(0.6)
                
                // For your convenience :)
                HStack {
                    convenienceURLSelectionButton(targetUrlString: Constants.completeJSONURLString, systemImage: "checkmark")
                    convenienceURLSelectionButton(targetUrlString: Constants.incompleteJSONURLString, systemImage: "exclamationmark.triangle")
                    convenienceURLSelectionButton(targetUrlString: Constants.emptyJSONURLString, systemImage: "square")
                }
                .disabled(isLoading)
                .opacity(isLoading ? 0.6 : 1.0)
                .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    // Add button
                    Button(action: {
                        // Set focus to false to dismiss keyboard
                        urlTextFocus = false
                        
                        // Call onAdd closure
                        onAdd()
                    }) {
                        HStack {
                            Text("Add Recipes")
                                .font(.system(size: 14.0, weight: .bold))
                            if isLoading {
                                // Show progress view if loading
                                ProgressView()
                                    .tint(.white)
                            } else {
                                // Otherwise show submit symbol
                                Image(systemName: "plus")
                                    .font(.system(size: 14.0))
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(Colors.buttonText)
                        .background(Colors.buttonBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14.0))
                    }
                    .disabled(isLoading || urlText.isEmpty)
                    .opacity(isLoading || urlText.isEmpty ? 0.6 : 1.0)
                    
                    // Delete button
                    Button(action: {
                        // Set focus to false to dismiss keyboard
                        urlTextFocus = false
                        
                        // Show delete confirmation alert
                        alertShowingConfirmDeletion = true
                    }) {
                        VStack {
                            HStack {
                                Text(Image(systemName: "trash"))
                                    .font(.system(size: 14.0, weight: .bold))
                            }
                        }
                        .padding()
                        .foregroundStyle(Colors.buttonBackground)
                        .frame(maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 14.0)
                            .stroke(Colors.buttonBackground, lineWidth: 2.0))
                    }
                    .disabled(isLoading || recipes.isEmpty)
                    .opacity(isLoading || recipes.isEmpty ? 0.6 : 1.0)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top)
            }
            .font(.system(size: 14.0))
        }
        .alert("Delete Recipes", isPresented: $alertShowingConfirmDeletion, actions: {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) {}
        }) {
            Text("Are you sure you want to delete all recipes?")
        }
    }
    
    func convenienceURLSelectionButton(targetUrlString: String, systemImage: String) -> some View {
        Button(action: {
            urlText = targetUrlString
        }) {
            Image(systemName: systemImage)
                .foregroundStyle(urlText == targetUrlString ? Colors.buttonText : Colors.buttonBackground)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .frame(maxHeight: .infinity)
                .background(ZStack {
                    if urlText == targetUrlString {
                        Capsule()
                            .fill(Colors.buttonBackground)
                    } else {
                        Capsule()
                            .stroke(Colors.buttonBackground, lineWidth: 2.0)
                    }
                })
                .clipShape(Capsule())
        }
    }
    
}

#Preview {
    
    SetRecipeView(
        urlText: .constant("https://apple.com/"),
        isLoading: .constant(true),
        onAdd: {
            
        },
        onDelete: {
            
        })
    
}
