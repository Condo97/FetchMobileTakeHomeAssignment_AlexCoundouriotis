//
//  ImageCacheDataPathResolver.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import Foundation

class ImageDataCachePathResolver {
    
    static let localSmallImagePathSuffix = "small"  // Suffix to be appended after uuid for small image name
    static let localLargeImagePathSuffix = "large"  // Suffix to be appended after uuid for large image name
    
    /**
     Small image data cache path
     
     Created by appending UUID with localSmallImagePathSuffix
     */
    static func smallImageDataCachePath(fromUUID uuid: String) -> String {
        uuid + localSmallImagePathSuffix
    }
    
    /**
     Large image data cache path
     
     Created by appending UUID with largeSmallImagePathSuffix
     */
    static func largeImageDataCachePath(fromUUID uuid: String) -> String {
        uuid + localLargeImagePathSuffix
    }
    
}
