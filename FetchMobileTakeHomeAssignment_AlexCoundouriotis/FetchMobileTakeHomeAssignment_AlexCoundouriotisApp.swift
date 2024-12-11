//
//  FetchMobileTakeHomeAssignment_AlexCoundouriotisApp.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI

@main
struct FetchMobileTakeHomeAssignment_AlexCoundouriotisApp: App {
    
    init() {
        UIView.appearance().tintColor = UIColor(Colors.buttonBackground)
    }

    var body: some Scene {
        WindowGroup {
            // Show RecipeView with the full url
            RecipeView()
                .environment(\.managedObjectContext, CoreDataClient.mainManagedObjectContext)
        }
    }
    
}
