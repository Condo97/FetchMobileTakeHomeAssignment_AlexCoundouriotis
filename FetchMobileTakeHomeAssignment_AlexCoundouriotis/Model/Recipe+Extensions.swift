//
//  Recipe+Extensions.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import Foundation
import UIKit

extension Recipe {
    
    /**
     Cached small image data
     
     The image data for the small image from DocumentSaver
     */
    var cachedSmallImageData: Data? {
        guard let uuid else {
            return nil
        }
        
        let smallImageDataCachePath = ImageDataCachePathResolver.smallImageDataCachePath(fromUUID: uuid)
        
        do {
            return try DocumentSaver.getData(from: smallImageDataCachePath)
        } catch {
            print("Error getting data from localPhotoSmallPath, returning nil... \(error)")
            return nil
        }
    }
    
    /**
     Cached large image data
     
     The image data for the large image from DocumentSaver
     */
    var cachedLargeImageData: Data? {
        guard let uuid else {
            return nil
        }
        
        let largeImageDataCachePath = ImageDataCachePathResolver.largeImageDataCachePath(fromUUID: uuid)
        
        do {
            return try DocumentSaver.getData(from: largeImageDataCachePath)
        } catch {
            print("Error getting data from localPhotoSmallPath, returning nil... \(error)")
            return nil
        }
    }
    
    /**
     Cached small image
     
     The read and decoded small image
     */
    var cachedSmallImage: UIImage? {
        guard let cachedSmallImageData else {
            return nil
        }
        
        return UIImage(data: cachedSmallImageData)
    }
    
    /**
     Cached large image
     
     The read and decoded large image
     */
    var cachedLargeImage: UIImage? {
        guard let cachedLargeImageData else {
            return nil
        }
        
        return UIImage(data: cachedLargeImageData)
    }
    
}
