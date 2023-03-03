//
//  Obvious_ProjectApp.swift
//  Obvious-Project
//
//  Created by Babul Raj on 02/03/23.
//

import SwiftUI

@main
struct Obvious_ProjectApp: App {
    var body: some Scene {
        WindowGroup {
            GalleryRouter().initialiseGallery()
        }
    }
}
