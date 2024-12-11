//
//  RecipeUpdater.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import Foundation
import SwiftUI

class RecipeDownloader {
    
    /**
     Download Recipes
     
     Downloads recipes from a given url.
     
     Parameters
     - url: URL - The url to download the recipe from
     */
    static func downloadRecipes(from url: URL) async throws -> GetRecipesResponse {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        return try JSONDecoder().decode(GetRecipesResponse.self, from: data)
    }
    
}
