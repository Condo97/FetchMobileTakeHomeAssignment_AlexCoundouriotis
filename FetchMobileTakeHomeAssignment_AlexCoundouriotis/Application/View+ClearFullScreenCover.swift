//
//  ClearFullScreenCover+View.swift
//  WriteSmith-SwiftUI
//
//  Created by Alex Coundouriotis on 11/16/23.

import Foundation
import SwiftUI

struct ClearFullScreenCoverView: UIViewRepresentable {
    
    @State var blurEffectStyle: UIBlurEffect.Style  // The system blur effect style
    @State var fadeDelay: CGFloat = 0.1             // Delay to fade
    @State var fadeDuration: CGFloat = 0.4          // Duration to fade
    
    func makeUIView(context: Context) -> UIView {
        // Use system blur visual effect
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
        view.alpha = 0.0
        
        DispatchQueue.main.async {
            // Set superview background color to clear to ensure transparency
            view.superview?.superview?.backgroundColor = .clear
            
            // Fade in the blur effect
            UIView.animate(withDuration: fadeDuration, delay: fadeDelay, animations: {
                view.alpha = 1.0
            })
        }
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

extension View {
    
    /**
     Clear Full Screen Cover
     
     Takes an item and displays content atop a transparent full screen cover with system blur effect.
     
     Parameters
     - item: Binding<Item?> - The binding optional item to control presentation
     - blurStyle: UIBlurEffect.Style - The system blur visual effect style
     - fadeDelay: CGFloat - The delay before fading the background between transitions
     - fadeDuration: CGfloat - The duration to fade the background during transitions
     - backgroundTapDismisses: Bool - Determine if a tap in the background dismisses the view, great for popups!
     - onDismiss: (() -> Void)? - Optional closure called on dismiss
     - @ViewBuilder content: @escaping (Item) -> Content - The sub content
     */
    func clearFullScreenCover<Content: View, Item: Identifiable>(item: Binding<Item?>, blurStyle: UIBlurEffect.Style = .dark, fadeDelay: CGFloat = 0.1, fadeDuration: CGFloat = 0.4, onDismiss: (()->Void)? = nil, backgroundTapDismisses: Bool = true, @ViewBuilder content: @escaping (Item)->Content) -> some View {
        self
            .fullScreenCover(item: item, onDismiss: onDismiss) { argItem in
                popupContent(
                    blurStyle: blurStyle,
                    fadeDelay: fadeDelay,
                    fadeDuration: fadeDuration,
                    backgroundTapDismisses: backgroundTapDismisses,
                    didTapBackground: { item.wrappedValue = nil },
                    content: {
                        content(argItem)
                    })
            }
    }
    
    /**
     Clear Full Screen Cover
     
     Displays content atop a transparent full screen cover with system blur effect based on a boolean flag.
     
     Parameters
     - isPresented: Binding<Bool> - The binding boolean flag to control presentation
     - blurStyle: UIBlurEffect.Style - The system blur visual effect style
     - fadeDelay: CGFloat - The delay before fading the background between transitions
     - fadeDuration: CGfloat - The duration to fade the background during transitions
     - backgroundTapDismisses: Bool - Allow for taps in the background dismisses the view, great for popups!
     - onDismiss: (() -> Void)? - Optional closure called on dismiss
     - @ViewBuilder content: @escaping (Item) -> Content - The sub content
     */
    func clearFullScreenCover<Content: View>(isPresented: Binding<Bool>, blurStyle: UIBlurEffect.Style = .dark, fadeDelay: CGFloat = 0.1, fadeDuration: CGFloat = 0.4, backgroundTapDismisses: Bool = true, onDismiss: (()->Void)? = nil, @ViewBuilder content: @escaping ()->Content) -> some View {
        self
            .fullScreenCover(isPresented: isPresented, onDismiss: onDismiss, content: {
                popupContent(
                    blurStyle: blurStyle,
                    fadeDelay: fadeDelay,
                    fadeDuration: fadeDuration,
                    backgroundTapDismisses: backgroundTapDismisses,
                    didTapBackground: { isPresented.wrappedValue = false },
                    content: content)
            })
    }
    
    /**
     Popup Content
     
     Takes an item and displays content atop a transparent full screen cover with system blur effect.
     
     Parameters
     - blurStyle: UIBlurEffect.Style - The system blur visual effect style
     - fadeDelay: CGFloat - The delay before fading the background between transitions
     - fadeDuration: CGfloat - The duration to fade the background during transitions
     - backgroundTapDismisses: Bool - Allow for taps in the background dismisses the view, great for popups!
     - didTapBackground: (() -> Void)? - Called if user tapped background and backgroundTapDismissses is true
     - @ViewBuilder content: @escaping (Item) -> Content - The sub content
     */
    fileprivate func popupContent<Content: View>(blurStyle: UIBlurEffect.Style, fadeDelay: CGFloat, fadeDuration: CGFloat, backgroundTapDismisses: Bool, didTapBackground: (()->Void)?, @ViewBuilder content: @escaping ()->Content) -> some View {
        ZStack {
            Color.clear
            
            content()
                .transition(.opacity)
        }
        .background(
            ClearFullScreenCoverView(
                blurEffectStyle: blurStyle,
                fadeDelay: fadeDelay,
                fadeDuration: fadeDuration)
            .ignoresSafeArea()
            .onTapGesture {
                if backgroundTapDismisses {
                    didTapBackground?()
                }
            }
        )
    }
    
}
