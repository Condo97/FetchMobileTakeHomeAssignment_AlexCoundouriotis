//
//  ImageCacheRecipePersistence.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/11/24.
//

import CoreData
import Foundation

class ImageCacheRecipePersistence {
    
    /**
     Update Recipe
     
     Updates a Recipe by recaching images if URL changed and updating entity in CoreData by UUID.
     
     Parameters
     - uuid: String - The UUID to identify the recipe to update by
     - cuisine: String?- The updated cuisine
     - name: String?- The updated name
     - photoUrlLarge: URL? - The updated url of the large photo
     - photoUrlSmall: URL? - Theupdated  url of the small photo
     - sourceUrl: URL? - The updated url of the source
     - youTubeUrl: URL? - The updated YouTube url
     - managedContext: NSManagedObjectContext - The managed object context to update  the recipe in
     */
    static func updateRecipe(
        byUUID uuid: String,
        cuisine: String?,
        name: String?,
        photoUrlLarge: URL?,
        photoUrlSmall: URL?,
        sourceUrl: URL?,
        youTubeURL: URL?,
        in managedContext: NSManagedObjectContext
    ) async throws {
        // Fetch recipe for UUID
        let recipeFetchRequest = Recipe.fetchRequest()
        recipeFetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(Recipe.uuid), uuid)
        let recipes = try await managedContext.perform { try managedContext.fetch(recipeFetchRequest) }
        
        // Ensure unwrap first recipe, otherwise throw nonexistantRecipe
        guard let recipe = recipes.first else {
            throw RecipePersistenceError.nonexistantRecipe
        }
        
        // If reicpe has cache and new small image URL is different than existing small image URL recache small image
        if recipe.photoUrlSmall != photoUrlSmall,
           let photoUrlSmall {
            // Delte previous data
            do {
                try await ImageCache.deleteSmallImageData(uuid: uuid)
            } catch {
                print("Error deleting small image in ImageCacheRecipePersistence, continuing... \(error)")
            }
            
            // Cache new data
            do {
                try await ImageCache.cacheSmallImage(url: photoUrlSmall, uuid: uuid)
            } catch {
                print("Error caching small image in ImageCacheRecipePersistence, continuing... \(error)")
            }
        }
        
        // If reicpe has cache and new large image URL is different than existing large image URL recache small image
        if recipe.photoUrlLarge != photoUrlLarge,
           let photoUrlLarge {
            // Delete previous data
            do {
                try await ImageCache.deleteLargeImageData(uuid: uuid)
            } catch {
                print("Error deleting small image in ImageCacheRecipePersistence, continuing... \(error)")
            }
            
            // Cache new data
            do {
                try await ImageCache.cacheLargeImage(url: photoUrlLarge, uuid: uuid)
            } catch {
                print("Error caching small image in ContentView, continuing... \(error)")
            }
        }
        
        // Try updating recipe
        try await RecipePersistence.updateRecipe(
            byUUID: uuid,
            cuisine: cuisine,
            name: name,
            photoUrlLarge: photoUrlLarge,
            photoUrlSmall: photoUrlSmall,
            sourceUrl: sourceUrl,
            youTubeURL: youTubeURL,
            in: managedContext)
    }
    
    /**
     Save Recipe
     
     Saves and caches images for a Recipe entity in CoreData.
     
     Parameters
     - uuid: String - The UUID of the recipe
     - dateAdded: Date = Date() - The date the recipe was added, defaults to the current date
     - cuisine: String?- The cuisine
     - name: String?- The updated name
     - photoUrlLarge: URL? - The url of the large photo
     - photoUrlSmall: URL? - The url of the small photo
     - sourceUrl: URL? - The url of the source
     - youTubeUrl: URL? - The YouTube url
     - managedContext: NSManagedObjectContext - The managed object context to save the recipe in
     */
    @discardableResult
    static func saveRecipe(
        uuid: String,
        dateAdded: Date = Date(),
        cuisine: String?,
        name: String?,
        photoUrlLarge: URL?,
        photoUrlSmall: URL?,
        sourceUrl: URL?,
        youTubeURL: URL?,
        in managedContext: NSManagedObjectContext
    ) async throws -> Recipe {
        // Cache small image
        if let photoUrlSmall {
            do {
                try await ImageCache.cacheSmallImage(url: photoUrlSmall, uuid: uuid)
            } catch {
                print("Error caching small image in ContentView, continuing... \(error)")
            }
        }
        
        // Cache large image
        if let photoUrlLarge {
            do {
                try await ImageCache.cacheLargeImage(url: photoUrlLarge, uuid: uuid)
            } catch {
                print("Error caching small image in ContentView, continuing... \(error)")
            }
        }
        
        // Save recipe
        return try await RecipePersistence.saveRecipe(
            uuid: uuid,
            dateAdded: dateAdded,
            cuisine: cuisine,
            name: name,
            photoUrlLarge: photoUrlLarge,
            photoUrlSmall: photoUrlSmall,
            sourceUrl: sourceUrl,
            youTubeURL: youTubeURL,
            in: managedContext)
    }
    
    static func deleteAll(in managedContext: NSManagedObjectContext) async throws {
        // Get recipes
        let recipes = try await managedContext.perform { try managedContext.fetch(Recipe.fetchRequest()) }
        
        // Delete caches
        for recipe in recipes {
            guard let uuid = recipe.uuid else { continue }
            
            // Delete small image data
            do {
                try await ImageCache.deleteSmallImageData(uuid: uuid)
            } catch {
                print("Error deleting small image data in ImageCacheRecipePersistence, continuing...")
            }
            
            // Delete large image data
            do {
                try await ImageCache.deleteLargeImageData(uuid: uuid)
            } catch {
                print("Error deleting large image data in ImageCacheRecipePersistence, continuing...")
            }
        }
        
        // Delete recipes
        try await RecipePersistence.deleteAll(in: managedContext)
    }
    
}
