//
//  RecipeDetailView.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI

struct RecipeDetailView: View {
    
    /**
     Recipe Detail View
     
     Shows the details of a recipe.
     
     Parameters:
     - recipe: Recipe - The CoreData entity Recipe to get the details of
     */
    
    let recipe: Recipe
    
    @Environment(\.openURL) private var openURL // Allows url tap
    
    @State private var maximizedImageViewModel: MaximizedImageView.Model? // The maximized image model to show
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8.0) {
                // Image in a button that triggers the full screen image view on tap
                Button(action: {
                    if let image = recipe.cachedLargeImage ?? recipe.cachedSmallImage {
                        maximizedImageViewModel = MaximizedImageView.Model(image: image)
                    }
                }) {
                    Group {
                        if let image = recipe.cachedLargeImage ?? recipe.cachedSmallImage {
                            Image(uiImage: image)
                                .resizable()
                        } else {
                            Text("No Image")
                                .font(.headline)
                                .opacity(0.6)
                        }
                    }
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 14.0))
                }
                
                // Detail rows
                detailRow(for: "Name", value: recipe.name)
                detailRow(for: "Cuisine", value: recipe.cuisine)
                detailRow(for: "Source URL", value: recipe.sourceUrl)
                detailRow(for: "YouTube URL", value: recipe.youTubeUrl)
                detailRow(for: "UUID", value: recipe.uuid)
                detailRow(for: "Photo URL Small", value: recipe.photoUrlSmall)
                detailRow(for: "Photo URL Large", value: recipe.photoUrlLarge)
            }
            .padding()
        }
        .background(Colors.background)
        .navigationTitle(recipe.name ?? "Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .clearFullScreenCover(item: $maximizedImageViewModel, content: { model in
            MaximizedImageView(
                model: model,
                onDismiss: {
                    maximizedImageViewModel = nil
                })
        })
    }
    
    /**
     Detail Row
     
     A detail row that shows the row name and URL content allows for opening the URL on tap
     
     Parameters
     - rowName: String - The display name of the row
     - value: URL? - The URL to display which allows opening on tap
     */
    func detailRow(for rowName: String, value: URL?) -> some View {
        VStack {
            Button(action: {
                if let value {
                    openURL(value)
                }
            }) {
                detailRow(for: rowName, value: value?.absoluteString)
            }
        }
    }
    
    /**
     Detail row
     
     A detail row that shows the row name and content
     
     Parameters
     - rowName: String - The display name of the row
     - value: String? - The string to display as the value
     */
    func detailRow(for rowName: String, value: String?) -> some View {
        VStack(alignment: .leading) {
            if let value {
                Text("\(rowName)")
                    .font(.system(size: 11, weight: .bold))
                    .opacity(0.6)
                Text(value)
                    .font(.system(size: 17))
                    .multilineTextAlignment(.leading)
            } else {
                Text("No \(rowName)")
                    .font(.system(size: 17))
                    .italic()
                    .opacity(0.6)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(Colors.text)
        .background(Colors.foreground)
        .clipShape(RoundedRectangle(cornerRadius: 14.0))
        .contextMenu { // Context menu for copying
            Button("Copy", systemImage: "doc.on.doc") {
                if let value {
                    UIPasteboard.general.string = value
                }
            }
        }
    }
    
}

@available(iOS 17, *) // Because of the previewable state
#Preview {
    
    @Previewable @State var recipe: Recipe?
    
    ZStack {
        if let recipe {
            RecipeDetailView(recipe: recipe)
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
