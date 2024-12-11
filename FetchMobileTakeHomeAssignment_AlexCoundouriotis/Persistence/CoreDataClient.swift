//
//  CoreDataClient.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import CoreData
import Foundation

class CoreDataClient {
    
    public static let mainManagedObjectContext: NSManagedObjectContext = persistentContainer.viewContext    // The static managed context for the app
    
    public static let modelName = "FetchMobileTakeHomeAssignment_AlexCoundouriotis"     // The CoreData model name
    
    // The static persistent container with loaded persistent stores
    private static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: {description, error in
            if let error = error as? NSError {
                fatalError("Couldn't load persistent stores!\n\(error)\n\(error.userInfo)")
            }
        })
        return container
    }()
    
}
