//
//  RecipePersistence.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import CoreData
import Foundation

class RecipePersistence {
    
    /**
     Update Recipe
     
     Updates a Recipe entity in CoreData by UUID.
     
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
        
        // Update recipe
        try await managedContext.perform {
            recipe.name = name
            recipe.cuisine = cuisine
            recipe.photoUrlLarge = photoUrlLarge
            recipe.photoUrlSmall = photoUrlSmall
            recipe.sourceUrl = sourceUrl
            recipe.youTubeUrl = youTubeURL
            
            try managedContext.save()
        }
    }
    
    /**
     Save Recipe
     
     Saves a Recipe entity in CoreData.
     
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
        // Create recipe
        try await managedContext.perform {
            let recipe = Recipe(context: managedContext)
            
            recipe.uuid = uuid
            recipe.dateAdded = dateAdded
            recipe.cuisine = cuisine
            recipe.name = name
            recipe.photoUrlLarge = photoUrlLarge
            recipe.photoUrlSmall = photoUrlSmall
            recipe.sourceUrl = sourceUrl
            recipe.youTubeUrl = youTubeURL
            
            try managedContext.save()
            
            return recipe
        }
    }
    
    /**
     Delete
     
     Deletes a recipe.
     
     Parameters
     - managedContext: NSManagedObjectContext - The managed object context for the recipe
     */
    static func deleteAll(in managedContext: NSManagedObjectContext) async throws {
        try await managedContext.perform {
            let recipes = try managedContext.fetch(Recipe.fetchRequest())
            
            for recipe in recipes {
                managedContext.delete(recipe)
            }
            
            try managedContext.save()
        }
    }
    
}
