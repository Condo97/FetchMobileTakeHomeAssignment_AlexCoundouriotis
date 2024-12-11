//
//  RecipeMiniView.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI

struct RecipeMiniView: View {
    
    /**
     Recipe Mini View
     
     A mini display of a recipe for use in lists.
     
     Parameters
     - recipe: Recipe - The recipe to display
     - imageSize: CGSize - The size to display the image
     */
    
    @ObservedObject var recipe: Recipe
    let imageSize: CGSize
    
    @Environment(\.openURL) private var openUrlAction
    
    var body: some View {
        HStack(spacing: 16.0) {
            // Image
            Group {
                if let photo = recipe.cachedSmallImage ?? recipe.cachedLargeImage { // Default to small photoURL, otherwise use large
                    // Image display
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Colors.text)
                } else {
                    // Fallback to loading image display if no image
                    ZStack {
                        Colors.background
                        ProgressView()
                    }
                }
            }
            .frame(width: imageSize.width, height: imageSize.height)
            .clipShape(RoundedRectangle(cornerRadius: 14.0))
            
            // Abbreivated Recipe information
            VStack(alignment: .leading) {
                if let name = recipe.name {
                    // Name of recipe
                    Text(name)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                }
                
                if let cuisine = recipe.cuisine {
                    // Cuisine of recipe
                    Text(cuisine)
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                
                HStack(spacing: 16.0) {
                    if let sourceUrl = recipe.sourceUrl {
                        // Button that links to source URL
                        Button(action: {
                            openUrlAction(sourceUrl)
                        }) {
                            VStack(spacing: 2.0) {
                                Image(systemName: "safari")
                                    .font(.system(size: 20.0))
                                Text("Source")
                                    .font(.system(size: 9.0, weight: .bold))
                            }
                            .foregroundStyle(Color(.systemBlue))
                            .frame(maxHeight: .infinity, alignment: .bottom)
                        }
                    }
                    
                    if let youTubeUrl = recipe.youTubeUrl {
                        // Button that links to YouTube URL
                        Button(action: {
                            openUrlAction(youTubeUrl)
                        }) {
                            VStack(spacing: 2.0) {
                                Image(systemName: "play.rectangle")
                                    .font(.system(size: 20.0))
                                Text("YouTube")
                                    .font(.system(size: 9.0, weight: .bold))
                            }
                            .foregroundStyle(Color(.systemRed))
                            .frame(maxHeight: .infinity, alignment: .bottom)
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true) // Combine with .frame(maxHeight: .infinity) for equal button size
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
}

@available(iOS 17, *) // Because of the previewable state
#Preview {
    
    @Previewable @State var recipe: Recipe?
    
    ZStack {
        if let recipe {
            RecipeMiniView(
                recipe: recipe,
                imageSize: CGSize(width: 100.0, height: 100.0))
        }
    }
    .environment(\.managedObjectContext, CoreDataClient.mainManagedObjectContext)
    .task {
        if let firstRecipe = try! CoreDataClient.mainManagedObjectContext.fetch(Recipe.fetchRequest()).first {
            recipe = firstRecipe
        } else {
            recipe = try! await RecipePersistence.saveRecipe(
                uuid: "uuid",
                cuisine: "cuisine",
                name: "name",
                photoUrlLarge: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")!,
                photoUrlSmall: URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")!,
                sourceUrl: URL(string: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")!,
                youTubeURL: URL(string: "https://www.youtube.com/watch?v=6R8ffRRJcrg")!,
                in: CoreDataClient.mainManagedObjectContext)
        }
    }
    
}
