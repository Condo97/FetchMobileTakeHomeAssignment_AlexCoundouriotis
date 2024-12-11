//
//  SortedRecipeMiniButtonList.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/11/24.
//

import SwiftUI

struct SortedRecipeMiniButtonList: View {
    
    /**
     Sorted Recipe Mini Button List
     
     The recipe mini button list with binding for sorting.
     
     Parameters:
     - isLoading: Binding<Boo> - Flag to control disabling of various view elements
     - selectedSortItem: Binding<SortItem> - The method and order to sort
     - onTap: (Recipe) -> Void - Closure called when a recipe is tapped
     */
    
    @Binding var isLoading: Bool
    @Binding var selectedSortItem: SortItem
    let onTap: (Recipe) -> Void
    
    /**
     Sort Methods
     
     The available sort methods and their display strings.
     */
    enum SortMethods: CaseIterable {
        case cuisine, dateAdded, name
        
        // The display strings for elements
        var displayString: String {
            switch self {
            case .cuisine: "Cuisine"
            case .dateAdded: "Date"
            case .name: "Name"
            }
        }
    }
    
    /**
     Sort Orders
     
     The available sort orders.
     */
    enum SortOrders: CaseIterable {
        case asc, desc
    }
    
    /**
     Sort Item
     
     A struct containing the current sort method and order.
     
     Parameters
     - method: SortMethods - The current sort method
     - order: SortOrders - The current sort order
     */
    struct SortItem {
        var method: SortMethods
        var order: SortOrders
    }
    
    // The computed fetch request for the recipe list
    private var recipesFetchRequest: FetchRequest<Recipe> {
        // Set ascending boolean to order
        let ascending = selectedSortItem.order == .asc
        
        // Get the sort descriptor according to the method TODO: Research if it is better to keep a computed value in the SortMethods directly, and how to actually do so with these keyPaths
        let sortDescriptor = switch selectedSortItem.method {
        case .cuisine:      NSSortDescriptor(keyPath: \Recipe.cuisine, ascending: ascending)
        case .dateAdded:    NSSortDescriptor(keyPath: \Recipe.dateAdded, ascending: ascending)
        case .name:         NSSortDescriptor(keyPath: \Recipe.name, ascending: ascending)
        }
        
        // Return fetch request
        return FetchRequest(sortDescriptors: [sortDescriptor])
    }
    
    var body: some View {
        RecipeMiniButtonList(
            recipes: recipesFetchRequest,
            isLoading: $isLoading,
            onTap: onTap)
    }
    
}

#Preview {
    
    SortedRecipeMiniButtonList(
        isLoading: .constant(true),
        selectedSortItem: .constant(SortedRecipeMiniButtonList.SortItem(method: .name, order: .desc)),
        onTap: { recipe in
            
        }
    )
    
}
