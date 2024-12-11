//
//  LoadingView.swift
//  FetchMobileTakeHomeAssignment_AlexCoundouriotis
//
//  Created by Alex Coundouriotis on 12/10/24.
//

import SwiftUI

struct LoadingView: View {
    
    /**
     A little loading view
     */
    
    var body: some View {
        VStack {
            Text("Loading")
                .font(.headline)
            ProgressView()
        }
        .foregroundStyle(Colors.text)
    }
    
}

#Preview {
    
    LoadingView()
    
}
