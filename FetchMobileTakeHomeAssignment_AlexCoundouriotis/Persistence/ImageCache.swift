//
//  ImageCache.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import CoreData
import Foundation

class ImageCache {
    
    /**
     Cache Small Image
     
     Caches the small image for the recipe. If there is already a cached image, the function throws.
     
     Parameters:
     - url: URL - The URL to pull the image from
     - uuid: String - The UUID to save the image to
     */
    static func cacheSmallImage(
        url: URL,
        uuid: String
    ) async throws {
        // Get local path
        let localPath = ImageDataCachePathResolver.smallImageDataCachePath(fromUUID: uuid)
        
        // Cache image data from url
        try await ImageCache.cacheImageDataFromURL(url, path: localPath)
    }
    
    /**
     Cache Large Image
     
     Caches the large image for the recipe. If there is already a cached image, the function throws.
     
     Parameters:
     - url: URL - The URL to pull the image from
     - uuid: String - The UUID to save the image to
     */
    static func cacheLargeImage(
        url: URL,
        uuid: String
    ) async throws {
        // Get local path
        let localPath = ImageDataCachePathResolver.largeImageDataCachePath(fromUUID: uuid)
        
        // Cache image data from url
        try await ImageCache.cacheImageDataFromURL(url, path: localPath)
    }
    
    /**
     Delete Small Image Data
     
     Deletes small image data from the path.
     
     Parameters:
     - uuid: String - The UUID to delete the image for
     */
    static func deleteSmallImageData(
        uuid: String
    ) async throws {
        // Get local path
        let localPath = ImageDataCachePathResolver.smallImageDataCachePath(fromUUID: uuid)
        
        // Delete
        try DocumentSaver.delete(from: localPath)
    }
    
    /**
     Delete Large Image Data
     
     Deletes large image data from the path.
     
     Parameters:
     - uuid: String - The UUID to delete the image for
     */
    static func deleteLargeImageData(
        uuid: String
    ) async throws {
        // Get local path
        let localPath = ImageDataCachePathResolver.largeImageDataCachePath(fromUUID: uuid)
        
        // Delete
        try DocumentSaver.delete(from: localPath)
    }
    
    /**
     Cache Image Data
     
     Gets image data from URL and saves it to user's documents directory.
     
     Parameters:
     - url: URL - The URL of the image
     - path: String - The path to save the data
     */
    private static func cacheImageDataFromURL(
        _ url: URL,
        path: String
    ) async throws {
        // Get image data
        let (data, _) = try await URLSession.shared.data(from: url)
        
        try DocumentSaver.save(data: data, to: path)
    }
    
}
