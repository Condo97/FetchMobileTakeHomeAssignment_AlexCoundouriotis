//
//  GetRecipesResponseImageCacheRecipePersistence.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import CoreData
import Foundation

class GetRecipesResponseImageCacheRecipePersistence {
    
    /**
     Update Recipe by UUID
     
     Updates a recipe and its cached images if URL changed by UUID given the GetRecipeResponse Recipe in managed object context.
     
     Parameters
     - recipe: GetRecipesResponse.Recipe - The response recipe to update the CoreData recipe with
     - managedContext: NSManagedObjectContext - The managed object context to update the recipe in
     */
    static func updateRecipeByUUID(recipe: GetRecipesResponse.Recipe, in managedContext: NSManagedObjectContext) async throws {
        try await ImageCacheRecipePersistence.updateRecipe(
            byUUID: recipe.uuid,
            cuisine: recipe.cuisine,
            name: recipe.name,
            photoUrlLarge: recipe.photoUrlLarge == nil ? nil : URL(string: recipe.photoUrlLarge!),
            photoUrlSmall: recipe.photoUrlSmall == nil ? nil : URL(string: recipe.photoUrlSmall!),
            sourceUrl: recipe.sourceUrl == nil ? nil : URL(string: recipe.sourceUrl!),
            youTubeURL: recipe.youTubeUrl == nil ? nil : URL(string: recipe.youTubeUrl!),
            in: managedContext)
    }
    
    /**
     Save Recipe
     
     Save a recipe and cache its images given the GetRecipeResponse Recipe in managed object context.
     
     Parameters
     - recipe: GetRecipesResponse.Recipe - The response recipe to save
     - managedContext: NSManagedObjectContext - The managed object context to save the recipe in
     */
    static func saveRecipe(_ recipe: GetRecipesResponse.Recipe, in managedContext: NSManagedObjectContext) async throws {
        try await ImageCacheRecipePersistence.saveRecipe(
            uuid: recipe.uuid,
            cuisine: recipe.cuisine,
            name: recipe.name,
            photoUrlLarge: recipe.photoUrlLarge == nil ? nil : URL(string: recipe.photoUrlLarge!),
            photoUrlSmall: recipe.photoUrlSmall == nil ? nil : URL(string: recipe.photoUrlSmall!),
            sourceUrl: recipe.sourceUrl == nil ? nil : URL(string: recipe.sourceUrl!),
            youTubeURL: recipe.youTubeUrl == nil ? nil : URL(string: recipe.youTubeUrl!),
            in: managedContext)
    }
    
}
