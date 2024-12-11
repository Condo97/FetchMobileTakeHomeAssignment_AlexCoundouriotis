//
//  RecipeMiniButton.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI

struct RecipeMiniButton: View {
    
    /**
     Recipe Mini Button
     
     A button version of RecipeMiniView.
     
     Parameters
     - recipe: Recipe - The recipe to show
     - imageSize: CGSize - The size to show the image
     - onTap: () -> Void - Action called on tap of button
     */
    
    let recipe: Recipe
    let imageSize: CGSize
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                // Recipe mini view
                RecipeMiniView(
                    recipe: recipe,
                    imageSize: imageSize)
                
                // Detail disclosure
                Image(systemName: "chevron.right")
            }
        }
    }
    
}

@available(iOS 17, *) // Because of the previewable state
#Preview {
    
    @Previewable @State var recipe: Recipe?
    
    ZStack {
        if let recipe {
            RecipeMiniButton(
                recipe: recipe,
                imageSize: CGSize(width: 100.0, height: 100.0),
                onTap: {
                    
                })
        }
    }
    .environment(\.managedObjectContext, CoreDataClient.mainManagedObjectContext)
    .task {
        if let firstRecipe = try! CoreDataClient.mainManagedObjectContext.fetch(Recipe.fetchRequest()).first {
            recipe = firstRecipe
        } else {
            recipe = try! await RecipePersistence.saveRecipe(
                uuid: "uuid",
                cuisine: "yummy",
                name: "name",
                photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
                photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
                sourceUrl: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
                youTubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!,
                in: CoreDataClient.mainManagedObjectContext)
        }
    }
    
}
