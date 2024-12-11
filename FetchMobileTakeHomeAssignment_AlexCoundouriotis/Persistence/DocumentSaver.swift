//
//  DocumentSaver.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import Foundation
import UIKit

class DocumentSaver {
    
    /**
     Save
     
     Saves data to a path in user documents directory.
     
     Parameters
     - data: Data - The data to save
     - path: String - The file name which can include a path of the file's desired location
     */
    static func save(data: Data, to path: String) throws {
        let url = URL.documentsDirectory.appending(path: path)
        
        try data.write(to: url)
    }
    
    /**
     Get Data
     
     Gets data from a path in the user documents directory.
     
     Parameters
     - path: String - The path to get the data from
     */
    static func getData(from path: String) throws -> Data? {
        let url = URL.documentsDirectory.appending(path: path)
        
        return try Data(contentsOf: url)
    }
    
    /**
     Get Full URL
     
     Gets the full documents directory url for the path.
     
     Parameters
     - path: String - The path to get the documents directory url from
     */
    static func getFullURL(from path: String) -> URL {
        URL.documentsDirectory.appending(path: path)
    }
    
    /**
     Delete
     
     Deletes a file at the specified path in the user documents directory.
     
     Parameters:
     - path: String - The path of the file to delete
     */
    static func delete(from path: String) throws {
        let url = URL.documentsDirectory.appending(path: path)
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
    
}
