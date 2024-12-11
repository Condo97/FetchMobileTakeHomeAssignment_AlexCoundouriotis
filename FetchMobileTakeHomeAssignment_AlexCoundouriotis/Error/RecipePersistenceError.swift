//
//  RecipePersistenceError.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import Foundation

enum RecipePersistenceError: Error {
    
    case nonexistantRecipe      // Used when a recipe was supposed to be returned but does not exist
    
}
