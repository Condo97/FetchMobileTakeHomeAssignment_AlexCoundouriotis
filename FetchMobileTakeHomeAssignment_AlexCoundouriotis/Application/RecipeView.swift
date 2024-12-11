//
//  RecipeView.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI
import CoreData

struct RecipeView: View {
    
    // TODO: Add sorting
    
    /**
     Recipe View
     
     Allows for the query of a Recipe JSON URL and displays recipes.
     */
    
    // Managed Object Context environment variable
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var recipeDetailViewRecipe: Recipe? // When set, show recipe detail view
    
    @State private var isLoading: Bool = false // Loading flag
    
    @State private var setURLText: String = ""
    
    @State private var selectedSortItem = SortedRecipeMiniButtonList.SortItem(method: .dateAdded, order: .desc)
    
    @State private var alertShowingNoRecipesReceived: Bool = false     // Alert to show if response was decoded but no recipes were found
    @State private var alertShowingLoadRecipesError: Bool = false      // Alert to show if recipes have an error when loading
    @State private var alertShowingRecipeJSONParseError: Bool = false  // Alert to show if the recipes JSON data was malformed
    @State private var alertShowingInvalidURL: Bool = false            // Alert to show if the URL is invalid
    
    // Binding to puppet recipe detail view because navigationDestination item is not available till iOS 17 and Fetch uses iOS 16 :)
    private var isPresentingRecipeDetailView: Binding<Bool> {
        Binding(
            get: {
                recipeDetailViewRecipe != nil
            },
            set: { value in
                if !value {
                    recipeDetailViewRecipe = nil
                }
            })
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        // Set Recipe Button
                        SetRecipeView(
                            urlText: $setURLText,
                            isLoading: $isLoading,
                            onAdd: {
                                // Load recipes
                                Task {
                                    await loadRecipes()
                                }
                            },
                            onDelete: {
                                Task {
                                    // Delete all recipes
                                    do {
                                        try await RecipePersistence.deleteAll(in: viewContext)
                                    } catch {
                                        print("Error deleting all recipes in RecipeView... \(error)")
                                    }
                                }
                            })
                        .padding(.bottom)
                        
                        // Sort button
                        Menu {
                            ForEach(SortedRecipeMiniButtonList.SortMethods.allCases, id: \.self) { sortMethod in
                                ForEach(SortedRecipeMiniButtonList.SortOrders.allCases, id: \.self) { sortOrder in
                                    HStack {
                                        Button(action: {
                                            selectedSortItem = SortedRecipeMiniButtonList.SortItem(method: sortMethod, order: sortOrder)
                                        }) {
                                            Text("\(sortMethod.displayString)\t\t\(sortOrder == .asc ? "▲" : "▼")")
                                        }
                                    }
                                    .padding()
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedSortItem.method.displayString)
                                    .bold()
                                VStack {
                                    Image(systemName: selectedSortItem.order == .asc ? "triangle.fill" : "triangle")
                                        .font(.system(size: 6.0))
                                    Image(systemName: selectedSortItem.order == .asc ? "triangle" : "triangle.fill")
                                        .font(.system(size: 6.0))
                                        .rotationEffect(.degrees(180))
                                }
                            }
                            .font(.system(size: 14.0))
                            .foregroundStyle(Colors.buttonBackground)
                        }
                        
                        // Recipes list
                        SortedRecipeMiniButtonList(
                            isLoading: $isLoading,
                            selectedSortItem: $selectedSortItem,
                            onTap: { recipe in
                                recipeDetailViewRecipe = recipe
                            })
                    }
                    .padding(.horizontal) // Padding here in VStack to push scorll indicator to device width
                }
                .background(Colors.background)
                .navigationDestination(isPresented: isPresentingRecipeDetailView) {
                    if let recipeDetailViewRecipe {
                        RecipeDetailView(recipe: recipeDetailViewRecipe)
                    } else {
                        Button("Close") {
                            isPresentingRecipeDetailView.wrappedValue = false
                        }
                    }
                }
            }
        }
        .alert("No Recipes", isPresented: $alertShowingNoRecipesReceived, actions: {
            Button("Close") {}
        }) {
            Text("The response was decoded but contained no recipes. Please check the URL and try again.")
        }
        // Alert for general loading error
        .alert("Error Loading", isPresented: $alertShowingLoadRecipesError, actions: {
            Button("Close") {}
        }) {
            Text("There was an error loading the recipes. Please check your internet connection or the URL and try again.")
        }
        // Alert for error parsing JSON
        .alert("Error Parsing JSON", isPresented: $alertShowingRecipeJSONParseError, actions: {
            Button("Close") {}
        }) {
            Text("There was an error parsing the recipes JSON. Please check the URL and try again.")
        }
        // Alert for invalid URL
        .alert("Invalid URL", isPresented: $alertShowingInvalidURL, actions: {
            Button("Close") {}
        }) {
            Text("The input is not a valid URL. Please double check and try again.")
        }
    }
    
    /**
     Load Recipes
     
     Loads recipes into CoreData by merge.
     */
    func loadRecipes() async {
        defer { DispatchQueue.main.async { withAnimation { isLoading = false } } } // Defer setting isLoading to false
        await MainActor.run { withAnimation { isLoading = true } } // Set isLoading to true
        
        // Ensure url components can be unwrapped otherwise show invalid URL alert and return
        guard var urlComponents = URLComponents(string: setURLText) else {
            await MainActor.run { alertShowingInvalidURL = true }
            return
        }
        
        // Check scheme and set to https if not included
        if urlComponents.scheme == nil {
            urlComponents.scheme = "https"
        }
        
        // Ensure url can be unwrapped from components otherwise show invalid URL alert and return
        guard let url = urlComponents.url else {
            await MainActor.run { alertShowingInvalidURL = true }
            return
        }
        
        // Load recipes, catch show load recipes alert and retur
        let getRecipesResponse: GetRecipesResponse
        do {
            getRecipesResponse = try await RecipeDownloader.downloadRecipes(from: url)
        } catch Swift.DecodingError.keyNotFound( _, _) {
            await MainActor.run { alertShowingRecipeJSONParseError = true }
            return
        } catch {
            await MainActor.run { alertShowingLoadRecipesError = true }
            return
        }
        
        // If getRecipesResponse contains no recipes show alert and return
        if getRecipesResponse.recipes.isEmpty {
            await MainActor.run { alertShowingNoRecipesReceived = true }
        }
        
        // Cache images and save recipes concurrently
        await withTaskGroup(of: Void.self) { taskGroup in
            for recipe in getRecipesResponse.recipes {
                taskGroup.addTask {
                    do {
                        // Try updating recipe and caching its images
                        try await GetRecipesResponseImageCacheRecipePersistence.updateRecipeByUUID(recipe: recipe, in: viewContext)
                    } catch RecipePersistenceError.nonexistantRecipe {
                        // Save recipe and cache images
                        do {
                            try await GetRecipesResponseImageCacheRecipePersistence.saveRecipe(recipe, in: viewContext)
                        } catch {
                            print("Error saving recipe in ContentView, continuing... \(error)")
                        }
                    } catch {
                        print("Error updating recipe in ContentView, continuing... \(error)")
                    }
                }
            }
            
            await taskGroup.waitForAll()
        }
    }
    
}

#Preview {
    
    RecipeView()
        .environment(\.managedObjectContext, CoreDataClient.mainManagedObjectContext)
    
}
