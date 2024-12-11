//
//  RecipeMiniButtonList.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/11/24.
//

import SwiftUI

struct RecipeMiniButtonList: View {
    
    @FetchRequest var recipes: FetchedResults<Recipe>
    @Binding var isLoading: Bool
    let onTap: (Recipe) -> Void
    
    @State private var imageSize: CGSize = CGSize(width: 100.0, height: 100.0) // Image size
    
    var body: some View {
        // Recipe List
        VStack {
            // No recipes indicator
            if recipes.count == 0 && isLoading {
                // Show loading view if no recipes and isLoading
                LoadingView()
                    .frame(height: 250.0)
                    .frame(maxWidth: .infinity)
            } else if recipes.count == 0 {
                // Show recipes if not loading
                VStack {
                    Text("No Recipes")
                        .font(.system(size: 17.0, weight: .bold))
                    Text("Please enter a valid link and submit.")
                        .font(.system(size: 12.0))
                }
                .padding()
                .frame(maxWidth: .infinity)
            } else {
                // Recipe list
                ForEach(recipes, id: \.self) { recipe in
                    RecipeMiniButton(
                        recipe: recipe,
                        imageSize: imageSize,
                        onTap: {
                            onTap(recipe)
                        })
                    .padding()
                    .foregroundStyle(Colors.text)
                    .background(Colors.foreground)
                    .clipShape(RoundedRectangle(cornerRadius: 14.0))
                }
            }
        }
        
    }
}

#Preview {
    
    RecipeMiniButtonList(
        recipes: FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Recipe.dateAdded, ascending: false)]),
        isLoading: .constant(true),
        onTap: { recipe in
            
        }
    )
    
}
