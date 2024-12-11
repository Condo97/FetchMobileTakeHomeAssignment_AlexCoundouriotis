//
//  GetRecipeResponse.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import Foundation

struct GetRecipesResponse: Codable {
    
    struct Recipe: Codable {
        
        let cuisine: String
        let photoUrlLarge: String?
        let photoUrlSmall: String?
        let name: String
        let sourceUrl: String?
        let uuid: String
        let youTubeUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case cuisine
            case photoUrlLarge = "photo_url_large"
            case photoUrlSmall = "photo_url_small"
            case name
            case sourceUrl = "source_url"
            case uuid
            case youTubeUrl = "youtube_url"
        }
        
    }
    
    var recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipes
    }
    
}
