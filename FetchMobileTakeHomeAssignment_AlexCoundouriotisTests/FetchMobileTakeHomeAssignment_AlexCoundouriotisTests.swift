//
//  FetchMobileTakeHomeAssignment_AlexCoundouriotisTests.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotisTests
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import CoreData
import Foundation
import Testing
@testable import FetchMobileTakeHomeAssignment_AlexCoundouriotis

struct FetchMobileTakeHomeAssignment_AlexCoundouriotisTests {
    
    let completeJSONURLString = Constants.completeJSONURLString
    let incompleteJSONURLString = Constants.incompleteJSONURLString
    let emptyJSONURLString = Constants.emptyJSONURLString
    
    let container = {
        let container = NSPersistentContainer(name: CoreDataClient.modelName)
        
        let description = NSPersistentStoreDescription()
                description.url = URL(fileURLWithPath: "/dev/null")
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error as? NSError {
                fatalError("Couldn't load persistent stores!\n\(error)\n\(error.userInfo)")
            }
        })
        return container
    }()
    
    var managedContext: NSManagedObjectContext {
        container.viewContext
    }
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func test_RecipeUpdater_CompleteJSON() async throws {
        guard let url = URL(string: completeJSONURLString) else {
            print("Could not unwrap URL with string.")
            return
        }
        
        let getRecipeResponse = try await RecipeDownloader.downloadRecipes(from: url)
        #expect(getRecipeResponse.recipes.contains(where: { !$0.cuisine.isEmpty }), "GetRecipeResponse is missing cuisine")
        #expect(getRecipeResponse.recipes.contains(where: { !$0.name.isEmpty }), "GetRecipeResponse is missing name")
        #expect(getRecipeResponse.recipes.contains(where: { $0.photoUrlLarge != nil && !$0.photoUrlLarge!.isEmpty }), "GetRecipeResponse is missing photo URL large")
        #expect(getRecipeResponse.recipes.contains(where: { $0.photoUrlSmall != nil && !$0.photoUrlSmall!.isEmpty }), "GetRecipeResponse is missing photo URL small")
        #expect(getRecipeResponse.recipes.contains(where: { $0.sourceUrl != nil && !$0.sourceUrl!.isEmpty }), "GetRecipeResponse is missing source URL")
        #expect(getRecipeResponse.recipes.contains(where: { !$0.uuid.isEmpty }), "GetRecipeResponse is missing UUID")
        #expect(getRecipeResponse.recipes.contains(where: { $0.youTubeUrl != nil && !$0.youTubeUrl!.isEmpty }), "GetRecipeResponse is missing YouTube URL")
    }
    
    @Test func test_RecipeUpdater_IncompleteJSON() async throws {
        guard let url = URL(string: incompleteJSONURLString) else {
            print("Could not unwrap URL with string.")
            return
        }
        
        do {
            let _ = try await RecipeDownloader.downloadRecipes(from: url)
            #expect(Bool(false), "Did not throw JSON formatting error when downloading recipe.. did not throw error!")
        } catch Swift.DecodingError.keyNotFound( _, _) {
            #expect(true, "Threw JSON formatting error when downloading recipe")
        } catch {
            #expect(Bool(false), "Did not throw JSON formatting error when downloading recipe.. threw incorrect error!")
        }
    }
    
    @Test func test_RecipeUpdater_EmptyJSON() async throws {
        guard let url = URL(string: emptyJSONURLString) else {
            print("Could not unwrap URL with string.")
            return
        }
        
        let getRecipeResponse = try await RecipeDownloader.downloadRecipes(from: url)
        #expect(getRecipeResponse.recipes.isEmpty, "GetRecipeResponse recipes should be empty")
    }
    
    @Test func testSaveRecipe() async throws {
        // Test saving recipe
        let uuid = "testUUID"
        let dateAdded = Date()
        
        // Create recipe
        let recipe = try await RecipePersistence.saveRecipe(
            uuid: uuid,
            dateAdded: dateAdded,
            cuisine: "TestCuisine",
            name: "TestName",
            photoUrlLarge: nil,
            photoUrlSmall: nil,
            sourceUrl: nil,
            youTubeURL: nil,
            in: managedContext)
        
        // Check immediately saved recipe values
        #expect(recipe.uuid == uuid, "Immediate recipe UUID does not match target UUID.")
        #expect(recipe.cuisine == "TestCuisine", "Immediate recipe cuisine does not match target cuisine.")
        #expect(recipe.name == "TestName", "Immediate recipe name does not match target name.")
        
        // Check fetched saved recipe values
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Recipe.uuid), uuid)
        
        let results = try managedContext.fetch(fetchRequest)
        #expect(results.count == 1, "Expected one recipe but more or fewer were found.")
        #expect(results.first?.uuid == uuid, "Recipe UUID does not match target UUID.")
    }
    
    @Test func testUpdateRecipe() async throws {
        // Test updating recipe
        
        let uuid = "testUUID"
        let dateAdded = Date()
        
        // Save recipe
        _ = try await RecipePersistence.saveRecipe(
            uuid: uuid,
            dateAdded: dateAdded,
            cuisine: "OriginalCuisine",
            name: "OriginalName",
            photoUrlLarge: nil,
            photoUrlSmall: nil,
            sourceUrl: nil,
            youTubeURL: nil,
            in: managedContext)
        
        let updatedCuisine = "UpdatedCuisine"
        let updatedName = "UpdatedName"
        
        // Update recipe
        try await RecipePersistence.updateRecipe(
            byUUID: uuid,
            cuisine: updatedCuisine,
            name: updatedName,
            photoUrlLarge: nil,
            photoUrlSmall: nil,
            sourceUrl: nil,
            youTubeURL: nil,
            in: managedContext)
        
        // Check for updated values
        let fetchRequest = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Recipe.uuid), uuid)
        
        let results = try managedContext.fetch(fetchRequest)
        #expect(results.count == 1, "Expected one recipe but more or fewer were found.")
        
        let updatedRecipe = results.first!
        #expect(updatedRecipe.cuisine == updatedCuisine, "Updated recipe cuisine does not match target cuisine.")
        #expect(updatedRecipe.name == updatedName, "Updated recipe name does not match target name.")
    }
    
    // Test ImageCache's ability to save and retrieve image data
    @Test func testImageCache_saveAndRetrieveImageData() throws {
        let uuid = "testUUID"
        let imageData = "TestImageData".data(using: .utf8)!
        let imageDataPath = ImageDataCachePathResolver.smallImageDataCachePath(fromUUID: uuid)
        
        // Save
        try DocumentSaver.save(data: imageData, to: imageDataPath)
        
        // Retreive
        let retrievedData = try DocumentSaver.getData(from: imageDataPath)
        #expect(retrievedData == imageData, "Retreived data does not equal expected image data.")
    }
    
    // Test ImageCache's ability to save and delete image data
    @Test func testImageCache_saveAndDeleteImageData() throws {
        let uuid = "testUUID"
        let imageData = "TestImageData".data(using: .utf8)!
        let imageDataPath = ImageDataCachePathResolver.smallImageDataCachePath(fromUUID: uuid)
        
        // Save
        try DocumentSaver.save(data: imageData, to: imageDataPath)
        
        
        // Retreive
        let retrievedDataBeforeDeletion = try DocumentSaver.getData(from: imageDataPath)
        #expect(retrievedDataBeforeDeletion == imageData, "Retreived data does not equal expected image data.")
        
        // Delete
        try DocumentSaver.delete(from: imageDataPath)
        
        // Then
        do {
            let retrievedDataAfterDeletion = try DocumentSaver.getData(from: imageDataPath)
            #expect(retrievedDataAfterDeletion == nil, "Retrieved unexpected data.")
        } catch let error as NSError {
            // Check for NSCocoaErrorDomain Code=260
            if error.domain == NSCocoaErrorDomain && error.code == 260 {
                #expect(true, "Threw correct error")
            } else {
                throw error
            }
            
        }
    }
    
}
